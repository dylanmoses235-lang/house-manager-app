import 'package:flutter/material.dart';
import '../services/house_service.dart';

class WeeklyZonePlanCard extends StatelessWidget {
  const WeeklyZonePlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = now.weekday; // 1=Monday, 7=Sunday
    
    // Define the weekly zone schedule (matches phone app)
    final weeklyPlan = {
      1: 'Kitchen',
      2: 'Bathroom',
      3: 'Bedroom',
      4: 'Living Room',
      5: 'Laundry Room',
      6: 'Office',
      7: 'Reset',
    };
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📅 ', style: TextStyle(fontSize: 24)),
                const Text(
                  'WEEKLY ZONE PLAN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(7, (index) {
              final dayIndex = index + 1; // 1-7 for Mon-Sun
              final dayName = _getDayName(dayIndex);
              final zone = weeklyPlan[dayIndex] ?? '';
              final isToday = dayIndex == today;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    // Indicator emoji for today
                    if (isToday) 
                      const Text('👉 ', style: TextStyle(fontSize: 16))
                    else 
                      const SizedBox(width: 28),
                    // Day name
                    SizedBox(
                      width: 110,
                      child: Text(
                        dayName,
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                          color: isToday 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    // Zone name
                    Expanded(
                      child: Text(
                        zone,
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                          color: isToday 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  String _getDayName(int day) {
    const days = [
      'Monday',
      'Tuesday', 
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[day - 1];
  }
}
