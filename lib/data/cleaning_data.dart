class CleaningData {
  // Zone to Day mapping
  static Map<String, String> zoneSchedule = {
    'Monday': 'Kitchen',
    'Tuesday': 'Bathroom',
    'Wednesday': 'Bedroom',
    'Thursday': 'Living Room',
    'Friday': 'Laundry Room',
    'Saturday': 'Office',
    'Sunday': 'Reset',
  };

  // Zone cleaning tasks (from your spreadsheet)
  static Map<String, List<Map<String, String>>> zoneTasks = {
    'Kitchen': [
      {
        'task': 'Clear all clutter from center table',
        'howTo': 'Put away items, trash the garbage, create clear workspace - this is priority #1'
      },
      {
        'task': 'Clear and organize countertops',
        'howTo': 'Put away items, wipe down all counter surfaces'
      },
      {
        'task': 'Wash all dishes in sink',
        'howTo': 'Load dishwasher or hand-wash, dry and put away'
      },
      {
        'task': 'Wipe stovetop',
        'howTo': 'Remove pots/pans first, use degreaser on burners and knobs'
      },
      {
        'task': 'Clean microwave inside/out',
        'howTo': 'Damp cloth inside, wipe buttons and door'
      },
      {
        'task': 'Wipe fridge exterior',
        'howTo': 'Focus on handles and dog nose-height areas'
      },
      {
        'task': 'Wipe cabinets & drawer fronts',
        'howTo': 'All handles, lower edges where dogs reach'
      },
      {
        'task': 'Clean sink and faucet',
        'howTo': 'Scrub basin, shine faucet, wipe around edges'
      },
      {
        'task': 'Wipe backsplash tiles',
        'howTo': 'Behind sink and stove areas'
      },
      {
        'task': 'Clean small appliances',
        'howTo': 'Toaster, coffee maker - including underneath'
      },
      {
        'task': 'Empty trash completely',
        'howTo': 'Take out bag, wipe can inside/out'
      },
      {
        'task': 'Clean dog bowl area',
        'howTo': 'Wipe bowls, clean feeding mat, sweep around it'
      },
      {
        'task': 'Sweep entire floor',
        'howTo': 'Get corners, under table, all crumbs and dog hair'
      },
      {
        'task': 'Mop floor',
        'howTo': 'Use preferred method after sweeping - watch for dark grout'
      },
      {
        'task': 'Wipe light switches',
        'howTo': 'Entry switch and any near sink'
      },
    ],
    'Bathroom': [
      {
        'task': 'Pick up all floor items',
        'howTo': 'Clothes to hamper, trash to bin - clear the floor first'
      },
      {
        'task': 'Clear vanity countertop',
        'howTo': 'Put items away or in organizer basket'
      },
      {
        'task': 'Wipe vanity counter & backsplash',
        'howTo': 'Full counter wipe after clearing items'
      },
      {
        'task': 'Clean mirror edge to edge',
        'howTo': 'Glass cleaner or microfiber, no streaks'
      },
      {
        'task': 'Clean sink & faucet',
        'howTo': 'Scrub basin, polish faucet and handles'
      },
      {
        'task': 'Scrub toilet bowl',
        'howTo': 'Brush and cleaner, under rim too'
      },
      {
        'task': 'Wipe toilet exterior',
        'howTo': 'Tank, lid, seat, base, floor around it - top to bottom'
      },
      {
        'task': 'Wipe shower/tub walls',
        'howTo': 'Gray tiles and brown accent tiles, focus on soap scum'
      },
      {
        'task': 'Clean shower floor/tub',
        'howTo': 'Scrub and rinse grime'
      },
      {
        'task': 'Wipe shower ledge & bottles',
        'howTo': 'Clean ledge, wipe bottle bottoms'
      },
      {
        'task': 'Wipe cabinet fronts',
        'howTo': 'Vanity and linen closet doors, black handles'
      },
      {
        'task': 'Empty trash can',
        'howTo': 'Replace liner if needed'
      },
      {
        'task': 'Check puppy pad area',
        'howTo': 'Replace pad if needed, wipe mat underneath'
      },
      {
        'task': 'Sweep/vacuum floor',
        'howTo': 'All corners, behind toilet, get dog hair'
      },
      {
        'task': 'Mop floor',
        'howTo': 'Disinfectant mop, pay attention to toilet base and grout'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'White baseboards show dog nose prints easily'
      },
    ],
    'Bedroom': [
      {
        'task': 'Make bed fully',
        'howTo': 'Straighten sheets, pillows, blankets - remove any clutter from bed'
      },
      {
        'task': 'Pick up floor clutter',
        'howTo': 'Boxes, bags, wires, clothes - clear the floor completely'
      },
      {
        'task': 'Clear dresser top clutter',
        'howTo': 'Organize items, trash empties, manage cables'
      },
      {
        'task': 'Dust dresser surface',
        'howTo': 'Wipe top, sides, around TV and small shelf'
      },
      {
        'task': 'Clean TV screen',
        'howTo': 'Dry microfiber only, gentle circular motion'
      },
      {
        'task': 'Dust nightstand/floating shelf',
        'howTo': 'Move items to clean underneath'
      },
      {
        'task': 'Organize bar cart',
        'howTo': 'Remove empty cans, wipe shelves, restock neatly'
      },
      {
        'task': 'Dust marble console/vanity table',
        'howTo': 'Damp cloth on marble, dry immediately, wipe frame'
      },
      {
        'task': 'Wipe bedroom doors',
        'howTo': 'Both sides, handles, clean smudges at dog height'
      },
      {
        'task': 'Dust wall art & frames',
        'howTo': 'Gently wipe all visible artwork'
      },
      {
        'task': 'Check under bed',
        'howTo': 'Remove trash or items, sweep if accessible'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'Focus around door and furniture edges'
      },
      {
        'task': 'Pet hair patrol',
        'howTo': 'Lint roll bedding if needed, check furniture'
      },
      {
        'task': 'Sweep entire floor',
        'howTo': 'All corners, under furniture, get all dog hair on tile'
      },
      {
        'task': 'Spot mop if needed',
        'howTo': 'Address any sticky spots or spills'
      },
    ],
    'Living Room': [
      {
        'task': 'Straighten couch pillows',
        'howTo': 'Fluff pillows, fold throw blankets neatly'
      },
      {
        'task': 'Clear clutter from surfaces',
        'howTo': 'Remove dishes, cups, random items from all surfaces'
      },
      {
        'task': 'Wipe kitchen island/entry table',
        'howTo': 'Striped wood surface and white tiered table'
      },
      {
        'task': 'Dust tiered side table',
        'howTo': 'Both levels, gold legs, organize items'
      },
      {
        'task': 'Vacuum couch',
        'howTo': 'Get cushions, crevices, remove dog hair'
      },
      {
        'task': 'Clean TV screen',
        'howTo': 'Dry microfiber cloth only'
      },
      {
        'task': 'Wipe TV stand/console',
        'howTo': 'Under devices, around cords'
      },
      {
        'task': 'Clean large mirror',
        'howTo': 'Full edge-to-edge wipe, no streaks'
      },
      {
        'task': 'Dust wall art & frames',
        'howTo': 'All mounted décor gently'
      },
      {
        'task': 'Wipe door & glass panel',
        'howTo': 'Front door, glass insert, black door surface'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'Along couch, mirror, and corners'
      },
      {
        'task': 'Wipe light switches',
        'howTo': 'Entry switches and outlets'
      },
      {
        'task': 'Pet hair patrol',
        'howTo': 'Lint roll furniture, check around couch base'
      },
      {
        'task': 'Sweep/vacuum floor',
        'howTo': 'Dark tile shows everything - get all corners and under furniture'
      },
      {
        'task': 'Mop floor',
        'howTo': 'After sweeping, focus on traffic paths'
      },
    ],
    'Laundry Room': [
      {
        'task': 'Pick up ALL floor clutter',
        'howTo': 'This is priority #1 - clear the walking path completely'
      },
      {
        'task': 'Wipe washer/dryer tops',
        'howTo': 'Remove items first, wipe both surfaces clean'
      },
      {
        'task': 'Clean detergent area',
        'howTo': 'Wipe spills, clean cap and dispensers'
      },
      {
        'task': 'Wipe window sill & blinds',
        'howTo': 'Dust sill, wipe blinds if dusty'
      },
      {
        'task': 'Wipe shelf',
        'howTo': 'Wooden shelf - dust and wipe, organize items on it'
      },
      {
        'task': 'Wipe chest freezer top & sides',
        'howTo': 'Full exterior wipe down'
      },
      {
        'task': 'Check supplies stock',
        'howTo': 'Detergent, dryer sheets, stain spray'
      },
      {
        'task': 'Wipe door & frame',
        'howTo': 'Both sides if accessible, clean handle'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'White baseboards along both walls'
      },
      {
        'task': 'Sweep floor thoroughly',
        'howTo': 'Narrow space - get both sides, all corners'
      },
      {
        'task': 'Mop floor',
        'howTo': 'After sweeping, full floor mop'
      },
    ],
    'Office': [
      {
        'task': 'Pick up all floor clutter',
        'howTo': 'Clear the walking path - this is the biggest issue'
      },
      {
        'task': 'Clear desk surface',
        'howTo': 'Toss trash, organize items, wipe down all desk levels'
      },
      {
        'task': 'Dust monitors & electronics',
        'howTo': 'Microfiber on screens, light wipe on equipment'
      },
      {
        'task': 'Organize desk cables',
        'howTo': 'Bundle cords, secure loose wires'
      },
      {
        'task': 'Disinfect keyboard & mouse',
        'howTo': 'Electronics-safe wipes'
      },
      {
        'task': 'Vacuum/dust office chair',
        'howTo': 'Fabric chair - get crevices and wheels'
      },
      {
        'task': 'Wipe armchair',
        'howTo': 'Grey patterned chair - vacuum or spot clean'
      },
      {
        'task': 'Clean mirror',
        'howTo': 'Large frameless mirror behind desk'
      },
      {
        'task': 'Wipe window & curtain rod',
        'howTo': 'Dust curtain rod, wipe window if accessible'
      },
      {
        'task': 'Empty trash',
        'howTo': 'Clear any trash from floor or desk'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'Around room perimeter'
      },
      {
        'task': 'Sweep/vacuum floor',
        'howTo': 'Tile floor - under desk, around chair, all visible areas'
      },
    ],
    'Reset': [
      {
        'task': 'Light tidy-up all rooms',
        'howTo': 'Quick scan of each room, fix anything obvious'
      },
      {
        'task': 'Catch up missed tasks',
        'howTo': 'Review the week, knock out anything skipped'
      },
      {
        'task': 'Final laundry load',
        'howTo': 'Wash, dry, fold and put away'
      },
      {
        'task': 'Reset bathroom essentials',
        'howTo': 'Swap towels, refill TP, restock items'
      },
      {
        'task': 'Quick fridge cleanout',
        'howTo': 'Toss old leftovers, wipe shelves if needed'
      },
      {
        'task': 'Take out all trash',
        'howTo': 'Every room - fresh start for the week'
      },
      {
        'task': 'Meal prep check',
        'howTo': 'Review upcoming week schedule and meals'
      },
      {
        'task': 'Restock pet supplies',
        'howTo': 'Check dog food, treats, prep bowls for week'
      },
      {
        'task': 'Review planner',
        'howTo': 'Check upcoming appointments and tasks'
      },
    ],
  };

  // 30-Day Declutter Challenge
  static List<Map<String, String>> declutterChallenge = [
    {'day': '1', 'area': 'Kitchen', 'task': 'Clear 1 drawer'},
    {'day': '2', 'area': 'Living Room', 'task': 'Declutter coffee table'},
    {'day': '3', 'area': 'Bedroom', 'task': 'Clear nightstand'},
    {'day': '4', 'area': 'Office', 'task': 'Sort one paper stack'},
    {'day': '5', 'area': 'Bathroom', 'task': 'Toss expired products'},
    {'day': '6', 'area': 'Laundry', 'task': 'Clear shelf items'},
    {'day': '7', 'area': 'Entry', 'task': 'Shoes/coat tidy'},
    {'day': '8', 'area': 'Pantry', 'task': 'Expired items check'},
    {'day': '9', 'area': 'Refrigerator', 'task': 'Clean door shelves'},
    {'day': '10', 'area': 'Freezer', 'task': 'Organize & toss old items'},
    {'day': '11', 'area': 'Kitchen', 'task': 'Under sink cleanup'},
    {'day': '12', 'area': 'Living Room', 'task': 'TV stand/media center tidy'},
    {'day': '13', 'area': 'Bookshelves', 'task': 'Declutter one shelf'},
    {'day': '14', 'area': 'Hall Closet', 'task': 'Top shelf cleanup'},
    {'day': '15', 'area': 'Bedroom', 'task': 'Under bed storage tidy'},
    {'day': '16', 'area': 'Misc', 'task': 'Junk drawer #2'},
    {'day': '17', 'area': 'Bathroom', 'task': 'Organize drawers'},
    {'day': '18', 'area': 'Bathroom', 'task': 'Sort makeup/skincare bin'},
    {'day': '19', 'area': 'Pets', 'task': 'Organize dog supplies bin'},
    {'day': '20', 'area': 'Garage/Storage', 'task': 'Sort one storage bin'},
    {'day': '21', 'area': 'Car', 'task': 'Clean front seat area'},
    {'day': '22', 'area': 'Car', 'task': 'Clean trunk'},
    {'day': '23', 'area': 'Storage', 'task': 'Seasonal decorations bin'},
    {'day': '24', 'area': 'Hobbies', 'task': 'Sort craft/hobby supplies'},
    {'day': '25', 'area': 'Entryway', 'task': 'Clear table/key station'},
    {'day': '26', 'area': 'Personal', 'task': 'Purse/wallet cleanout'},
    {'day': '27', 'area': 'Digital', 'task': 'Clear phone & computer files'},
    {'day': '28', 'area': 'Mail Area', 'task': 'Sort and toss old mail'},
    {'day': '29', 'area': 'Pets', 'task': 'Check pet medications/treats bin'},
    {'day': '30', 'area': 'Misc', 'task': 'Donate/toss box run'},
  ];

  // Weekday Schedule
  static List<Map<String, String>> weekdaySchedule = [
    {'time': '7:15 AM', 'task': 'Wake Up', 'details': 'Open curtains, stretch, drink water'},
    {'time': '7:20 AM', 'task': 'Dog Potty', 'details': 'Let dogs out, praise, wipe paws'},
    {'time': '7:35 AM', 'task': 'Feed Dogs', 'details': 'Food + fresh water'},
    {'time': '7:45 AM', 'task': 'Meds & Hygiene', 'details': 'ADHD meds, brush teeth, deodorant'},
    {'time': '8:00 AM', 'task': 'Quick Reset', 'details': 'Wipe counters, trash check, prep for work'},
    {'time': '8:30 AM', 'task': 'Work Block 1', 'details': 'Focus time – deep work, priority tasks'},
    {'time': '10:45 AM', 'task': 'Break 1', 'details': 'Stretch, hydrate, quick step outside'},
    {'time': '11:00 AM', 'task': 'Work Block 2', 'details': 'Emails, calls, task wrap-ups'},
    {'time': '12:30 PM', 'task': 'Break 2 + Dog Time', 'details': 'Lunch, walk/play with dogs, decompress'},
    {'time': '1:00 PM', 'task': 'Work Block 3', 'details': 'Meetings or flow work'},
    {'time': '3:00 PM', 'task': 'Break 3', 'details': 'Reset one room or decompress — optional tidy'},
    {'time': '3:15 PM', 'task': 'Final Work Block', 'details': 'Wrap-up, prep for tomorrow, close tasks'},
    {'time': '5:00 PM', 'task': 'Evening Dog Walk', 'details': 'Walk, play, sniff time'},
    {'time': '5:30 PM', 'task': 'Dinner Prep', 'details': 'Cook, wipe counters, unload dishwasher'},
    {'time': '6:00 PM', 'task': 'Dinner', 'details': 'Sit down to eat, unwind'},
    {'time': '6:45 PM', 'task': 'Daily Clean', 'details': 'Zone cleaning tasks for today'},
    {'time': '7:30 PM', 'task': 'Dog Groom', 'details': 'Brush, ear check, paw inspection'},
    {'time': '8:00 PM', 'task': 'Laundry / Reset', 'details': 'Fold, put away, prep clothes for tomorrow'},
    {'time': '8:30 PM', 'task': 'Free Time', 'details': 'TV, games, crafting, whatever you want'},
    {'time': '9:30 PM', 'task': 'Wind Down', 'details': 'Shower, lights low, calm music'},
    {'time': '10:00 PM', 'task': 'Sleep', 'details': 'White noise, Rave cuddles, no phone'},
  ];

  // Weekend Schedule
  static List<Map<String, String>> weekendSchedule = [
    {'time': '8:00 AM', 'task': 'Wake Up', 'details': 'Take your time, hydrate, sunlight in'},
    {'time': '8:15 AM', 'task': 'Dog Potty', 'details': 'Let dogs out, praise, fresh air'},
    {'time': '8:30 AM', 'task': 'Feed Dogs', 'details': 'Food + clean water'},
    {'time': '9:00 AM', 'task': 'Morning Reset', 'details': 'Tidy counters, quick trash check, dishes if needed'},
    {'time': '9:30 AM', 'task': 'Light Clean / Laundry', 'details': 'Quick vacuum, laundry load 1'},
    {'time': '10:00 AM', 'task': '30-Day Declutter', 'details': 'Today\'s declutter challenge task'},
    {'time': '11:00 AM', 'task': 'Free Time / Hobby', 'details': 'Watch show, read, play game — whatever fuels you'},
    {'time': '12:00 PM', 'task': 'Lunch', 'details': 'Real food, not just vibes'},
    {'time': '12:30 PM', 'task': 'Dog Walk', 'details': 'Midday walk, fetch, nose work'},
    {'time': '1:30 PM', 'task': 'Cleaning Zone Reset', 'details': 'Zone cleaning tasks for today'},
    {'time': '2:30 PM', 'task': 'Grocery / Errands', 'details': 'Restock fridge/pantry, target run, etc.'},
    {'time': '3:30 PM', 'task': 'Laundry Finish', 'details': 'Fold & put away, wipe appliances'},
    {'time': '4:00 PM', 'task': 'Chill Reset', 'details': 'Candle lit, cozy clothes, reset vibes'},
    {'time': '5:00 PM', 'task': 'Dog Groom', 'details': 'Brush, paws, ears'},
    {'time': '5:30 PM', 'task': 'Dinner Prep', 'details': 'Cook or order out — your call'},
    {'time': '6:00 PM', 'task': 'Dinner', 'details': 'Sit, relax, eat something warm'},
    {'time': '7:00 PM', 'task': 'Evening Tidy', 'details': 'Quick cleanup, counters, dishes'},
    {'time': '8:00 PM', 'task': 'Free Time', 'details': 'Creative or calm — you pick'},
    {'time': '9:30 PM', 'task': 'Wind Down', 'details': 'Lights low, screens off if possible'},
    {'time': '10:00 PM', 'task': 'Sleep', 'details': 'Bedtime routine + cuddles'},
  ];
}
