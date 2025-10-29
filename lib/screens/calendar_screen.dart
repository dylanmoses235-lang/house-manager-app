import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../services/house_service.dart';
import '../data/cleaning_data.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<_CalendarEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<_CalendarEvent> _getEventsForDay(DateTime day) {
    final events = <_CalendarEvent>[];
    
    // Get zone for this day
    final dayName = DateFormat('EEEE').format(day);
    final zone = CleaningData.zoneSchedule[dayName];
    if (zone != null) {
      events.add(_CalendarEvent(
        title: 'Zone: $zone',
        type: 'zone',
        icon: Icons.cleaning_services,
        color: Colors.blue,
      ));
    }

    // Get schedule type
    final isWeekend = day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    events.add(_CalendarEvent(
      title: isWeekend ? 'Weekend Schedule' : 'Weekday Schedule',
      type: 'schedule',
      icon: Icons.schedule,
      color: Colors.orange,
    ));

    // Check if there's a declutter task for this day
    final challengeStartDate = HouseService.getChallengeStartDate();
    if (challengeStartDate != null) {
      final daysSinceStart = day.difference(challengeStartDate).inDays + 1;
      if (daysSinceStart >= 1 && daysSinceStart <= 30) {
        final declutterDays = HouseService.getAllDeclutterDays();
        final declutterDay = declutterDays.firstWhere(
          (d) => d.day == daysSinceStart,
          orElse: () => declutterDays.first,
        );
        events.add(_CalendarEvent(
          title: 'Declutter: ${declutterDay.area}',
          type: 'declutter',
          icon: Icons.delete_sweep,
          color: Colors.purple,
          subtitle: declutterDay.task,
        ));
      }
    }

    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar<_CalendarEvent>(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
              ),
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<_CalendarEvent>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM d, y').format(_selectedDay!),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isSameDay(_selectedDay, DateTime.now())) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: value.isEmpty
                          ? const Center(
                              child: Text('No tasks scheduled for this day'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return _buildEventCard(value[index]);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(_CalendarEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: event.color.withOpacity(0.2),
          child: Icon(
            event.icon,
            color: event.color,
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: event.subtitle != null ? Text(event.subtitle!) : null,
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: () {
          // Navigate to appropriate screen based on type
          if (event.type == 'zone') {
            DefaultTabController.of(context)?.animateTo(1);
            Navigator.pop(context);
          } else if (event.type == 'schedule') {
            DefaultTabController.of(context)?.animateTo(2);
            Navigator.pop(context);
          } else if (event.type == 'declutter') {
            DefaultTabController.of(context)?.animateTo(3);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class _CalendarEvent {
  final String title;
  final String type;
  final IconData icon;
  final Color color;
  final String? subtitle;

  _CalendarEvent({
    required this.title,
    required this.type,
    required this.icon,
    required this.color,
    this.subtitle,
  });
}
