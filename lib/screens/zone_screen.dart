import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/house_service.dart';
import '../services/notification_service.dart';
import 'timer_screen.dart';
import 'task_notes_screen.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key});

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  late String selectedZone;
  late List<Map<String, dynamic>> tasks;
  late Map<String, bool> taskCompletion;
  List<String> availableZones = [];
  bool _isLoading = true;
  bool _isMixedMode = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    selectedZone = await HouseService.getTodayZone();
    availableZones = await HouseService.getAllZones();
    _isMixedMode = await HouseService.getMixedZoneMode();
    await _loadTasks();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadTasks() async {
    if (_isMixedMode) {
      // Load all tasks from all zones and mix them up
      tasks = await _loadMixedTasks();
      taskCompletion = _getMixedTaskCompletions();
    } else {
      // Normal mode - load tasks for selected zone only
      final zoneTasks = await HouseService.getZoneTasks(selectedZone);
      tasks = zoneTasks.map((task) => Map<String, dynamic>.from(task)).toList();
      taskCompletion = HouseService.getAllZoneTaskCompletions(selectedZone);
    }
  }

  Future<List<Map<String, dynamic>>> _loadMixedTasks() async {
    // Get all zones except 'Reset'
    final zones = availableZones.where((z) => z != 'Reset').toList();
    
    // Load all tasks for each zone
    Map<String, List<Map<String, String>>> zoneTasksMap = {};
    int maxTaskCount = 0;
    
    for (var zone in zones) {
      final zoneTasks = await HouseService.getZoneTasks(zone);
      if (zoneTasks.isNotEmpty) {
        zoneTasksMap[zone] = zoneTasks;
        if (zoneTasks.length > maxTaskCount) {
          maxTaskCount = zoneTasks.length;
        }
      }
    }
    
    // Mix tasks: Task 1 from each zone, then Task 2 from each zone, etc.
    List<Map<String, dynamic>> mixedTasks = [];
    
    for (int taskIndex = 0; taskIndex < maxTaskCount; taskIndex++) {
      // Shuffle zone order for this task number to add more variety
      final shuffledZones = List<String>.from(zoneTasksMap.keys)..shuffle();
      
      for (var zone in shuffledZones) {
        final tasks = zoneTasksMap[zone]!;
        if (taskIndex < tasks.length) {
          mixedTasks.add({
            'task': tasks[taskIndex]['task']!,
            'howTo': tasks[taskIndex]['howTo']!,
            'zone': zone,  // Store original zone
            'originalIndex': taskIndex,  // Store original task index
          });
        }
      }
    }
    
    return mixedTasks;
  }

  Map<String, bool> _getMixedTaskCompletions() {
    final completions = <String, bool>{};
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final zone = task['zone'] as String;
      final originalIndex = task['originalIndex'] as int;
      final isCompleted = HouseService.getZoneTaskCompletion(zone, originalIndex);
      completions['$i'] = isCompleted;
    }
    return completions;
  }

  Future<void> _changeZone(String zone) async {
    setState(() {
      selectedZone = zone;
      _isLoading = true;
    });
    await _loadTasks();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completedCount = taskCompletion.values.where((v) => v).length;
    final totalCount = tasks.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isMixedMode ? 'Mixed Zones Mode' : 'Zone Cleaning'),
        actions: [
          // Mix Zones toggle
          IconButton(
            icon: Icon(_isMixedMode ? Icons.shuffle : Icons.shuffle_outlined),
            onPressed: () async {
              setState(() {
                _isMixedMode = !_isMixedMode;
                _isLoading = true;
              });
              await HouseService.setMixedZoneMode(_isMixedMode);
              await _loadTasks();
              setState(() {
                _isLoading = false;
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isMixedMode 
                      ? '🎲 Mixed Zones Mode: Tasks from all zones!'
                      : '📍 Normal Mode: One zone at a time'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            tooltip: _isMixedMode ? 'Disable Mix Mode' : 'Enable Mix Mode',
          ),
          if (!_isMixedMode) ...[
            IconButton(
              icon: const Icon(Icons.add_task),
              onPressed: _showAddTaskDialog,
              tooltip: 'Add Task',
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              onSelected: _changeZone,
              itemBuilder: (context) {
                return availableZones.map((zone) {
                  return PopupMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList();
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Zone header with progress
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isMixedMode)
                      const Icon(Icons.shuffle, size: 24),
                    if (_isMixedMode)
                      const SizedBox(width: 8),
                    Text(
                      _isMixedMode ? 'All Zones Mixed!' : selectedZone,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isMixedMode 
                    ? '$completedCount of $totalCount tasks completed across all zones'
                    : '$completedCount of $totalCount tasks completed',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cleaning_services_outlined,
                          size: 80,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks for this zone',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final isCompleted = taskCompletion['$index'] ?? false;
                      final taskZone = _isMixedMode ? (task['zone'] as String) : selectedZone;
                      final taskIndex = _isMixedMode ? (task['originalIndex'] as int) : index;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            leading: Checkbox(
                              value: isCompleted,
                              onChanged: (value) async {
                                final newValue = value ?? false;
                                await HouseService.setZoneTaskCompletion(
                                  taskZone, 
                                  taskIndex, 
                                  newValue,
                                );
                                setState(() {
                                  taskCompletion['$index'] = newValue;
                                });
                              },
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_isMixedMode)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getZoneColor(taskZone),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      taskZone,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                if (_isMixedMode)
                                  const SizedBox(height: 4),
                                Text(
                                  task['task'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.note_outlined),
                                  onPressed: () async {
                                    final taskId = '${taskZone}_${taskIndex}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskNotesScreen(
                                          taskId: taskId,
                                          taskName: task['task'] ?? '',
                                          zone: taskZone,
                                        ),
                                      ),
                                    );
                                    setState(() {}); // Refresh to show note indicator
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.timer_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TimerScreen(
                                          taskName: task['task'] ?? '',
                                          zone: taskZone,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'How to do it:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      task['howTo'] ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(completedCount, totalCount),
    );
  }

  Widget? _buildFloatingActionButton(int completedCount, int totalCount) {
    // Show celebration button if all tasks completed
    if (completedCount == totalCount && totalCount > 0) {
      return FloatingActionButton.extended(
        onPressed: () async {
          // Show motivational notification
          await NotificationService.showMotivationalNotification();
          
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('🎉 Zone Complete!'),
                content: Text(
                  'Great job! You\'ve completed all $totalCount tasks in $selectedZone!',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        taskCompletion = {
                          for (int i = 0; i < tasks.length; i++) '$i': false
                        };
                      });
                    },
                    child: const Text('Reset'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        icon: const Icon(Icons.celebration),
        label: const Text('Complete!'),
      );
    }
    
    // Show add tasks button if zone has no tasks
    if (totalCount == 0) {
      return FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Tasks'),
      );
    }
    
    return null;
  }

  void _showAddTaskDialog() {
    final taskController = TextEditingController();
    final howToController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task to $selectedZone'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  hintText: 'e.g., Clean garage floor',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: howToController,
                decoration: const InputDecoration(
                  labelText: 'How to do it',
                  hintText: 'Brief instructions...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (taskController.text.isNotEmpty) {
                final newTask = {
                  'task': taskController.text,
                  'howTo': howToController.text.isEmpty 
                      ? 'No instructions provided' 
                      : howToController.text,
                };
                
                // Add to current tasks list
                final updatedTasks = [...tasks, newTask];
                
                // Save to SharedPreferences
                await HouseService.saveZoneTasks(
                  selectedZone, 
                  updatedTasks.map((t) => Map<String, String>.from(t)).toList(),
                );
                
                // Reload tasks
                await _loadTasks();
                setState(() {
                  _isLoading = false;
                });
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task added successfully')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Color _getZoneColor(String zone) {
    // Assign different colors to different zones
    const zoneColors = {
      'Kitchen': Colors.orange,
      'Bathroom': Colors.blue,
      'Bedroom': Colors.purple,
      'Living Room': Colors.green,
      'Laundry Room': Colors.teal,
      'Office': Colors.brown,
    };
    return zoneColors[zone] ?? Colors.grey;
  }
}
