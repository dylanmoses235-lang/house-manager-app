import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../services/house_service.dart';
import '../models/declutter_day.dart';

class DeclutterScreen extends StatefulWidget {
  const DeclutterScreen({super.key});

  @override
  State<DeclutterScreen> createState() => _DeclutterScreenState();
}

class _DeclutterScreenState extends State<DeclutterScreen> {
  @override
  Widget build(BuildContext context) {
    final allDays = HouseService.getAllDeclutterDays();
    final currentDay = HouseService.getCurrentDeclutterDay();
    final progress = HouseService.getDeclutterProgress();
    final startDate = HouseService.getChallengeStartDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('30-Day Declutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Challenge?'),
                  content: const Text(
                    'This will reset all progress and start the challenge from Day 1.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        await HouseService.resetChallenge();
                        if (mounted) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 80,
                    lineWidth: 16,
                    percent: (progress / 30).clamp(0.0, 1.0),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$progress',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'days',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    progressColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${30 - progress} days remaining',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  if (startDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Started: ${DateFormat('MMM d, yyyy').format(startDate)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Current Day Card
            if (currentDay != null && !currentDay.isCompleted) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'TODAY - Day ${currentDay.day}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onTertiary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentDay.area,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentDay.task,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              await HouseService.toggleDeclutterDay(currentDay.day);
                              setState(() {});
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Mark as Complete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // All Days List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All 30 Days',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...allDays.map((day) => _buildDayCard(day)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(DeclutterDay day) {
    final isCurrent = HouseService.getCurrentDeclutterDay()?.day == day.day;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: day.isCompleted
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: day.isCompleted
              ? Colors.green
              : isCurrent
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: day.isCompleted
              ? const Icon(Icons.check, color: Colors.white)
              : Text(
                  '${day.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.white : null,
                  ),
                ),
        ),
        title: Row(
          children: [
            if (isCurrent) const Text('👉 ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Text(
                day.area,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: day.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          day.task,
          style: TextStyle(
            decoration: day.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Checkbox(
          value: day.isCompleted,
          onChanged: (value) async {
            await HouseService.toggleDeclutterDay(day.day);
            setState(() {});
          },
        ),
      ),
    );
  }
}
