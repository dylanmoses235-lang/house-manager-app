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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSchedule();
    // Auto-scroll to current time block after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentTime());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSchedule() {
    schedule = HouseService.getTodaySchedule();
    taskCompletion = HouseService.getAllScheduleTaskCompletions();
  }

  /// Returns the index of the schedule item that is current or next.
  int _getCurrentIndex() {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    for (int i = 0; i < schedule.length; i++) {
      final timeStr = schedule[i]['time'] ?? '';
      final t = _parseTime(timeStr);
      if (t == null) continue;
      final taskMinutes = t.hour * 60 + t.minute;
      if (taskMinutes > nowMinutes) {
        // Return the PREVIOUS one (currently active) or this one if it's the first
        return i > 0 ? i - 1 : 0;
      }
    }
    // Past all tasks — return the last one
    return schedule.length - 1;
  }

  TimeOfDay? _parseTime(String timeStr) {
    // e.g. "7:15 AM", "12:30 PM"
    final regex = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false);
    final match = regex.firstMatch(timeStr);
    if (match == null) return null;
    int hour = int.parse(match.group(1)!);
    final int minute = int.parse(match.group(2)!);
    final String period = match.group(3)!.toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _scrollToCurrentTime() {
    final currentIdx = _getCurrentIndex();
    // Each card is approximately 88 px tall with margin
    const itemHeight = 88.0;
    final offset = (currentIdx * itemHeight - 40).clamp(0.0, double.infinity);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final completedCount = taskCompletion.values.where((v) => v).length;
    final currentIdx = _getCurrentIndex();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Jump to now',
            onPressed: _scrollToCurrentTime,
          ),
        ],
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
                  isWeekend ? '🌅 Weekend Schedule' : '📋 Weekday Schedule',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$completedCount/${schedule.length} tasks done',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Now: ${TimeOfDay.now().format(context)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Schedule list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final task = schedule[index];
                final isCompleted = taskCompletion['$index'] ?? false;
                final isCurrent = index == currentIdx;

                return _buildScheduleItem(
                  context,
                  task,
                  index,
                  isCompleted,
                  isCurrent,
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

  Widget _buildScheduleItem(
    BuildContext context,
    Map<String, String> task,
    int index,
    bool isCompleted,
    bool isCurrent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine card styling
    Color? cardColor;
    BorderSide border = BorderSide.none;

    if (isCurrent && !isCompleted) {
      cardColor = colorScheme.primaryContainer;
      border = BorderSide(color: colorScheme.primary, width: 2);
    } else if (isCompleted) {
      cardColor = colorScheme.surfaceContainerHighest;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: border,
      ),
      elevation: isCurrent && !isCompleted ? 3 : 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isCurrent && !isCompleted
                    ? colorScheme.primary
                    : isCompleted
                        ? Colors.green
                        : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task['time'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: isCurrent && !isCompleted
                      ? colorScheme.onPrimary
                      : isCompleted
                          ? Colors.white
                          : colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            if (isCurrent && !isCompleted) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NOW',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
        title: Text(
          task['task'] ?? '',
          style: TextStyle(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
            fontSize: isCurrent && !isCompleted ? 15 : 14,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? colorScheme.outline : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            task['details'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: isCompleted ? colorScheme.outline : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        trailing: Checkbox(
          value: isCompleted,
          activeColor: Colors.green,
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
  }
}
