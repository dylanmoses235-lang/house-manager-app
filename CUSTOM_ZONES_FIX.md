# Custom Zones Fix

## Problem
When users added custom zones in the Manage Zones screen:
1. Custom zones didn't appear in the zone selection dropdown in the Zone Cleaning screen
2. Custom zones couldn't be assigned to days in the weekly plan effectively
3. Users couldn't add tasks to custom zones

## Root Causes

### 1. Hardcoded Zone List in ZoneScreen
The `zone_screen.dart` had a hardcoded list of zones in the PopupMenu that didn't include custom zones:
```dart
// OLD CODE
return [
  'Kitchen',
  'Bathroom',
  'Bedroom',
  'Living Room',
  'Laundry Room',
  'Office',
  'Reset',
].map((zone) { ... }).toList();
```

### 2. HouseService Didn't Read Custom Schedule
The `HouseService.getTodayZone()` and `getTomorrowZone()` methods only read from the static `CleaningData.zoneSchedule` instead of checking SharedPreferences for the custom schedule saved by ManageZonesScreen.

### 3. No Task Management for Custom Zones
There was no way to add tasks to custom zones. The `CleaningData.zoneTasks` map only contained default zones.

## Solutions Implemented

### 1. Updated HouseService
- Added `getCustomZoneSchedule()` to read the zone schedule from SharedPreferences
- Added `getCustomZones()` to get the list of custom zones
- Added `getAllZones()` to return both default and custom zones
- Modified `getTodayZone()` and `getTomorrowZone()` to use async and read custom schedule
- Added `getZoneTasks()` to read custom tasks from SharedPreferences
- Added `saveZoneTasks()` to save custom tasks for any zone

### 2. Updated ZoneScreen
- Made the screen async-aware with loading states
- Changed to load available zones dynamically from `HouseService.getAllZones()`
- Added "Add Task" button in the app bar
- Added floating action button when zone has no tasks
- Created `_showAddTaskDialog()` to allow users to add tasks to any zone (custom or default)
- Tasks are saved to SharedPreferences with key `zone_tasks_{zoneName}`

### 3. Updated DashboardScreen
- Made `getTodayZone()` and `getTomorrowZone()` calls async
- Added loading state to prevent rendering with stale data
- Updated refresh functionality to reload zones

### 4. Updated CalendarScreen
- Cached the zone schedule in `_zoneSchedule` map
- Created both sync (`_getEventsForDaySync`) and async (`_getEventsForDay`) versions
- Used cached schedule for the TableCalendar's eventLoader (which requires sync function)
- Updated initialization to load custom schedule on startup

## How It Works Now

1. **Adding Custom Zones**: Users can add custom zones in Manage Zones screen (already worked)

2. **Assigning to Schedule**: Users can assign custom zones to any day of the week in Manage Zones screen (already worked)

3. **Viewing Custom Zones**: Custom zones now appear in the zone dropdown menu in Zone Cleaning screen

4. **Adding Tasks**: Users can click the "Add Task" button (➕) in the app bar to add tasks to any zone:
   - Enter task name
   - Enter "how to" instructions
   - Tasks are saved to SharedPreferences
   - Tasks persist across app restarts

5. **Weekly Plan Integration**: The weekly plan (dashboard and calendar) now correctly shows custom zones on their assigned days

## Technical Details

### Data Storage
- Zone schedule: `SharedPreferences` key `zone_schedule` (JSON map of day -> zone)
- Custom zones list: `SharedPreferences` key `custom_zones` (JSON array)
- Zone tasks: `SharedPreferences` key `zone_tasks_{zoneName}` (JSON array of task objects)

### Task Object Structure
```dart
{
  'task': 'Task name',
  'howTo': 'Instructions on how to complete the task'
}
```

## Files Modified
1. `/lib/services/house_service.dart` - Core service layer updates
2. `/lib/screens/zone_screen.dart` - Zone cleaning screen with task management
3. `/lib/screens/dashboard_screen.dart` - Dashboard async updates
4. `/lib/screens/calendar_screen.dart` - Calendar custom schedule support

## Testing Checklist
- [x] Custom zones appear in zone dropdown
- [x] Custom zones can be selected from dropdown
- [x] Tasks can be added to custom zones
- [x] Tasks persist after adding
- [x] Custom zones appear on correct days in weekly plan
- [x] Dashboard shows correct custom zone for today
- [x] Calendar shows custom zones on assigned days
