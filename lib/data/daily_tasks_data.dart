class DailyTasksData {
  // Daily recurring tasks that need to be done every day
  static List<Map<String, String>> dailyRecurringTasks = [
    {
      'id': 'dishes',
      'name': 'Wash Dishes',
      'description': 'Wash all dishes in the sink, load dishwasher or hand-wash, dry and put away',
      'emoji': '🍽️',
    },
    {
      'id': 'laundry',
      'name': 'Laundry',
      'description': 'Wash, dry, fold, and put away one load of laundry',
      'emoji': '👕',
    },
    {
      'id': 'trash',
      'name': 'Take Out Trash',
      'description': 'Empty all trash cans and take bags to the curb/dumpster',
      'emoji': '🗑️',
    },
    {
      'id': 'kitchen_counter',
      'name': 'Clear Kitchen Counter',
      'description': 'Put away items and wipe down all counter surfaces',
      'emoji': '🧽',
    },
    {
      'id': 'floor_sweep',
      'name': 'Quick Floor Sweep',
      'description': 'Sweep main traffic areas - kitchen and living room',
      'emoji': '🧹',
    },
    {
      'id': 'dog_bowls',
      'name': 'Clean Dog Bowls',
      'description': 'Wash food and water bowls, clean feeding mat area',
      'emoji': '🐕',
    },
    {
      'id': 'bed_make',
      'name': 'Make Bed',
      'description': 'Straighten sheets, pillows, and blankets',
      'emoji': '🛏️',
    },
    {
      'id': 'bathroom_quick',
      'name': 'Bathroom Quick Clean',
      'description': 'Wipe sink, counter, and toilet seat - 5 min tidy',
      'emoji': '🚽',
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
