class DailyTasksData {
  // DAILY ESSENTIAL TASKS - Do EVERY DAY to prevent pileup!
  // These are non-negotiable maintenance tasks
  // Customized for household with 2 retrievers + boyfriend
  static List<Map<String, String>> dailyEssentialTasks = [
    {
      'id': 'dishes',
      'name': 'Wash All Dishes',
      'description': 'Wash all dishes in the sink, load dishwasher or hand-wash, dry and put away - Do morning & evening!',
      'emoji': '🍽️',
      'zone': 'Kitchen',
      'priority': 'critical',
      'estimatedMinutes': '15',
    },
    {
      'id': 'laundry_load',
      'name': 'One Load of Laundry',
      'description': 'Wash, dry, fold, and put away one load - Stay on top of it daily!',
      'emoji': '👕',
      'zone': 'Laundry Room',
      'priority': 'critical',
      'estimatedMinutes': '20',
    },
    {
      'id': 'feed_dogs_morning',
      'name': 'Feed Dogs (8:00 AM)',
      'description': 'Morning feeding for both retrievers at 8:00 AM',
      'emoji': '🐕',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'feed_dogs_evening',
      'name': 'Feed Dogs (5:15 PM)',
      'description': 'Evening feeding for both retrievers at 5:15 PM',
      'emoji': '🐕',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'dog_water',
      'name': 'Refill Dog Water Bowls',
      'description': 'Fresh water for both retrievers - check multiple times daily',
      'emoji': '💧',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '2',
    },
    {
      'id': 'boyfriend_cleanup',
      'name': 'Collect Boyfriend\'s Stuff',
      'description': 'Pick up scattered change, clothes, and random items throughout house',
      'emoji': '💰',
      'zone': 'Multiple',
      'priority': 'high',
      'estimatedMinutes': '10',
    },
    {
      'id': 'living_room_quick',
      'name': 'Quick Living Room Pickup',
      'description': 'BIGGEST MESS ZONE! 5-min tidy - dog toys, boyfriend\'s stuff, general clutter',
      'emoji': '🛋️',
      'zone': 'Living Room',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'dog_toys',
      'name': 'Pick Up Dog Toys',
      'description': 'Gather scattered dog toys, focus on living room',
      'emoji': '🎾',
      'zone': 'Living Room',
      'priority': 'medium',
      'estimatedMinutes': '5',
    },
    {
      'id': 'trash_check',
      'name': 'Check/Empty Trash',
      'description': 'Empty kitchen trash if full or smelly (important with 2 dogs!), replace bag',
      'emoji': '🗑️',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'floor_sweep',
      'name': 'Quick Floor Sweep',
      'description': 'Sweep retriever hair from main traffic areas - kitchen and living room',
      'emoji': '🧹',
      'zone': 'Multiple',
      'priority': 'high',
      'estimatedMinutes': '10',
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
      'description': 'Thoroughly wash food and water bowls for both dogs, clean feeding mat area',
      'emoji': '🐕',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'bathroom_quick',
      'name': 'Bathroom Quick Clean',
      'description': 'Wipe sink, counter, and toilet seat - 5 min maintenance',
      'emoji': '🚽',
      'zone': 'Bathroom',
      'priority': 'medium',
      'estimatedMinutes': '5',
    },
    {
      'id': 'mail_check',
      'name': 'Sort Mail & Packages',
      'description': 'Check mailbox, bring in packages, sort immediately - trash junk, file important',
      'emoji': '📬',
      'zone': 'Entry',
      'priority': 'medium',
      'estimatedMinutes': '3',
    },
    {
      'id': 'entry_wipe',
      'name': 'Wipe Dog Paw Prints',
      'description': 'Quick wipe entry area, door glass, and common paw-print zones',
      'emoji': '🐾',
      'zone': 'Entry',
      'priority': 'medium',
      'estimatedMinutes': '3',
    },
    {
      'id': 'unload_dishwasher',
      'name': 'Unload Dishwasher',
      'description': 'Put away all clean dishes - makes loading easier all day',
      'emoji': '🍽️',
      'zone': 'Kitchen',
      'priority': 'high',
      'estimatedMinutes': '5',
    },
    {
      'id': 'bedroom_reset',
      'name': 'Bedroom 5-Min Reset',
      'description': 'Before bed - clothes to hamper, surfaces clear, ready for tomorrow',
      'emoji': '🛏️',
      'zone': 'Bedroom',
      'priority': 'medium',
      'estimatedMinutes': '5',
    },
    {
      'id': 'check_supplies',
      'name': 'Check Pet & House Supplies',
      'description': 'Quick check: dog food, pee pads, trash bags, TP - add to shopping list if low',
      'emoji': '📋',
      'zone': 'Multiple',
      'priority': 'low',
      'estimatedMinutes': '2',
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
      
      case 'laundry_load':
        if (days == 0) return 'Laundry is all done!';
        if (days == 1) return 'One load waiting';
        if (days == 2) return 'Hamper getting full';
        if (days >= 4) return 'Laundry mountain forming! 😱';
        return 'Multiple loads waiting';
      
      case 'trash_check':
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
        if (days == 1) return 'Some retriever hair visible';
        if (days == 2) return 'Hair building up fast!';
        if (days >= 3) return 'Major dog hair tumbleweeds! 🐕';
        return 'Floors need sweeping';
      
      case 'dog_bowls':
        if (days == 0) return 'Dog bowls are clean!';
        if (days >= 1) return 'Bowls need washing';
        return 'Time to clean those bowls';
      
      case 'feed_dogs_morning':
        return days == 0 ? 'Fed this morning! ✓' : 'Remember 8:00 AM feeding!';
      
      case 'feed_dogs_evening':
        return days == 0 ? 'Fed this evening! ✓' : 'Remember 5:15 PM feeding!';
      
      case 'dog_water':
        if (days == 0) return 'Water bowls full & fresh!';
        if (days >= 1) return 'Check water bowls!';
        return 'Water needs refilling';
      
      case 'boyfriend_cleanup':
        if (days == 0) return 'All clear!';
        if (days == 1) return 'A few items scattered';
        if (days >= 2) return 'Change & clothes everywhere! 💰';
        return 'Boyfriend\'s stuff accumulating';
      
      case 'living_room_quick':
        if (days == 0) return 'Living room looks great!';
        if (days == 1) return 'Starting to look messy';
        if (days >= 2) return 'MESS ZONE activated! 🚨';
        return 'Living room needs attention';
      
      case 'dog_toys':
        if (days == 0) return 'Toys are picked up!';
        if (days == 1) return 'Toys scattered around';
        if (days >= 2) return 'Toy explosion!';
        return 'Dog toys everywhere';
      
      case 'bed_make':
        if (days == 0) return 'Bed is made!';
        if (days >= 1) return 'Bed needs making';
        return 'Unmade bed';
      
      case 'bathroom_quick':
        if (days == 0) return 'Bathroom is fresh!';
        if (days == 1) return 'Needs a quick wipe';
        if (days >= 2) return 'Getting messy in here!';
        return 'Bathroom needs attention';
      
      case 'mail_check':
        if (days == 0) return 'Mail sorted!';
        if (days == 1) return 'Mail piling up';
        if (days >= 3) return 'Mail mountain! 📬';
        return 'Need to sort mail';
      
      case 'entry_wipe':
        if (days == 0) return 'Entry is clean!';
        if (days == 1) return 'Some paw prints visible';
        if (days >= 2) return 'Muddy paw prints everywhere! 🐾';
        return 'Paw prints need cleaning';
      
      case 'unload_dishwasher':
        if (days == 0) return 'Dishwasher unloaded!';
        if (days >= 1) return 'Clean dishes waiting!';
        return 'Need to unload';
      
      case 'bedroom_reset':
        if (days == 0) return 'Bedroom is tidy!';
        if (days == 1) return 'Some clutter building';
        if (days >= 2) return 'Bedroom chaos! 😬';
        return 'Bedroom needs reset';
      
      case 'check_supplies':
        if (days == 0) return 'Supplies checked!';
        if (days >= 2) return 'Check supplies!';
        return 'Time to check supplies';
      
      default:
        return days == 0 ? 'Done!' : '$days days behind';
    }
  }
}
