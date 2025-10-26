import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/zone_task.dart';
import '../models/schedule_task.dart';
import '../models/declutter_day.dart';
import '../data/cleaning_data.dart';

class HouseService {
  static const String zoneTasksBox = 'zone_tasks';
  static const String scheduleTasksBox = 'schedule_tasks';
  static const String declutterBox = 'declutter';
  static const String settingsBox = 'settings';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ZoneTaskAdapter());
    Hive.registerAdapter(ScheduleTaskAdapter());
    Hive.registerAdapter(DeclutterDayAdapter());

    // Open boxes
    await Hive.openBox<ZoneTask>(zoneTasksBox);
    await Hive.openBox<ScheduleTask>(scheduleTasksBox);
    await Hive.openBox<DeclutterDay>(declutterBox);
    await Hive.openBox(settingsBox);

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
}
