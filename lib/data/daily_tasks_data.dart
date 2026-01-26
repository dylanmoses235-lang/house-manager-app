class DailyTasksData {
  // Daily recurring tasks that need to be done every day to prevent pileup
  // These are the critical tasks that cause problems if skipped
  static List<Map<String, String>> dailyRecurringTasks = [
    {
      'id': 'dishes',
      'name': 'Wash All Dishes',
      'description': 'Wash all dishes in the sink, load dishwasher or hand-wash, dry and put away',
      'emoji': '🍽️',
      'zone': 'Kitchen',
      'priority': 'high',
    },
    {
      'id': 'kitchen_counter',
      'name': 'Clear & Wipe Counters',
      'description': 'Put away items and wipe down all counter surfaces',
      'emoji': '🧽',
      'zone': 'Kitchen',
      'priority': 'high',
    },
    {
      'id': 'sink',
      'name': 'Clean Kitchen Sink',
      'description': 'Scrub basin, shine faucet, wipe around edges',
      'emoji': '💧',
      'zone': 'Kitchen',
      'priority': 'medium',
    },
    {
      'id': 'stovetop',
      'name': 'Wipe Stovetop',
      'description': 'Quick wipe of burners and knobs after cooking',
      'emoji': '🔥',
      'zone': 'Kitchen',
      'priority': 'medium',
    },
    {
      'id': 'dog_bowls',
      'name': 'Clean Dog Bowls',
      'description': 'Wash food and water bowls, clean feeding mat area',
      'emoji': '🐕',
      'zone': 'Kitchen',
      'priority': 'high',
    },
    {
      'id': 'trash',
      'name': 'Take Out Trash',
      'description': 'Empty kitchen trash, replace bag if needed',
      'emoji': '🗑️',
      'zone': 'Kitchen',
      'priority': 'high',
    },
    {
      'id': 'floor_sweep',
      'name': 'Sweep Kitchen Floor',
      'description': 'Sweep kitchen floor - get crumbs, dog hair, and corners',
      'emoji': '🧹',
      'zone': 'Kitchen',
      'priority': 'medium',
    },
    {
      'id': 'bathroom_quick',
      'name': 'Bathroom Quick Clean',
      'description': 'Wipe sink, counter, and toilet seat - 5 min tidy',
      'emoji': '🚽',
      'zone': 'Bathroom',
      'priority': 'high',
    },
    {
      'id': 'bathroom_floor',
      'name': 'Quick Bathroom Sweep',
      'description': 'Sweep up dog hair and dust from bathroom floor',
      'emoji': '🧹',
      'zone': 'Bathroom',
      'priority': 'low',
    },
    {
      'id': 'bed_make',
      'name': 'Make Bed',
      'description': 'Straighten sheets, pillows, and blankets',
      'emoji': '🛏️',
      'zone': 'Bedroom',
      'priority': 'medium',
    },
    {
      'id': 'bedroom_clutter',
      'name': 'Pick Up Bedroom Floor',
      'description': 'Quick pickup of clothes, items on floor',
      'emoji': '👕',
      'zone': 'Bedroom',
      'priority': 'medium',
    },
    {
      'id': 'living_room_clutter',
      'name': 'Clear Living Room Surfaces',
      'description': 'Remove dishes, cups, random items from couch and tables',
      'emoji': '🛋️',
      'zone': 'Living Room',
      'priority': 'medium',
    },
    {
      'id': 'laundry',
      'name': 'One Load of Laundry',
      'description': 'Wash, dry, fold, and put away one load',
      'emoji': '👔',
      'zone': 'Laundry Room',
      'priority': 'medium',
    },
  ];

  // Get default description text for pileup
  static String getPileupDescription(String taskId, int days) {
    switch (taskId) {
      case 'dishes':
        if (days == 0) return 'Sink is clean!';
        if (days == 1) return 'A few dishes in the sink';
        if (days == 2) return 'Dishes starting to pile up';
        if (days >= 3) return 'Sink is full! Time to tackle this!';
        return 'Dishes need attention';
      
      case 'laundry':
        if (days == 0) return 'Laundry is all done!';
        if (days == 1) return 'One load waiting';
        if (days == 2) return 'Hamper getting full';
        if (days >= 4) return 'Laundry mountain forming! 😱';
        return 'Multiple loads waiting';
      
      case 'trash':
        if (days == 0) return 'Trash is empty!';
        if (days == 1) return 'Trash is getting full';
        if (days >= 2) return 'Trash needs to go out NOW!';
        return 'Trash is full';
      
      case 'kitchen_counter':
        if (days == 0) return 'Counters are clear!';
        if (days == 1) return 'A few items out';
        if (days >= 2) return 'Clutter taking over!';
        return 'Counters need clearing';
      
      case 'floor_sweep':
        if (days == 0) return 'Floors are clean!';
        if (days == 1) return 'Some crumbs and dog hair';
        if (days >= 3) return 'Major dog hair tumbleweeds!';
        return 'Floors need sweeping';
      
      case 'dog_bowls':
        if (days == 0) return 'Dog bowls are clean!';
        if (days >= 1) return 'Bowls need washing';
        return 'Time to clean those bowls';
      
      case 'bed_make':
        if (days == 0) return 'Bed is made!';
        if (days >= 1) return 'Bed needs making';
        return 'Unmade bed';
      
      case 'bathroom_quick':
        if (days == 0) return 'Bathroom is fresh!';
        if (days == 1) return 'Needs a quick wipe';
        if (days >= 2) return 'Getting messy in here!';
        return 'Bathroom needs attention';
      
      default:
        return days == 0 ? 'Done!' : '$days days behind';
    }
  }
}
