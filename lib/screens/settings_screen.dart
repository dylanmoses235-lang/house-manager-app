import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/house_service.dart';
import '../services/notification_service.dart';
import '../services/export_service.dart';
import 'manage_zones_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  
  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = false;
  bool _dailyReminders = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final themeModeStr = prefs.getString('theme_mode') ?? 'system';
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == themeModeStr,
        orElse: () => ThemeMode.system,
      );
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
      _dailyReminders = prefs.getBool('daily_reminders') ?? true;
      
      final hour = prefs.getInt('reminder_hour') ?? 9;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
    setState(() {
      _themeMode = mode;
    });
    widget.onThemeChanged(mode);
  }

  Future<void> _saveNotificationSettings(bool enabled) async {
    if (enabled) {
      // Request permissions first
      final granted = await NotificationService.requestPermissions();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permissions denied'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    setState(() {
      _notificationsEnabled = enabled;
    });
    
    // Setup or cancel notifications based on setting
    await NotificationService.setupNotifications();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(enabled 
            ? 'Notifications enabled!' 
            : 'Notifications disabled'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveDailyReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminders', enabled);
    setState(() {
      _dailyReminders = enabled;
    });
    
    // Update notifications
    await NotificationService.setupNotifications();
  }

  Future<void> _saveReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
    setState(() {
      _reminderTime = time;
    });
    
    // Reschedule notifications with new time
    await NotificationService.setupNotifications();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder time updated to ${time.format(context)}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader('🎨 Appearance'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeLabel(_themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context),
                ),
              ],
            ),
          ),

          // Notifications Section
          _buildSectionHeader('🔔 Notifications'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive task reminders'),
                  value: _notificationsEnabled,
                  onChanged: _saveNotificationSettings,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.alarm),
                  title: const Text('Daily Reminders'),
                  subtitle: const Text('Get reminded of today\'s zone'),
                  value: _dailyReminders,
                  onChanged: _notificationsEnabled ? _saveDailyReminders : null,
                ),
                const Divider(height: 1),
                ListTile(
                  enabled: _notificationsEnabled && _dailyReminders,
                  leading: const Icon(Icons.schedule),
                  title: const Text('Reminder Time'),
                  subtitle: Text(_reminderTime.format(context)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _notificationsEnabled && _dailyReminders
                      ? () => _selectReminderTime(context)
                      : null,
                ),
              ],
            ),
          ),

          // Customization Section
          _buildSectionHeader('🎨 Customization'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: const Text('Manage Zones'),
                  subtitle: const Text('Customize zones and weekly schedule'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageZonesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Data Management Section
          _buildSectionHeader('💾 Data Management'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services),
                  title: const Text('Clean Old Data'),
                  subtitle: const Text('Remove completion data older than 30 days'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _cleanOldData(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('Export Backup'),
                  subtitle: const Text('Save all your data to a file'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportBackup(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: const Text('Export Statistics'),
                  subtitle: const Text('Export stats as CSV file'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportStatistics(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('Reset All Progress'),
                  subtitle: const Text('Clear all tasks and start fresh'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _confirmResetAll(context),
                ),
              ],
            ),
          ),

          // About Section
          _buildSectionHeader('ℹ️ About'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Report Issue'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Could integrate with email or feedback form
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feature coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      await _saveReminderTime(picked);
    }
  }

  Future<void> _cleanOldData(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clean Old Data?'),
        content: const Text(
          'This will remove task completion data older than 30 days. Your statistics will be recalculated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await HouseService.cleanupOldCompletions();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Old data cleaned successfully!'),
                  ),
                );
              }
            },
            child: const Text('Clean'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await ExportService.shareBackup();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup exported successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting backup: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportStatistics(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await ExportService.shareStatisticsCSV();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Statistics exported successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting statistics: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmResetAll(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Reset All Progress?'),
        content: const Text(
          'This will delete ALL your progress including:\n\n'
          '• Task completions\n'
          '• Statistics\n'
          '• Declutter challenge progress\n'
          '• Streaks\n\n'
          'This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Reset all data
              await HouseService.resetChallenge();
              // Could add more comprehensive reset logic here
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All progress has been reset'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }
}
