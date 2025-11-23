import 'package:hive/hive.dart';

part 'progress_photo.g.dart';

@HiveType(typeId: 16)
class ProgressPhoto extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String taskName;

  @HiveField(3)
  String category; // 'before', 'during', 'after'

  @HiveField(4)
  String photoPath;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  String? room;

  ProgressPhoto({
    required this.id,
    required this.taskId,
    required this.taskName,
    required this.category,
    required this.photoPath,
    required this.timestamp,
    this.notes,
    this.room,
  });
}

@HiveType(typeId: 17)
class Achievement extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String iconName; // Icon identifier

  @HiveField(4)
  DateTime unlockedDate;

  @HiveField(5)
  String category; // 'streak', 'tasks', 'zones', 'special'

  @HiveField(6)
  int points;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.unlockedDate,
    required this.category,
    required this.points,
  });
}

@HiveType(typeId: 18)
class Streak extends HiveObject {
  @HiveField(0)
  String category; // 'daily_tasks', 'zone_cleaning', 'declutter'

  @HiveField(1)
  int currentStreak;

  @HiveField(2)
  int longestStreak;

  @HiveField(3)
  DateTime? lastCompletedDate;

  @HiveField(4)
  List<DateTime> completedDates;

  Streak({
    required this.category,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    List<DateTime>? completedDates,
  }) : completedDates = completedDates ?? [];

  void recordCompletion(DateTime date) {
    final today = DateTime(date.year, date.month, date.day);
    
    if (lastCompletedDate != null) {
      final lastDate = DateTime(
        lastCompletedDate!.year,
        lastCompletedDate!.month,
        lastCompletedDate!.day,
      );
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 1) {
        // Consecutive day
        currentStreak++;
      } else if (difference > 1) {
        // Streak broken
        currentStreak = 1;
      }
      // Same day - no change
    } else {
      currentStreak = 1;
    }
    
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
    
    lastCompletedDate = date;
    if (!completedDates.contains(today)) {
      completedDates.add(today);
    }
  }

  bool get isActive {
    if (lastCompletedDate == null) return false;
    final lastDate = DateTime(
      lastCompletedDate!.year,
      lastCompletedDate!.month,
      lastCompletedDate!.day,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(lastDate).inDays;
    return difference <= 1;
  }
}
