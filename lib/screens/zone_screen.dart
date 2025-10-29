import 'package:flutter/material.dart';
import '../services/house_service.dart';
import 'timer_screen.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key});

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  late String selectedZone;
  late List<Map<String, dynamic>> tasks;
  late Map<String, bool> taskCompletion;

  @override
  void initState() {
    super.initState();
    selectedZone = HouseService.getTodayZone();
    _loadTasks();
  }

  void _loadTasks() {
    final zoneTasks = HouseService.getZoneTasks(selectedZone);
    tasks = zoneTasks.map((task) => Map<String, dynamic>.from(task)).toList();
    
    // Load completion state from persistence
    taskCompletion = HouseService.getAllZoneTaskCompletions(selectedZone);
  }

  void _changeZone(String zone) {
    setState(() {
      selectedZone = zone;
      _loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = taskCompletion.values.where((v) => v).length;
    final totalCount = tasks.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zone Cleaning'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: _changeZone,
            itemBuilder: (context) {
              return [
                'Kitchen',
                'Bathroom',
                'Bedroom',
                'Living Room',
                'Laundry Room',
                'Office',
                'Reset',
              ].map((zone) {
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
                            trailing: IconButton(
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
      floatingActionButton: completedCount == totalCount && totalCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
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
              },
              icon: const Icon(Icons.celebration),
              label: const Text('Complete!'),
            )
          : null,
    );
  }
}
