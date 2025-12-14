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
  bool _isMixedMode = false; // New: Mixed Zones Mode toggle

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    selectedZone = await HouseService.getTodayZone();
    availableZones = await HouseService.getAllZones();
    await _loadTasks();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadTasks() async {
    if (_isMixedMode) {
      // Load ALL tasks from ALL zones
      List<Map<String, dynamic>> allTasks = [];
      taskCompletion = {};
      
      for (String zone in availableZones) {
        final zoneTasks = await HouseService.getZoneTasks(zone);
        final zoneCompletions = HouseService.getAllZoneTaskCompletions(zone);
        
        // Add zone info and color to each task
        for (int i = 0; i < zoneTasks.length; i++) {
          final taskWithZone = Map<String, dynamic>.from(zoneTasks[i]);
          taskWithZone['zone'] = zone;
          taskWithZone['zoneColor'] = _getZoneColor(zone);
          taskWithZone['zoneIndex'] = i; // Store original index
          taskWithZone['taskKey'] = '${zone}_$i'; // Unique key for completion
          allTasks.add(taskWithZone);
        }
        
        // Merge completions with zone-prefixed keys
        zoneCompletions.forEach((key, value) {
          taskCompletion['${zone}_$key'] = value;
        });
      }
      
      tasks = allTasks;
    } else {
      // Load single zone (original behavior)
      final zoneTasks = await HouseService.getZoneTasks(selectedZone);
      tasks = zoneTasks.map((task) => Map<String, dynamic>.from(task)).toList();
      
      // Load completion state from persistence
      taskCompletion = HouseService.getAllZoneTaskCompletions(selectedZone);
    }
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

  bool _isCustomZone(String zone) {
    final defaultZones = [
      'Kitchen',
      'Bathroom',
      'Bedroom',
      'Living Room',
      'Laundry Room',
      'Office',
      'Reset',
    ];
    return !defaultZones.contains(zone);
  }

  Color _getZoneColor(String zone) {
    // Return color based on zone name (matches phone app)
    switch (zone) {
      case 'Kitchen':
        return Colors.blue;
      case 'Bathroom':
        return Colors.cyan;
      case 'Bedroom':
        return Colors.purple;
      case 'Living Room':
        return Colors.green;
      case 'Laundry Room':
        return Colors.orange;
      case 'Office':
        return Colors.red;
      case 'Reset':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
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
          // Mixed Mode Toggle
          IconButton(
            icon: Icon(_isMixedMode ? Icons.close : Icons.apps),
            onPressed: () async {
              setState(() {
                _isMixedMode = !_isMixedMode;
                _isLoading = true;
              });
              await _loadTasks();
              setState(() {
                _isLoading = false;
              });
            },
            tooltip: _isMixedMode ? 'Exit Mixed Mode' : 'Mixed Zones Mode',
          ),
          // Add Task button (hide in mixed mode)
          if (!_isMixedMode)
            IconButton(
              icon: const Icon(Icons.add_task),
              onPressed: () {
                print('Add Task button clicked for zone: $selectedZone'); // Debug
                _showAddTaskDialog();
              },
              tooltip: 'Add Task',
            ),
          // Zone filter (hide in mixed mode)
          if (!_isMixedMode)
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
                if (_isMixedMode) ..[
                  const Icon(Icons.apps, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'All Zones Mixed!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ] else ..[
                  Text(
                    selectedZone,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
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
                        if (_isCustomZone(selectedZone)) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Tap the ➕ button above to add tasks',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final taskKey = _isMixedMode ? task['taskKey'] : '$index';
                      final taskZone = _isMixedMode ? task['zone'] ?? selectedZone : selectedZone;
                      final taskIndex = _isMixedMode ? task['zoneIndex'] ?? index : index;
                      final isCompleted = taskCompletion[taskKey] ?? false;
                      
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
                                  taskCompletion[taskKey] = newValue;
                                });
                              },
                            ),
                            title: Row(
                              children: [
                                // Zone badge (only in mixed mode)
                                if (_isMixedMode && task['zone'] != null) ..[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: task['zoneColor'] ?? Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      task['zone'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                Expanded(
                                  child: Text(
                                    task['task'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isCustomZone(taskZone) && !_isMixedMode)
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () => _showEditTaskDialog(taskIndex),
                                    tooltip: 'Edit Task',
                                  ),
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
      bottomNavigationBar: _isMixedMode 
        ? Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎨 ', style: TextStyle(fontSize: 16)),
                Text(
                  'Mixed Zones Mode: Tasks from all zones!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        : null,
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
                autofocus: true,
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
              if (taskController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a task name')),
                );
                return;
              }

              try {
                final newTask = {
                  'task': taskController.text.trim(),
                  'howTo': howToController.text.trim().isEmpty 
                      ? 'No instructions provided' 
                      : howToController.text.trim(),
                };
                
                // Add to current tasks list
                final updatedTasks = [...tasks, newTask];
                
                // Save to SharedPreferences
                await HouseService.saveZoneTasks(
                  selectedZone, 
                  updatedTasks.map((t) => Map<String, String>.from(t)).toList(),
                );
                
                // Reload tasks
                setState(() {
                  _isLoading = true;
                });
                await _loadTasks();
                setState(() {
                  _isLoading = false;
                });
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task added to $selectedZone!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding task: $e')),
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

  void _showEditTaskDialog(int index) {
    final task = tasks[index];
    final taskController = TextEditingController(text: task['task']);
    final howToController = TextEditingController(text: task['howTo']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: howToController,
                decoration: const InputDecoration(
                  labelText: 'How to do it',
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
          TextButton(
            onPressed: () async {
              // Delete task
              final updatedTasks = List<Map<String, dynamic>>.from(tasks);
              updatedTasks.removeAt(index);
              
              await HouseService.saveZoneTasks(
                selectedZone,
                updatedTasks.map((t) => Map<String, String>.from(t)).toList(),
              );
              
              setState(() {
                _isLoading = true;
              });
              await _loadTasks();
              setState(() {
                _isLoading = false;
              });
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          FilledButton(
            onPressed: () async {
              if (taskController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a task name')),
                );
                return;
              }

              final updatedTasks = List<Map<String, dynamic>>.from(tasks);
              updatedTasks[index] = {
                'task': taskController.text.trim(),
                'howTo': howToController.text.trim().isEmpty 
                    ? 'No instructions provided' 
                    : howToController.text.trim(),
              };
              
              await HouseService.saveZoneTasks(
                selectedZone,
                updatedTasks.map((t) => Map<String, String>.from(t)).toList(),
              );
              
              setState(() {
                _isLoading = true;
              });
              await _loadTasks();
              setState(() {
                _isLoading = false;
              });
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task updated!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
