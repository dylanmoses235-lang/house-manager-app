import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/declutter_day.dart';
import '../models/supply_item.dart';
import '../models/task_note.dart';

class ExportService {
  // Export all data to JSON
  static Future<Map<String, dynamic>> exportAllData() async {
    final data = <String, dynamic>{};
    
    // Export metadata
    data['exported_at'] = DateTime.now().toIso8601String();
    data['app_version'] = '1.1.0';
    
    // Export settings
    final settingsBox = Hive.box('settings');
    data['settings'] = settingsBox.toMap();
    
    // Export declutter challenge
    final declutterBox = Hive.box<DeclutterDay>('declutter');
    data['declutter'] = declutterBox.values.map((day) => {
      'day': day.day,
      'area': day.area,
      'task': day.task,
      'isCompleted': day.isCompleted,
      'completedDate': day.completedDate?.toIso8601String(),
    }).toList();
    
    // Export supplies/shopping list
    final suppliesBox = Hive.box<SupplyItem>('supplies');
    data['supplies'] = suppliesBox.values.map((item) => {
      'id': item.id,
      'name': item.name,
      'category': item.category,
      'isNeeded': item.isNeeded,
      'isPurchased': item.isPurchased,
      'quantity': item.quantity,
      'notes': item.notes,
      'addedDate': item.addedDate?.toIso8601String(),
    }).toList();
    
    // Export task notes (without photos for size reasons)
    final notesBox = Hive.box<TaskNote>('task_notes');
    data['task_notes'] = notesBox.values.map((note) => {
      'id': note.id,
      'taskId': note.taskId,
      'note': note.note,
      'photoCount': note.photoUrls.length,
      'createdDate': note.createdDate.toIso8601String(),
      'updatedDate': note.updatedDate?.toIso8601String(),
    }).toList();
    
    // Export task completions
    final completionsBox = Hive.box('daily_task_completion');
    data['task_completions'] = completionsBox.toMap();
    
    // Export statistics
    final statsBox = Hive.box('statistics');
    data['statistics'] = statsBox.toMap();
    
    return data;
  }

  // Export to JSON file
  static Future<File> exportToFile() async {
    final data = await exportAllData();
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final fileName = 'house_manager_backup_$timestamp.json';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsString(jsonString);
    return file;
  }

  // Share backup file
  static Future<void> shareBackup() async {
    try {
      final file = await exportToFile();
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'House Manager Backup',
        text: 'Backup of House Manager data from ${DateFormat('MMM d, y').format(DateTime.now())}',
      );
    } catch (e) {
      throw Exception('Failed to share backup: $e');
    }
  }

  // Export statistics as CSV
  static Future<File> exportStatisticsCSV() async {
    final statsBox = Hive.box('statistics');
    final completionsBox = Hive.box('daily_task_completion');
    
    final csvRows = <String>[];
    csvRows.add('Type,Key,Value,Date');
    
    // Add statistics
    for (var key in statsBox.keys) {
      final value = statsBox.get(key);
      csvRows.add('statistic,$key,$value,${DateTime.now().toIso8601String()}');
    }
    
    // Add completions
    for (var key in completionsBox.keys) {
      final value = completionsBox.get(key);
      csvRows.add('completion,$key,$value,${DateTime.now().toIso8601String()}');
    }
    
    final csvString = csvRows.join('\n');
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final fileName = 'house_manager_stats_$timestamp.csv';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsString(csvString);
    return file;
  }

  // Share statistics CSV
  static Future<void> shareStatisticsCSV() async {
    try {
      final file = await exportStatisticsCSV();
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'House Manager Statistics',
        text: 'Statistics export from House Manager - ${DateFormat('MMM d, y').format(DateTime.now())}',
      );
    } catch (e) {
      throw Exception('Failed to share statistics: $e');
    }
  }

  // Import data from JSON (basic implementation)
  static Future<void> importData(String jsonString) async {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      
      // Import settings
      if (data.containsKey('settings')) {
        final settingsBox = Hive.box('settings');
        final settings = data['settings'] as Map<String, dynamic>;
        for (var entry in settings.entries) {
          await settingsBox.put(entry.key, entry.value);
        }
      }
      
      // Import declutter challenge
      if (data.containsKey('declutter')) {
        final declutterBox = Hive.box<DeclutterDay>('declutter');
        final declutterData = data['declutter'] as List;
        
        for (var item in declutterData) {
          final dayNumber = item['day'] as int;
          final existingDay = declutterBox.values.firstWhere(
            (d) => d.day == dayNumber,
            orElse: () => declutterBox.values.first,
          );
          
          existingDay.isCompleted = item['isCompleted'] ?? false;
          if (item['completedDate'] != null) {
            existingDay.completedDate = DateTime.parse(item['completedDate']);
          }
          await existingDay.save();
        }
      }
      
      // Import supplies
      if (data.containsKey('supplies')) {
        final suppliesBox = Hive.box<SupplyItem>('supplies');
        final suppliesData = data['supplies'] as List;
        
        for (var item in suppliesData) {
          final supply = SupplyItem(
            id: item['id'],
            name: item['name'],
            category: item['category'],
            isNeeded: item['isNeeded'] ?? true,
            isPurchased: item['isPurchased'] ?? false,
            quantity: item['quantity'] ?? 1,
            notes: item['notes'],
            addedDate: item['addedDate'] != null 
              ? DateTime.parse(item['addedDate'])
              : null,
          );
          await suppliesBox.add(supply);
        }
      }
      
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  // Get backup info
  static Future<Map<String, dynamic>> getBackupInfo() async {
    final data = await exportAllData();
    
    return {
      'declutter_days_completed': (data['declutter'] as List)
          .where((d) => d['isCompleted'] == true)
          .length,
      'supplies_count': (data['supplies'] as List).length,
      'notes_count': (data['task_notes'] as List).length,
      'task_completions': (data['task_completions'] as Map).length,
      'last_exported': data['exported_at'],
    };
  }
}
