import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../services/house_service.dart';
import '../widgets/weekly_zone_plan_card.dart';
import 'shopping_list_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'daily_tasks_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;
  final Function(ThemeMode) onThemeChanged;
  
  const DashboardScreen({
    super.key,
    required this.onNavigate,
    required this.onThemeChanged,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String todayZone = 'Kitchen';
  String tomorrowZone = 'Kitchen';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadZones();
  }

  Future<void> _loadZones() async {
    final today = await HouseService.getTodayZone();
    final tomorrow = await HouseService.getTomorrowZone();
    setState(() {
      todayZone = today;
      tomorrowZone = tomorrow;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDeclutter = HouseService.getCurrentDeclutterDay();
    final declutterProgress = HouseService.getDeclutterProgress();
    
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final dayType = isWeekend ? 'Weekend' : 'Weekday';
    
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🎯 ', style: TextStyle(fontSize: 24)),
            Text('House Manager', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadZones();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Info Card
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📅 ', style: TextStyle(fontSize: 24)),
                          Text(
                            'TODAY\'S INFO',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Today\'s Date', DateFormat('EEE, MMM d, yyyy').format(now)),
                      const SizedBox(height: 8),
                      _buildInfoRow('Today\'s Zone', todayZone),
                      const SizedBox(height: 8),
                      _buildInfoRow('Tomorrow\'s Zone', tomorrowZone),
                      const SizedBox(height: 8),
                      _buildInfoRow('Day Type', dayType),
                      const SizedBox(height: 8),
                      _buildInfoRow('Current Streak', '🔥 ${HouseService.getCurrentStreak()} days'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Weekly Zone Plan Card
              const WeeklyZonePlanCard(),
              const SizedBox(height: 16),

              // 30-Day Declutter Challenge Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📦 ', style: TextStyle(fontSize: 24)),
                          const Text(
                            '30-DAY DECLUTTER CHALLENGE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (currentDeclutter != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day ${currentDeclutter.day}/30',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${currentDeclutter.area}: ${currentDeclutter.task}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Progress bar
                      LinearPercentIndicator(
                        lineHeight: 24,
                        percent: (declutterProgress / 30).clamp(0.0, 1.0),
                        center: Text(
                          '$declutterProgress/30 (${((declutterProgress / 30) * 100).toStringAsFixed(0)}%)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        progressColor: Theme.of(context).colorScheme.primary,
                        barRadius: const Radius.circular(12),
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Days Remaining: ${30 - declutterProgress}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onNavigate(4); // Navigate to Declutter tab
                            },
                            child: const Text('View All →'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Actions
              const Text(
                '⚡ QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildActionCard(
                    context,
                    'Daily Tasks',
                    'Recurring daily chores',
                    Icons.today,
                    Colors.teal,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyTasksScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    'Zone Tasks',
                    'Clean $todayZone today',
                    Icons.cleaning_services,
                    Colors.blue,
                    () => widget.onNavigate(1),
                  ),
                  _buildActionCard(
                    context,
                    'Schedule',
                    'View today\'s schedule',
                    Icons.schedule,
                    Colors.orange,
                    () => widget.onNavigate(2),
                  ),
                  _buildActionCard(
                    context,
                    'Shopping List',
                    'Manage supplies',
                    Icons.shopping_cart,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShoppingListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    'Statistics',
                    'View your progress',
                    Icons.analytics,
                    Colors.indigo,
                    () => widget.onNavigate(4),
                  ),
                  _buildActionCard(
                    context,
                    'Declutter',
                    'Day $declutterProgress of 30',
                    Icons.recycling,
                    Colors.purple,
                    () => widget.onNavigate(3),
                  ),
                ],
              );
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About House Manager'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A comprehensive household management system based on zone cleaning, daily schedules, and the 30-day declutter challenge.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Zone-based cleaning (different room each day)'),
              Text('• Detailed task lists with instructions'),
              Text('• Daily schedule with time blocks'),
              Text('• 30-day declutter challenge'),
              Text('• Progress tracking'),
              SizedBox(height: 16),
              Text(
                'System:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Monday: Kitchen (13 tasks)'),
              Text('Tuesday: Bathroom (12 tasks)'),
              Text('Wednesday: Bedroom (15 tasks)'),
              Text('Thursday: Living Room (16 tasks)'),
              Text('Friday: Laundry Room (11 tasks)'),
              Text('Saturday: Office (9 tasks)'),
              Text('Sunday: Weekly Reset (10 tasks)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

}
