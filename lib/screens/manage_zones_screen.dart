import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ManageZonesScreen extends StatefulWidget {
  const ManageZonesScreen({super.key});

  @override
  State<ManageZonesScreen> createState() => _ManageZonesScreenState();
}

class _ManageZonesScreenState extends State<ManageZonesScreen> {
  Map<String, String> _zoneSchedule = {};
  List<String> _customZones = [];
  bool _isLoading = true;

  final List<String> _defaultZones = [
    'Kitchen',
    'Bathroom',
    'Bedroom',
    'Living Room',
    'Laundry Room',
    'Office',
    'Reset',
  ];

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _loadZoneSchedule();
  }

  Future<void> _loadZoneSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load custom zones
    final customZonesJson = prefs.getString('custom_zones');
    if (customZonesJson != null) {
      _customZones = List<String>.from(json.decode(customZonesJson));
    }

    // Load zone schedule
    final scheduleJson = prefs.getString('zone_schedule');
    if (scheduleJson != null) {
      _zoneSchedule = Map<String, String>.from(json.decode(scheduleJson));
    } else {
      // Use default schedule
      _zoneSchedule = {
        'Monday': 'Kitchen',
        'Tuesday': 'Bathroom',
        'Wednesday': 'Bedroom',
        'Thursday': 'Living Room',
        'Friday': 'Laundry Room',
        'Saturday': 'Office',
        'Sunday': 'Reset',
      };
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveZoneSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zone_schedule', json.encode(_zoneSchedule));
    await prefs.setString('custom_zones', json.encode(_customZones));
  }

  void _addCustomZone() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Zone'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Zone Name',
            hintText: 'e.g., Garage, Basement, Patio',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _customZones.add(controller.text);
                });
                _saveZoneSchedule();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteCustomZone(String zone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Zone?'),
        content: Text('Remove "$zone" from your custom zones?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _customZones.remove(zone);
                // Remove from schedule if assigned
                _zoneSchedule.removeWhere((key, value) => value == zone);
              });
              _saveZoneSchedule();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editDayAssignment(String day) {
    final allZones = [..._defaultZones, ..._customZones];
    final currentZone = _zoneSchedule[day] ?? 'Kitchen';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$day - Select Zone'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: allZones.map((zone) {
              return RadioListTile<String>(
                title: Text(zone),
                value: zone,
                groupValue: currentZone,
                onChanged: (value) {
                  setState(() {
                    _zoneSchedule[day] = value!;
                  });
                  _saveZoneSchedule();
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults?'),
        content: const Text(
          'This will reset the zone schedule to default values and remove all custom zones.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              setState(() {
                _zoneSchedule = {
                  'Monday': 'Kitchen',
                  'Tuesday': 'Bathroom',
                  'Wednesday': 'Bedroom',
                  'Thursday': 'Living Room',
                  'Friday': 'Laundry Room',
                  'Saturday': 'Office',
                  'Sunday': 'Reset',
                };
                _customZones.clear();
              });
              await _saveZoneSchedule();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reset to defaults')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Zones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weekly Schedule Section
          const Text(
            '📅 Weekly Zone Schedule',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap any day to change its assigned zone',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._days.map((day) {
            final zone = _zoneSchedule[day] ?? 'Kitchen';
            final isToday = day == DateTime.now().weekday.toString();
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    day.substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                title: Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(zone),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _editDayAssignment(day),
              ),
            );
          }),

          const SizedBox(height: 32),

          // Custom Zones Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🏠 Custom Zones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: _addCustomZone,
                icon: const Icon(Icons.add),
                label: const Text('Add Zone'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_customZones.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No custom zones yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add zones like Garage, Basement, Patio, etc.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ..._customZones.map((zone) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.home),
                  ),
                  title: Text(zone),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteCustomZone(zone),
                  ),
                ),
              );
            }),

          const SizedBox(height: 32),

          // Default Zones Reference
          const Text(
            '📋 Default Zones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'These zones are always available',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _defaultZones.map((zone) {
                  return Chip(
                    label: Text(zone),
                    avatar: const Icon(Icons.check_circle, size: 18),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
