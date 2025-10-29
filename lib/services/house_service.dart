import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/zone_task.dart';
import '../models/schedule_task.dart';
import '../models/declutter_day.dart';
import '../models/supply_item.dart';
import '../models/task_note.dart';
import '../data/cleaning_data.dart';

class HouseService {
  static const String zoneTasksBox = 'zone_tasks';
  static const String scheduleTasksBox = 'schedule_tasks';
  static const String declutterBox = 'declutter';
  static const String settingsBox = 'settings';
  static const String dailyTaskCompletionBox = 'daily_task_completion';
  static const String statisticsBox = 'statistics';
  static const String suppliesBox = 'supplies';
  static const String taskNotesBox = 'task_notes';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ZoneTaskAdapter());
    Hive.registerAdapter(ScheduleTaskAdapter());
    Hive.registerAdapter(DeclutterDayAdapter());
    Hive.registerAdapter(SupplyItemAdapter());
    Hive.registerAdapter(TaskNoteAdapter());

    // Open boxes
    await Hive.openBox<ZoneTask>(zoneTasksBox);
    await Hive.openBox<ScheduleTask>(scheduleTasksBox);
    await Hive.openBox<DeclutterDay>(declutterBox);
    await Hive.openBox<SupplyItem>(suppliesBox);
    await Hive.openBox<TaskNote>(taskNotesBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(dailyTaskCompletionBox);
    await Hive.openBox(statisticsBox);

    // Initialize data if first time
    await _initializeData();
  }

  static Future<void> _initializeData() async {
    final settings = Hive.box(settingsBox);
    
    if (settings.get('initialized') != true) {
      // Initialize declutter challenge
      await _initializeDeclutter();
      
      settings.put('initialized', true);
      settings.put('challengeStartDate', DateTime.now().toIso8601String());
    }
  }

  static Future<void> _initializeDeclutter() async {
    final box = Hive.box<DeclutterDay>(declutterBox);
    
    for (var item in CleaningData.declutterChallenge) {
      final declutterDay = DeclutterDay(
        day: int.parse(item['day']!),
        area: item['area']!,
        task: item['task']!,
      );
      await box.add(declutterDay);
    }
  }

  // Get today's zone based on day of week
  static String getTodayZone() {
    final dayName = DateFormat('EEEE').format(DateTime.now());
    return CleaningData.zoneSchedule[dayName] ?? 'Kitchen';
  }

  // Get tomorrow's zone
  static String getTomorrowZone() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dayName = DateFormat('EEEE').format(tomorrow);
    return CleaningData.zoneSchedule[dayName] ?? 'Kitchen';
  }

  // Get zone tasks for a specific zone
  static List<Map<String, String>> getZoneTasks(String zone) {
    return CleaningData.zoneTasks[zone] ?? [];
  }

  // Get today's schedule
  static List<Map<String, String>> getTodaySchedule() {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    return isWeekend ? CleaningData.weekendSchedule : CleaningData.weekdaySchedule;
  }

  // Declutter challenge operations
  static List<DeclutterDay> getAllDeclutterDays() {
    final box = Hive.box<DeclutterDay>(declutterBox);
    return box.values.toList()..sort((a, b) => a.day.compareTo(b.day));
  }

  static DeclutterDay? getCurrentDeclutterDay() {
    final settings = Hive.box(settingsBox);
    final startDateStr = settings.get('challengeStartDate');
    
    if (startDateStr == null) return null;
    
    final startDate = DateTime.parse(startDateStr);
    final daysSinceStart = DateTime.now().difference(startDate).inDays + 1;
    
    if (daysSinceStart < 1 || daysSinceStart > 30) return null;
    
    final allDays = getAllDeclutterDays();
    return allDays.firstWhere(
      (day) => day.day == daysSinceStart,
      orElse: () => allDays.first,
    );
  }

  static int getDeclutterProgress() {
    final allDays = getAllDeclutterDays();
    final completed = allDays.where((day) => day.isCompleted).length;
    return completed;
  }

  static Future<void> toggleDeclutterDay(int dayNumber) async {
    final allDays = getAllDeclutterDays();
    final day = allDays.firstWhere((d) => d.day == dayNumber);
    
    day.isCompleted = !day.isCompleted;
    day.completedDate = day.isCompleted ? DateTime.now() : null;
    await day.save();
  }

  // Get challenge start date
  static DateTime? getChallengeStartDate() {
    final settings = Hive.box(settingsBox);
    final startDateStr = settings.get('challengeStartDate');
    return startDateStr != null ? DateTime.parse(startDateStr) : null;
  }

  // Reset challenge
  static Future<void> resetChallenge() async {
    final settings = Hive.box(settingsBox);
    final declutterBox = Hive.box<DeclutterDay>(HouseService.declutterBox);
    
    // Clear all completion status
    for (var day in declutterBox.values) {
      day.isCompleted = false;
      day.completedDate = null;
      await day.save();
    }
    
    // Reset start date
    settings.put('challengeStartDate', DateTime.now().toIso8601String());
  }

  // Zone task completion persistence
  static String _getZoneTaskKey(String zone, int taskIndex, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return '${zone}_${taskIndex}_$dateStr';
  }

  static Future<void> setZoneTaskCompletion(String zone, int taskIndex, bool isCompleted) async {
    final box = Hive.box(dailyTaskCompletionBox);
    final key = _getZoneTaskKey(zone, taskIndex, DateTime.now());
    await box.put(key, isCompleted);
    
    // Update statistics
    if (isCompleted) {
      await _recordTaskCompletion('zone', zone);
    }
  }

  static bool getZoneTaskCompletion(String zone, int taskIndex) {
    final box = Hive.box(dailyTaskCompletionBox);
    final key = _getZoneTaskKey(zone, taskIndex, DateTime.now());
    return box.get(key, defaultValue: false);
  }

  static Map<String, bool> getAllZoneTaskCompletions(String zone) {
    final tasks = getZoneTasks(zone);
    final completions = <String, bool>{};
    for (int i = 0; i < tasks.length; i++) {
      completions['$i'] = getZoneTaskCompletion(zone, i);
    }
    return completions;
  }

  // Schedule task completion persistence
  static String _getScheduleTaskKey(int taskIndex, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    return 'schedule_${isWeekend ? 'weekend' : 'weekday'}_${taskIndex}_$dateStr';
  }

  static Future<void> setScheduleTaskCompletion(int taskIndex, bool isCompleted) async {
    final box = Hive.box(dailyTaskCompletionBox);
    final key = _getScheduleTaskKey(taskIndex, DateTime.now());
    await box.put(key, isCompleted);
    
    // Update statistics
    if (isCompleted) {
      await _recordTaskCompletion('schedule', 'daily');
    }
  }

  static bool getScheduleTaskCompletion(int taskIndex) {
    final box = Hive.box(dailyTaskCompletionBox);
    final key = _getScheduleTaskKey(taskIndex, DateTime.now());
    return box.get(key, defaultValue: false);
  }

  static Map<String, bool> getAllScheduleTaskCompletions() {
    final schedule = getTodaySchedule();
    final completions = <String, bool>{};
    for (int i = 0; i < schedule.length; i++) {
      completions['$i'] = getScheduleTaskCompletion(i);
    }
    return completions;
  }

  // Statistics tracking
  static Future<void> _recordTaskCompletion(String type, String category) async {
    final box = Hive.box(statisticsBox);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = '${type}_${category}_$today';
    
    int count = box.get(key, defaultValue: 0);
    await box.put(key, count + 1);
    
    // Record for streak calculation
    await box.put('last_active_date', today);
  }

  // Get statistics
  static int getTasksCompletedToday() {
    final box = Hive.box(statisticsBox);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int total = 0;
    
    for (var key in box.keys) {
      if (key.toString().endsWith(today)) {
        total += box.get(key, defaultValue: 0) as int;
      }
    }
    return total;
  }

  static int getCurrentStreak() {
    final box = Hive.box(statisticsBox);
    final lastActiveStr = box.get('last_active_date');
    
    if (lastActiveStr == null) return 0;
    
    final lastActive = DateTime.parse(lastActiveStr);
    final today = DateTime.now();
    final difference = today.difference(lastActive).inDays;
    
    if (difference > 1) return 0; // Streak broken
    if (difference == 1) {
      return box.get('current_streak', defaultValue: 1);
    }
    
    return box.get('current_streak', defaultValue: 0);
  }

  static int getTotalTasksCompleted() {
    final box = Hive.box(statisticsBox);
    int total = 0;
    
    for (var key in box.keys) {
      if (key.toString().contains('zone_') || key.toString().contains('schedule_')) {
        final value = box.get(key);
        if (value is int) {
          total += value;
        }
      }
    }
    return total;
  }

  static Map<String, int> getTaskCompletionByZone() {
    final box = Hive.box(statisticsBox);
    final zoneCounts = <String, int>{};
    
    for (var key in box.keys) {
      if (key.toString().startsWith('zone_')) {
        final parts = key.toString().split('_');
        if (parts.length >= 2) {
          final zone = parts[1];
          zoneCounts[zone] = (zoneCounts[zone] ?? 0) + (box.get(key, defaultValue: 0) as int);
        }
      }
    }
    return zoneCounts;
  }

  // Clean up old completion data (keep last 30 days)
  static Future<void> cleanupOldCompletions() async {
    final box = Hive.box(dailyTaskCompletionBox);
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    final cutoffStr = DateFormat('yyyy-MM-dd').format(cutoffDate);
    
    final keysToDelete = <String>[];
    for (var key in box.keys) {
      if (key.toString().contains('_')) {
        final parts = key.toString().split('_');
        final dateStr = parts.last;
        if (dateStr.compareTo(cutoffStr) < 0) {
          keysToDelete.add(key as String);
        }
      }
    }
    
    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }
}
