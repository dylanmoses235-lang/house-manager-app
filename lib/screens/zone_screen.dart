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
    final zoneTasks = await HouseService.getZoneTasks(selectedZone);
    tasks = zoneTasks.map((task) => Map<String, dynamic>.from(task)).toList();
    
    // Load completion state from persistence
    taskCompletion = HouseService.getAllZoneTaskCompletions(selectedZone);
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
        title: const Text('Zone Cleaning'),
        actions: [
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
                Text(
                  selectedZone,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedCount of $totalCount tasks completed',
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
                                  selectedZone, 
                                  index, 
                                  newValue,
                                );
                                setState(() {
                                  taskCompletion['$index'] = newValue;
                                });
                              },
                            ),
                            title: Text(
                              task['task'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.note_outlined),
                                  onPressed: () async {
                                    final taskId = '${selectedZone}_${index}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskNotesScreen(
                                          taskId: taskId,
                                          taskName: task['task'] ?? '',
                                          zone: selectedZone,
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
                                          zone: selectedZone,
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
}
