import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_time_entry.dart';
import '../models/zone_task.dart';
import '../models/schedule_task.dart';
import '../models/declutter_day.dart';

class AnalyticsService {
  static late Box<TaskTimeEntry> _timeBox;
  static TaskTimeEntry? _activeTimer;

  static Future<void> initialize() async {
    _timeBox = await Hive.openBox<TaskTimeEntry>('task_times');
  }

  // Time Tracking
  static String startTimer(String taskId, String taskName, String category) {
    // Stop any active timer first
    if (_activeTimer != null) {
      stopTimer(_activeTimer!.id);
    }

    final entry = TaskTimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: taskId,
      taskName: taskName,
      category: category,
      startTime: DateTime.now(),
    );

    _timeBox.add(entry);
    _activeTimer = entry;
    return entry.id;
  }

  static void stopTimer(String entryId) {
    final entry = _timeBox.values.firstWhere((e) => e.id == entryId);
    entry.stop();
    entry.save();
    if (_activeTimer?.id == entryId) {
      _activeTimer = null;
    }
  }

  static TaskTimeEntry? get activeTimer => _activeTimer;

  static List<TaskTimeEntry> getEntriesForDateRange(DateTime start, DateTime end) {
    return _timeBox.values
        .where((entry) =>
            entry.startTime.isAfter(start) && entry.startTime.isBefore(end))
        .toList();
  }

  // Analytics Calculations
  static Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final entries = getEntriesForDateRange(weekStart, weekEnd);

    final totalTime = entries.fold<int>(0, (sum, entry) => sum + entry.duration);
    final avgTimePerTask = entries.isEmpty ? 0 : totalTime / entries.length;

    final categoryBreakdown = <String, int>{};
    for (var entry in entries) {
      categoryBreakdown[entry.category] =
          (categoryBreakdown[entry.category] ?? 0) + entry.duration;
    }

    return {
      'totalTime': totalTime,
      'avgTimePerTask': avgTimePerTask,
      'taskCount': entries.length,
      'categoryBreakdown': categoryBreakdown,
      'entries': entries,
    };
  }

  static Map<String, dynamic> getMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final entries = getEntriesForDateRange(monthStart, monthEnd);

    final totalTime = entries.fold<int>(0, (sum, entry) => sum + entry.duration);
    final avgTimePerTask = entries.isEmpty ? 0 : totalTime / entries.length;

    // Group by day
    final dailyBreakdown = <int, int>{};
    for (var entry in entries) {
      final day = entry.startTime.day;
      dailyBreakdown[day] = (dailyBreakdown[day] ?? 0) + entry.duration;
    }

    // Most productive day
    int? mostProductiveDay;
    int maxTime = 0;
    dailyBreakdown.forEach((day, time) {
      if (time > maxTime) {
        maxTime = time;
        mostProductiveDay = day;
      }
    });

    return {
      'totalTime': totalTime,
      'avgTimePerTask': avgTimePerTask,
      'taskCount': entries.length,
      'dailyBreakdown': dailyBreakdown,
      'mostProductiveDay': mostProductiveDay,
      'entries': entries,
    };
  }

  static Map<String, dynamic> getProductivityTrends() {
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));

    final entries = getEntriesForDateRange(last30Days, now);

    // Calculate weekly comparison
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    final thisWeekEntries = entries
        .where((e) => e.startTime.isAfter(thisWeekStart))
        .toList();
    final lastWeekEntries = entries
        .where((e) =>
            e.startTime.isAfter(lastWeekStart) &&
            e.startTime.isBefore(thisWeekStart))
        .toList();

    final thisWeekTime = thisWeekEntries.fold<int>(0, (sum, e) => sum + e.duration);
    final lastWeekTime = lastWeekEntries.fold<int>(0, (sum, e) => sum + e.duration);

    final percentChange = lastWeekTime == 0
        ? 0.0
        : ((thisWeekTime - lastWeekTime) / lastWeekTime) * 100;

    return {
      'thisWeekTime': thisWeekTime,
      'lastWeekTime': lastWeekTime,
      'percentChange': percentChange,
      'thisWeekTasks': thisWeekEntries.length,
      'lastWeekTasks': lastWeekEntries.length,
    };
  }

  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  static void clearAllData() {
    _timeBox.clear();
    _activeTimer = null;
  }
}
