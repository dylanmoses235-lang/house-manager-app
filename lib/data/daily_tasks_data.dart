class DailyTasksData {
  // DAILY ESSENTIAL TASKS - Do EVERY DAY to prevent pileup!
  // These are non-negotiable maintenance tasks
  static List<Map<String, String>> dailyEssentialTasks = [
    {
      'id': 'dishes',
      'name': 'Wash All Dishes',
      'description': 'Wash all dishes in the sink, load dishwasher or hand-wash, dry and put away',
      'emoji': '🍽️',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '15',
    },
    {
      'id': 'kitchen_counter',
      'name': 'Clear & Wipe Counters',
      'description': 'Put away items and wipe down all counter surfaces',
      'emoji': '🧽',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '10',
    },
    {
      'id': 'dog_bowls',
      'name': 'Clean Dog Bowls',
      'description': 'Wash food and water bowls, clean feeding mat area',
      'emoji': '🐕',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'trash_check',
      'name': 'Check/Empty Trash',
      'description': 'Empty kitchen trash if full or smelly, replace bag',
      'emoji': '🗑️',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'floor_sweep',
      'name': 'Quick Floor Sweep',
      'description': 'Sweep main traffic areas - kitchen and living room for dog hair',
      'emoji': '🧹',
      'zone': 'Multiple',
      'priority': 'high',
      'estimatedMinutes': '10',
    },
    {
      'id': 'bathroom_quick',
      'name': 'Bathroom Quick Clean',
      'description': 'Wipe sink, counter, and toilet seat - 5 min maintenance',
      'emoji': '🚽',
      'zone': 'Bathroom',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'laundry_load',
      'name': 'One Load of Laundry',
      'description': 'Wash, dry, fold, and put away one load',
      'emoji': '👔',
      'zone': 'Laundry Room',
      'priority': 'high',
      'estimatedMinutes': '20',
    },
  ];

  // ROTATING TASKS - These happen less frequently
  // Do these 2-3x per week or as needed
  static List<Map<String, String>> dailyRecurringTasks = [
    {
      'id': 'sink',
      'name': 'Deep Clean Kitchen Sink',
      'description': 'Scrub basin thoroughly, shine faucet, clean around edges and drain',
      'emoji': '💧',
      'zone': 'Kitchen',
      'priority': 'medium',
      'estimatedMinutes': '10',
    },
    {
      'id': 'stovetop',
      'name': 'Deep Clean Stovetop',
      'description': 'Remove grates, degrease burners and knobs thoroughly',
      'emoji': '🔥',
      'zone': 'Kitchen',
      'priority': 'medium',
      'estimatedMinutes': '15',
    },
    {
      'id': 'microwave',
      'name': 'Clean Microwave',
      'description': 'Clean inside and outside, wipe buttons and door',
      'emoji': '📱',
      'zone': 'Kitchen',
      'priority': 'low',
      'estimatedMinutes': '10',
    },
    {
      'id': 'bathroom_floor',
      'name': 'Sweep/Mop Bathroom',
      'description': 'Sweep and mop bathroom floor thoroughly',
      'emoji': '🧹',
      'zone': 'Bathroom',
      'priority': 'medium',
      'estimatedMinutes': '10',
    },
    {
      'id': 'bed_make',
      'name': 'Make Bed',
      'description': 'Straighten sheets, pillows, and blankets',
      'emoji': '🛏️',
      'zone': 'Bedroom',
      'priority': 'medium',
      'estimatedMinutes': '5',
    },
    {
      'id': 'bedroom_clutter',
      'name': 'Pick Up Bedroom Floor',
      'description': 'Quick pickup of clothes and items on floor',
      'emoji': '👕',
      'zone': 'Bedroom',
      'priority': 'medium',
      'estimatedMinutes': '10',
    },
    {
      'id': 'living_room_clutter',
      'name': 'Clear Living Room',
      'description': 'Remove dishes, cups, random items from couch and tables',
      'emoji': '🛋️',
      'zone': 'Living Room',
      'priority': 'medium',
      'estimatedMinutes': '10',
    },
    {
      'id': 'vacuum_couch',
      'name': 'Vacuum Couch',
      'description': 'Remove dog hair and debris from couch cushions',
      'emoji': '🛋️',
      'zone': 'Living Room',
      'priority': 'low',
      'estimatedMinutes': '15',
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
