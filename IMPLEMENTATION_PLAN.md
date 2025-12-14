# Implementation Plan - Sync Repository with Phone App

## 🎯 Objective
Align the repository code with the features currently working on your phone app.

---

## 📋 Identified Discrepancies

### 1. ❌ CRITICAL: Bottom Navigation Mismatch
**Current (Repo):** 6 tabs - Home, **Daily**, Zone, Schedule, Declutter, Stats  
**Phone App:** 5 tabs - Home, Zone, Schedule, Declutter, Stats

**Issue:** The "Daily" tab (DailyTasksScreen) exists in the repo but not on your phone.

**Decision Needed:** 
- Option A: Remove Daily tab from repo to match phone
- Option B: Add Daily tab to phone app (requires app rebuild)
- **Recommendation:** Remove Daily tab (Option A) since your phone doesn't have it

---

### 2. ❌ CRITICAL: Weekly Zone Plan Missing
**Phone App Shows:** Prominent "WEEKLY ZONE PLAN" section on Home screen showing:
```
Monday     → Kitchen
Tuesday    → Bathroom
Wednesday  → Bedroom
Thursday   → Living Room
Friday     → Laundry Room
Saturday   → Office
Sunday     → Reset (with 👉 indicator)
```

**Repository:** This widget/section does not exist at all

**Impact:** High - This is a key visual feature for weekly planning

---

### 3. ❌ CRITICAL: Mixed Zones Mode Missing
**Phone App Has:** Special "Mixed Zones Mode" toggle in Zone screen that:
- Shows ALL zones' tasks in one combined list
- Displays color-coded zone badges on each task
- Shows "All Zones Mixed!" header
- Displays "0 of 84 tasks completed across all zones"
- Bottom status: "🎨 Mixed Zones Mode: Tasks from all zones!"

**Repository:** This feature doesn't exist in zone_screen.dart

**Impact:** High - Major feature for power users who want to see everything at once

---

## 🛠️ Implementation Plan

### Phase 1: Fix Navigation Structure (30 minutes)
**Priority:** 🔴 Critical - Do First

**Files to modify:**
- `lib/main.dart` (lines 119-180)

**Changes:**
1. Remove DailyTasksScreen from navigation
2. Update _getScreen() method to remove case 1 (Daily)
3. Update NavigationBar destinations to remove Daily tab
4. Adjust navigation indices: Home(0), Zone(1), Schedule(2), Declutter(3), Stats(4)

**Code Changes:**
```dart
// Before: 6 destinations
// After: 5 destinations
destinations: const [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.cleaning_services_outlined),  
    selectedIcon: Icon(Icons.cleaning_services),
    label: 'Zone',
  ),
  NavigationDestination(
    icon: Icon(Icons.schedule_outlined),
    selectedIcon: Icon(Icons.schedule),
    label: 'Schedule',
  ),
  NavigationDestination(
    icon: Icon(Icons.delete_sweep_outlined),
    selectedIcon: Icon(Icons.delete_sweep),
    label: 'Declutter',
  ),
  NavigationDestination(
    icon: Icon(Icons.analytics_outlined),
    selectedIcon: Icon(Icons.analytics),
    label: 'Stats',
  ),
],

// Update _getScreen
Widget _getScreen(int index) {
  switch (index) {
    case 0:
      return DashboardScreen(onNavigate: _navigateToTab);
    case 1:
      return const ZoneScreen();
    case 2:
      return const ScheduleScreen();
    case 3:
      return const DeclutterScreen();
    case 4:
      return const StatisticsScreen();
    default:
      return DashboardScreen(onNavigate: _navigateToTab);
  }
}
```

**Testing:**
- Build and verify 5 tabs show correctly
- Verify each tab navigates to correct screen
- Test on iPhone

---

### Phase 2: Add Weekly Zone Plan Widget (1 hour)
**Priority:** 🔴 Critical

**New files to create:**
- `lib/widgets/weekly_zone_plan_card.dart`

**Files to modify:**
- `lib/screens/dashboard_screen.dart`

**Implementation:**

#### Step 1: Create the widget
```dart
// lib/widgets/weekly_zone_plan_card.dart
import 'package:flutter/material.dart';
import '../services/house_service.dart';

class WeeklyZonePlanCard extends StatelessWidget {
  const WeeklyZonePlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final weeklyPlan = HouseService.getWeeklyZonePlan();
    final today = DateTime.now().weekday; // 1=Monday, 7=Sunday
    
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
              final zone = weeklyPlan[dayName] ?? '';
              final isToday = dayIndex == today;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    if (isToday) const Text('👉 ', style: TextStyle(fontSize: 16)),
                    if (!isToday) const SizedBox(width: 24),
                    SizedBox(
                      width: 100,
                      child: Text(
                        dayName,
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday 
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        zone,
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
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
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }
}
```

#### Step 2: Add to Dashboard
In `dashboard_screen.dart`, add after Today's Info Card and before Declutter Challenge:

```dart
// After line 117 (after Today's Info Card)
const SizedBox(height: 16),

// Weekly Zone Plan Card
const WeeklyZonePlanCard(),

const SizedBox(height: 16),

// Then 30-Day Declutter Challenge Card...
```

#### Step 3: Add method to HouseService
In `lib/services/house_service.dart`, add:

```dart
static Map<String, String> getWeeklyZonePlan() {
  return {
    'Monday': 'Kitchen',
    'Tuesday': 'Bathroom',
    'Wednesday': 'Bedroom',
    'Thursday': 'Living Room',
    'Friday': 'Laundry Room',
    'Saturday': 'Office',
    'Sunday': 'Reset',
  };
}
```

**Testing:**
- Weekly plan shows on home screen
- Today's day is highlighted with 👉
- Scrolls properly with rest of dashboard

---

### Phase 3: Implement Mixed Zones Mode (2 hours)
**Priority:** 🔴 Critical

**Files to modify:**
- `lib/screens/zone_screen.dart`

**Implementation:**

#### Step 1: Add state variable and toggle
```dart
class _ZoneScreenState extends State<ZoneScreen> {
  // Existing variables...
  bool _isMixedMode = false; // Add this
  
  // ... rest of existing code
}
```

#### Step 2: Update app bar with toggle button
```dart
appBar: AppBar(
  title: Text(_isMixedMode ? 'Mixed Zones Mode' : 'Zone Cleaning'),
  actions: [
    // Mixed Mode Toggle
    IconButton(
      icon: Icon(_isMixedMode ? Icons.close : Icons.apps),
      onPressed: () {
        setState(() {
          _isMixedMode = !_isMixedMode;
        });
        _loadTasks(); // Reload with new mode
      },
      tooltip: _isMixedMode ? 'Exit Mixed Mode' : 'Mixed Zones Mode',
    ),
    // Existing add task button...
    IconButton(
      icon: const Icon(Icons.add_task),
      onPressed: _showAddTaskDialog,
      tooltip: 'Add Task',
    ),
    // Existing filter button (hide in mixed mode)
    if (!_isMixedMode)
      PopupMenuButton<String>(
        icon: const Icon(Icons.filter_list),
        onSelected: _changeZone,
        itemBuilder: (context) {
          return availableZones.map((zone) {
            return PopupMenuItem(
              value: zone,
              child: Text(zone),
            );
          }).toList();
        },
      ),
  ],
),
```

#### Step 3: Update _loadTasks method
```dart
Future<void> _loadTasks() async {
  if (_isMixedMode) {
    // Load ALL tasks from ALL zones
    List<Map<String, dynamic>> allTasks = [];
    taskCompletion = {};
    
    for (String zone in availableZones) {
      final zoneTasks = await HouseService.getZoneTasks(zone);
      final zoneCompletions = HouseService.getAllZoneTaskCompletions(zone);
      
      // Add zone info to each task
      for (var task in zoneTasks) {
        final taskWithZone = Map<String, dynamic>.from(task);
        taskWithZone['zone'] = zone; // Add zone identifier
        taskWithZone['zoneColor'] = _getZoneColor(zone);
        allTasks.add(taskWithZone);
      }
      
      // Merge completions
      taskCompletion.addAll(zoneCompletions);
    }
    
    tasks = allTasks;
  } else {
    // Existing single-zone load logic
    final zoneTasks = await HouseService.getZoneTasks(selectedZone);
    tasks = zoneTasks.map((task) => Map<String, dynamic>.from(task)).toList();
    taskCompletion = HouseService.getAllZoneTaskCompletions(selectedZone);
  }
}

Color _getZoneColor(String zone) {
  // Return color based on zone name
  switch (zone) {
    case 'Kitchen': return Colors.blue;
    case 'Bathroom': return Colors.cyan;
    case 'Bedroom': return Colors.purple;
    case 'Living Room': return Colors.green;
    case 'Laundry Room': return Colors.orange;
    case 'Office': return Colors.red;
    case 'Reset': return Colors.grey;
    default: return Colors.blueGrey;
  }
}
```

#### Step 4: Update header display
```dart
// Add below app bar, inside body Column
if (_isMixedMode)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Column(
      children: [
        const Icon(Icons.apps, size: 32),
        const SizedBox(height: 8),
        Text(
          'All Zones Mixed!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          '$completedCount of ${tasks.length} tasks completed across all zones',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    ),
  ),
```

#### Step 5: Add zone badges to task cards
```dart
// In task card ListTile, add badge before title
ListTile(
  leading: Checkbox(...),
  title: Row(
    children: [
      // Zone badge (only in mixed mode)
      if (_isMixedMode && task['zone'] != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: task['zoneColor'] ?? Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            task['zone'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      Expanded(
        child: Text(
          task['name'] ?? 'Task',
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    ],
  ),
  // ... rest of ListTile
),
```

#### Step 6: Add bottom info bar
```dart
// At bottom of Scaffold
bottomNavigationBar: _isMixedMode 
  ? Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎨 ', style: TextStyle(fontSize: 16)),
          Text(
            'Mixed Zones Mode: Tasks from all zones!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )
  : null,
```

**Testing:**
- Toggle mixed zones mode on/off
- Verify all tasks from all zones appear
- Check zone badges display correctly
- Test task completion in mixed mode
- Verify header shows correct count

---

## 📊 Implementation Timeline

| Phase | Task | Time Estimate | Priority |
|-------|------|---------------|----------|
| 1 | Fix Navigation (remove Daily tab) | 30 min | 🔴 Critical |
| 2 | Add Weekly Zone Plan widget | 1 hour | 🔴 Critical |
| 3 | Implement Mixed Zones Mode | 2 hours | 🔴 Critical |
| **Total** | | **3.5 hours** | |

---

## ✅ Testing Checklist

After implementation:

### Navigation
- [ ] Bottom nav shows exactly 5 tabs: Home, Zone, Schedule, Declutter, Stats
- [ ] Each tab navigates to correct screen
- [ ] Settings FAB works from all screens
- [ ] No errors in console

### Weekly Zone Plan
- [ ] Shows on home screen below Today's Info
- [ ] Displays all 7 days correctly
- [ ] Today's day is highlighted with 👉
- [ ] Zone names match schedule
- [ ] Scrolls with dashboard

### Mixed Zones Mode
- [ ] Toggle button works in Zone screen
- [ ] Mixed mode shows all tasks from all zones
- [ ] Zone badges display with correct colors
- [ ] Header shows correct count
- [ ] Task completion works in mixed mode
- [ ] Bottom info bar shows
- [ ] Exit mixed mode returns to normal zone view
- [ ] No crashes when switching modes

### General
- [ ] Dark mode works for all new features
- [ ] No performance issues
- [ ] Matches phone app appearance
- [ ] All existing features still work

---

## 🚀 Deployment Steps

1. **Implement changes** following this plan
2. **Test thoroughly** on development
3. **Commit changes** with clear messages:
   ```bash
   git add .
   git commit -m "feat: remove Daily tab to match phone app"
   git commit -m "feat: add Weekly Zone Plan to dashboard"
   git commit -m "feat: implement Mixed Zones Mode"
   ```
4. **Create pull request** to main branch
5. **Review and merge**
6. **Rebuild app** for iPhone:
   ```bash
   flutter clean
   flutter pub get
   flutter run --release
   ```
7. **Verify on phone** all features work

---

## 📝 Notes

- **DailyTasksScreen**: Keep the file in case needed later, but remove from navigation
- **Zone Colors**: Use consistent colors across app (define in theme or constants)
- **Performance**: Mixed mode loads all zones - consider lazy loading if performance issues
- **Future**: Consider adding mixed mode toggle to home screen quick actions

---

## ❓ Questions Before Starting

1. **Confirm Daily tab removal**: OK to completely remove from navigation?
2. **Weekly plan data**: Should this be editable or fixed schedule?
3. **Mixed mode default**: Should mixed mode state persist across app restarts?
4. **Zone colors**: Should these be customizable by user?

---

**Created:** December 14, 2025  
**Status:** Ready for Implementation  
**Estimated Completion:** 3-4 hours
