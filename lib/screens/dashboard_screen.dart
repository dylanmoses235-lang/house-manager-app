import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../services/house_service.dart';
import 'shopping_list_screen.dart';
import 'calendar_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final todayZone = HouseService.getTodayZone();
    final tomorrowZone = HouseService.getTomorrowZone();
    final currentDeclutter = HouseService.getCurrentDeclutterDay();
    final declutterProgress = HouseService.getDeclutterProgress();
    final startDate = HouseService.getChallengeStartDate();
    
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
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
                    ],
                  ),
                ),
              ),
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
                              DefaultTabController.of(context)?.animateTo(3);
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
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Zone Tasks',
                      'Clean $todayZone',
                      Icons.cleaning_services,
                      Colors.blue,
                      () {
                        setState(() {
                          DefaultTabController.of(context)?.animateTo(1);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Schedule',
                      'View today\'s tasks',
                      Icons.schedule,
                      Colors.orange,
                      () {
                        setState(() {
                          DefaultTabController.of(context)?.animateTo(2);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Statistics',
                      'View your progress',
                      Icons.analytics,
                      Colors.purple,
                      () {
                        setState(() {
                          DefaultTabController.of(context)?.animateTo(4);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Weekly Overview
              const Text(
                '📆 WEEKLY ZONE PLAN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildWeekDayRow('Monday', 'Kitchen', now.weekday == 1),
                      _buildWeekDayRow('Tuesday', 'Bathroom', now.weekday == 2),
                      _buildWeekDayRow('Wednesday', 'Bedroom', now.weekday == 3),
                      _buildWeekDayRow('Thursday', 'Living Room', now.weekday == 4),
                      _buildWeekDayRow('Friday', 'Laundry Room', now.weekday == 5),
                      _buildWeekDayRow('Saturday', 'Office', now.weekday == 6),
                      _buildWeekDayRow('Sunday', 'Reset', now.weekday == 7),
                    ],
                  ),
                ),
              ),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDayRow(String day, String zone, bool isToday) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isToday ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (isToday) const Text('👉 ', style: TextStyle(fontSize: 16)),
                Text(
                  day,
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              zone,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
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
              Text('Monday: Kitchen (15 tasks)'),
              Text('Tuesday: Bathroom (16 tasks)'),
              Text('Wednesday: Bedroom (15 tasks)'),
              Text('Thursday: Living Room (15 tasks)'),
              Text('Friday: Laundry Room (11 tasks)'),
              Text('Saturday: Office (12 tasks)'),
              Text('Sunday: Weekly Reset (9 tasks)'),
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
