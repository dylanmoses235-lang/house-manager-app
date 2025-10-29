import 'package:flutter/material.dart';
import '../services/house_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<Map<String, String>> schedule;
  late Map<String, bool> taskCompletion;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  void _loadSchedule() {
    schedule = HouseService.getTodaySchedule();
    taskCompletion = HouseService.getAllScheduleTaskCompletions();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final completedCount = taskCompletion.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text(
                  isWeekend ? 'Weekend Schedule' : 'Weekday Schedule',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedCount/${schedule.length} tasks done',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // Schedule list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final task = schedule[index];
                final isCompleted = taskCompletion['$index'] ?? false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task['time'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      task['task'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        task['details'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    trailing: Checkbox(
                      value: isCompleted,
                      onChanged: (value) async {
                        final newValue = value ?? false;
                        await HouseService.setScheduleTaskCompletion(index, newValue);
                        setState(() {
                          taskCompletion['$index'] = newValue;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: completedCount == schedule.length
          ? FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('🌟 Day Complete!'),
                    content: const Text(
                      'Amazing! You\'ve completed your entire daily schedule!',
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Great!'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('All Done!'),
            )
          : null,
    );
  }
}
