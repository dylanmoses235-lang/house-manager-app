import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/house_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final tasksToday = HouseService.getTasksCompletedToday();
    final totalTasks = HouseService.getTotalTasksCompleted();
    final currentStreak = HouseService.getCurrentStreak();
    final zoneStats = HouseService.getTaskCompletionByZone();
    final declutterProgress = HouseService.getDeclutterProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showStatsInfo(context),
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
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      '🔥',
                      'Current Streak',
                      '$currentStreak days',
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      '✅',
                      'Today',
                      '$tasksToday tasks',
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      '📊',
                      'Total Tasks',
                      '$totalTasks',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      '📦',
                      'Declutter',
                      '$declutterProgress/30',
                      Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Zone Performance Chart
              const Text(
                '📈 Zone Performance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (zoneStats.isNotEmpty)
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _getMaxYValue(zoneStats),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '${rod.toY.toInt()} tasks',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final zones = zoneStats.keys.toList();
                                      if (value.toInt() >= 0 && value.toInt() < zones.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            _getZoneAbbreviation(zones[value.toInt()]),
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: _createBarGroups(zoneStats),
                            ),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'No data yet. Complete some tasks to see your statistics!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Zone Breakdown List
              const Text(
                '🏠 Zone Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (zoneStats.isNotEmpty)
                ...zoneStats.entries.map((entry) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getZoneColor(entry.key),
                          child: Text(
                            entry.key[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${entry.value} tasks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ))
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.timeline_outlined,
                            size: 60,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Start completing tasks to track your progress!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Achievements Section
              const Text(
                '🏆 Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildAchievements(context, totalTasks, currentStreak, declutterProgress),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String emoji,
    String label,
    String value,
    Color color,
  ) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getZoneAbbreviation(String zone) {
    final abbr = {
      'Kitchen': 'Kit',
      'Bathroom': 'Bath',
      'Bedroom': 'Bed',
      'Living Room': 'Liv',
      'Laundry Room': 'Lau',
      'Office': 'Off',
      'Reset': 'Rst',
    };
    return abbr[zone] ?? zone.substring(0, 3);
  }

  Color _getZoneColor(String zone) {
    final colors = {
      'Kitchen': Colors.blue,
      'Bathroom': Colors.cyan,
      'Bedroom': Colors.purple,
      'Living Room': Colors.green,
      'Laundry Room': Colors.orange,
      'Office': Colors.red,
      'Reset': Colors.teal,
    };
    return colors[zone] ?? Colors.grey;
  }

  double _getMaxYValue(Map<String, int> stats) {
    if (stats.isEmpty) return 10;
    final max = stats.values.reduce((a, b) => a > b ? a : b);
    return (max + 5).toDouble();
  }

  List<BarChartGroupData> _createBarGroups(Map<String, int> stats) {
    final zones = stats.keys.toList();
    return List.generate(zones.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stats[zones[index]]!.toDouble(),
            color: _getZoneColor(zones[index]),
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Widget _buildAchievements(
    BuildContext context,
    int totalTasks,
    int streak,
    int declutterProgress,
  ) {
    final achievements = [
      {
        'icon': '🌟',
        'title': 'First Task',
        'description': 'Complete your first task',
        'unlocked': totalTasks >= 1,
      },
      {
        'icon': '💪',
        'title': '10 Tasks',
        'description': 'Complete 10 tasks',
        'unlocked': totalTasks >= 10,
      },
      {
        'icon': '🚀',
        'title': '50 Tasks',
        'description': 'Complete 50 tasks',
        'unlocked': totalTasks >= 50,
      },
      {
        'icon': '👑',
        'title': '100 Tasks',
        'description': 'Complete 100 tasks',
        'unlocked': totalTasks >= 100,
      },
      {
        'icon': '🔥',
        'title': '3 Day Streak',
        'description': 'Maintain a 3-day streak',
        'unlocked': streak >= 3,
      },
      {
        'icon': '⚡',
        'title': 'Week Warrior',
        'description': 'Maintain a 7-day streak',
        'unlocked': streak >= 7,
      },
      {
        'icon': '📦',
        'title': 'Declutter Starter',
        'description': 'Complete 10 declutter days',
        'unlocked': declutterProgress >= 10,
      },
      {
        'icon': '🎯',
        'title': 'Declutter Master',
        'description': 'Complete all 30 declutter days',
        'unlocked': declutterProgress >= 30,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: achievements.map((achievement) {
            final isUnlocked = achievement['unlocked'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Opacity(
                    opacity: isUnlocked ? 1.0 : 0.3,
                    child: Text(
                      achievement['icon'] as String,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isUnlocked
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          achievement['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnlocked
                                ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUnlocked)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  else
                    Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStatsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Statistics'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Track your cleaning progress and celebrate your achievements!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '📊 Metrics:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Current Streak: Consecutive days active'),
              Text('• Tasks Today: Tasks completed today'),
              Text('• Total Tasks: All-time completed tasks'),
              Text('• Declutter Progress: 30-day challenge'),
              SizedBox(height: 16),
              Text(
                '🏆 Achievements:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Unlock badges by completing tasks and maintaining streaks!'),
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
