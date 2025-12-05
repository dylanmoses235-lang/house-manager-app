import 'package:hive/hive.dart';

part 'daily_recurring_task.g.dart';

@HiveType(typeId: 6)
class DailyRecurringTask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String emoji;

  @HiveField(4)
  DateTime? lastCompleted;

  @HiveField(5)
  int accumulationDays;

  @HiveField(6)
  bool isCompletedToday;

  @HiveField(7)
  int totalCompletions;

  DailyRecurringTask({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.lastCompleted,
    this.accumulationDays = 0,
    this.isCompletedToday = false,
    this.totalCompletions = 0,
  });

  // Calculate how many days this task has been piling up
  int getDaysAccumulated() {
    if (lastCompleted == null) {
      return accumulationDays;
    }
    
    final now = DateTime.now();
    final lastCompletedDate = DateTime(lastCompleted!.year, lastCompleted!.month, lastCompleted!.day);
    final today = DateTime(now.year, now.month, now.day);
    
    final daysSinceCompletion = today.difference(lastCompletedDate).inDays;
    
    // If completed today, no accumulation
    if (daysSinceCompletion == 0) {
      return 0;
    }
    
    // Otherwise accumulate for each day not done
    return daysSinceCompletion;
  }

  // Get status message for the pile-up
  String getStatusMessage() {
    final days = getDaysAccumulated();
    
    if (days == 0) {
      return 'All caught up! ✨';
    } else if (days == 1) {
      return '1 day behind';
    } else if (days >= 7) {
      return '$days days behind! 😱';
    } else if (days >= 3) {
      return '$days days piling up! 😬';
    } else {
      return '$days days behind';
    }
  }

  // Get urgency level
  String getUrgencyLevel() {
    final days = getDaysAccumulated();
    
    if (days == 0) return 'good';
    if (days == 1) return 'warning';
    if (days <= 3) return 'urgent';
    return 'critical';
  }

  // Mark task as completed for today
  void completeToday() {
    lastCompleted = DateTime.now();
    isCompletedToday = true;
    accumulationDays = 0;
    totalCompletions++;
  }

  // Update accumulation (called daily)
  void updateAccumulation() {
    final days = getDaysAccumulated();
    accumulationDays = days;
    
    // Reset isCompletedToday if it's a new day
    final now = DateTime.now();
    if (lastCompleted != null) {
      final lastDate = DateTime(lastCompleted!.year, lastCompleted!.month, lastCompleted!.day);
      final today = DateTime(now.year, now.month, now.day);
      if (today.isAfter(lastDate)) {
        isCompletedToday = false;
      }
    } else {
      isCompletedToday = false;
    }
  }
}
