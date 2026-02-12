class CleaningData {
  // Zone to Day mapping - Rotating Deep Cleaning Schedule
  // Daily essentials (dishes, trash, etc.) are done EVERY day
  // Zone tasks are the DEEP CLEANING for each area
  static Map<String, String> zoneSchedule = {
    'Monday': 'Kitchen',
    'Tuesday': 'Bathroom',
    'Wednesday': 'Bedroom',
    'Thursday': 'Living Room',
    'Friday': 'Laundry Room',
    'Saturday': 'Office',
    'Sunday': 'Reset',
  };

  // Zone DEEP CLEANING tasks - these are done on your zone day
  // NOTE: Daily essentials like dishes, counters, trash are done EVERY DAY
  // These are the deeper/less frequent tasks for each zone
  static Map<String, List<Map<String, String>>> zoneTasks = {
    'Kitchen': [
      {
        'task': 'Clear all clutter from center table',
        'howTo': 'Put away items, trash the garbage, create clear workspace - deep organization'
      },
      // REMOVED dishes - that's done DAILY now!
      // REMOVED countertops - that's done DAILY now!
      // REMOVED trash - that's done DAILY now!
      {
        'task': 'Deep clean stovetop',
        'howTo': 'Remove grates, deep clean with degreaser, clean knobs thoroughly'
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
        'task': 'Deep clean sink and faucet',
        'howTo': 'Deep scrub basin and drain, polish faucet, detail edges and caulk'
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
        'task': 'Deep clean trash can',
        'howTo': 'Wash can inside and out, scrub lid, sanitize'
      },
      {
        'task': 'Deep clean dog bowl area',
        'howTo': 'Scrub feeding mat, wash area floor, organize dog supplies'
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
      // REMOVED quick sink wipe - that's done DAILY now!
      // This is DEEP CLEAN day for bathroom
      {
        'task': 'Clear vanity countertop',
        'howTo': 'Put items away or in organizer basket'
      },
      {
        'task': 'Deep clean vanity and backsplash',
        'howTo': 'Move all items, scrub backsplash, clean under items, organize drawers'
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
        'task': 'Deep clean toilet',
        'howTo': 'Scrub bowl + under rim, wipe tank/lid/seat/base/floor - full detail clean'
      },
      {
        'task': 'Deep clean shower/tub',
        'howTo': 'Scrub walls, floor, ledges thoroughly - tackle soap scum and grime'
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
        'task': 'Deep sweep and mop floor',
        'howTo': 'Thorough sweep of all corners, behind toilet, then disinfectant mop'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'White baseboards show dog nose prints easily'
      },
    ],
    'Bedroom': [
      // Daily: make bed, pick up floor clutter
      // Zone day: DEEP CLEAN + boyfriend's mess
      {
        'task': 'Collect boyfriend\'s scattered items',
        'howTo': 'Pick up change, clothes, shoes, random items - organize in designated spot'
      },
      {
        'task': 'Pick up boyfriend\'s clothes',
        'howTo': 'Gather scattered clothes from floor, chair, bed - put away or in laundry'
      },
      {
        'task': 'Make bed fully',
        'howTo': 'Straighten sheets, pillows, blankets - remove any clutter from bed, lint-roll for dog hair'
      },
      {
        'task': 'Deep floor cleaning',
        'howTo': 'Clear all floor items, sweep thoroughly including under furniture and corners, spot mop'
      },
      {
        'task': 'Deep clean and organize dresser',
        'howTo': 'Clear all clutter, dust thoroughly, organize inside drawers, clean around TV'
      },
      {
        'task': 'Clean TV screen',
        'howTo': 'Dry microfiber only, gentle circular motion'
      },
      {
        'task': 'Clean side tables',
        'howTo': 'Wipe both side tables - top surfaces, legs, organize items on top'
      },
      {
        'task': 'Clean marble table top',
        'howTo': 'Deep clean entire marble table top - remove all items, wipe with appropriate marble cleaner, polish'
      },
      {
        'task': 'Clean marble table bottom shelf',
        'howTo': 'Wipe marble table bottom shelf - remove items, deep dust and clean, reorganize neatly'
      },
      {
        'task': 'Deep dust all surfaces',
        'howTo': 'Nightstand, floating shelf, bar cart, dresser top - move all items to clean under'
      },
      {
        'task': 'Full baseboards and door wipe',
        'howTo': 'Wipe all baseboards, both sides of doors, handles, dog-height smudges'
      },
      {
        'task': 'Dust wall art & frames',
        'howTo': 'Gently wipe all visible artwork'
      },
      {
        'task': 'Under bed deep clean',
        'howTo': 'Pull out items, vacuum/sweep under bed area, organize storage, get lost dog toys'
      },
      {
        'task': 'Remove dog hair from bedding',
        'howTo': 'Lint roll comforter, pillows, sheets - full retriever hair removal'
      },
      {
        'task': 'Laundry and linens refresh',
        'howTo': 'Strip bed, wash linens, handle boyfriend\'s laundry pile'
      },
    ],
    'Living Room': [
      // BIGGEST MESS ZONE! Daily: clear surfaces, quick sweep
      // Zone day: DEEP CLEAN retriever hair + boyfriend's stuff
      {
        'task': 'Collect boyfriend\'s scattered items',
        'howTo': 'Gather change, clothes, random items from all surfaces - put in designated spot'
      },
      {
        'task': 'Pick up ALL dog toys',
        'howTo': 'Gather scattered toys from floor, couch, under furniture - put in toy basket'
      },
      {
        'task': 'Straighten couch pillows',
        'howTo': 'Fluff pillows, fold throw blankets neatly, remove any hidden dog toys'
      },
      {
        'task': 'DEEP vacuum couch - retriever hair',
        'howTo': 'Remove ALL cushions, vacuum under/between, use pet hair attachment, get all crevices - this is KEY!'
      },
      {
        'task': 'Lint roll ALL furniture',
        'howTo': 'Couch, chairs, throw blankets - full retriever hair removal session'
      },
      {
        'task': 'Wash dog blankets/beds',
        'howTo': 'All dog bedding that lives in living room - hot wash cycle'
      },
      {
        'task': 'Deep clean all surfaces',
        'howTo': 'Island, entry table, side table - deep wipe and organize, not just surface clean'
      },
      {
        'task': 'Deep clean entertainment area',
        'howTo': 'TV screen + stand, organize cords, dust all devices, wipe around equipment'
      },
      {
        'task': 'Clean large mirror',
        'howTo': 'Full edge-to-edge wipe, no streaks, get dog nose prints at bottom'
      },
      {
        'task': 'Clean windows - nose prints',
        'howTo': 'Remove dog nose prints from all windows and glass doors'
      },
      {
        'task': 'Dust wall art & frames',
        'howTo': 'All mounted décor gently'
      },
      {
        'task': 'Wipe door & glass panel',
        'howTo': 'Front door, glass insert, black door surface - focus on dog-height smudges'
      },
      {
        'task': 'Deep clean baseboards and trim',
        'howTo': 'Wipe all baseboards along couch, mirror, corners - GET ALL dog nose prints and drool'
      },
      {
        'task': 'Wipe light switches',
        'howTo': 'Entry switches and outlets'
      },
      {
        'task': 'Vacuum under ALL furniture',
        'howTo': 'Move couch if possible, get hidden dog toys and hair tumbleweeds'
      },
      {
        'task': 'Deep sweep and mop floors',
        'howTo': 'THOROUGH sweep for retriever hair - corners, under furniture, everywhere! Then full mop - dark tile shows everything'
      },
    ],
    'Laundry Room': [
      // Daily: one load of laundry
      // Zone day: DEEP CLEAN the room itself
      {
        'task': 'Pick up ALL floor clutter',
        'howTo': 'This is priority #1 - clear the walking path completely'
      },
      {
        'task': 'Washer and dryer deep clean',
        'howTo': 'Clean inside drum, run cleaning cycle, wipe rubber seals, clean lint trap thoroughly'
      },
      {
        'task': 'Clean detergent area',
        'howTo': 'Deep clean spills, sanitize dispensers and bottles'
      },
      {
        'task': 'Wipe window sill & blinds',
        'howTo': 'Dust sill, wipe blinds if dusty'
      },
      {
        'task': 'Organize and deep clean storage',
        'howTo': 'Wooden shelf - remove all items, deep dust and wipe, reorganize neatly'
      },
      {
        'task': 'Wipe chest freezer top & sides',
        'howTo': 'Full exterior wipe down'
      },
      {
        'task': 'Catch up on ALL laundry',
        'howTo': 'Do multiple loads if needed - get completely caught up on wash/dry/fold/put away'
      },
      {
        'task': 'Check supplies stock',
        'howTo': 'Detergent, dryer sheets, stain spray - restock if needed'
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
        'task': 'Deep sweep and mop',
        'howTo': 'Thorough sweep of narrow space - both walls, all corners, then full mop'
      },
    ],
    'Office': [
      // Zone day: DEEP CLEAN
      {
        'task': 'Pick up all floor clutter',
        'howTo': 'Clear the walking path - deep organization, not just surface pick-up'
      },
      {
        'task': 'Deep organize desk',
        'howTo': 'Clear all surfaces, sort papers, organize drawers, wipe all levels thoroughly'
      },
      {
        'task': 'Clean all electronics',
        'howTo': 'Monitors, keyboard, mouse, equipment - deep clean with proper electronics wipes'
      },
      {
        'task': 'Cable management',
        'howTo': 'Bundle all cords properly, secure loose wires, organize charging stations'
      },
      {
        'task': 'Deep clean all furniture',
        'howTo': 'Vacuum office chair (crevices, wheels), vacuum/spot clean armchair'
      },
      {
        'task': 'Windows and mirrors',
        'howTo': 'Large mirror behind desk, window, dust curtain rod - streak-free clean'
      },
      {
        'task': 'Empty trash and declutter',
        'howTo': 'Remove all trash, paper shred if needed, clear unnecessary items'
      },
      {
        'task': 'Wipe baseboards',
        'howTo': 'Around entire room perimeter'
      },
      {
        'task': 'Deep floor clean',
        'howTo': 'Thorough sweep/vacuum under desk, around chair, all corners, then full floor clean'
      },
    ],
    'Reset': [
      // Sunday is for catching up, planning, and preparing for the week
      // Remember: Daily essentials are ALREADY being done every day!
      {
        'task': 'Quick tidy all rooms',
        'howTo': 'Walk through each room - quick surface tidy, put away items'
      },
      {
        'task': 'Catch up any missed zone tasks',
        'howTo': 'Review the week - did you skip any zone days? Catch up now'
      },
      {
        'task': 'Laundry marathon if needed',
        'howTo': 'If behind on laundry, do multiple loads today to catch up fully'
      },
      {
        'task': 'Bathroom restock',
        'howTo': 'Swap towels for fresh ones, refill TP, restock toiletries'
      },
      {
        'task': 'Fridge deep clean',
        'howTo': 'Toss old leftovers and expired items, wipe shelves, organize'
      },
      {
        'task': 'Take out ALL trash',
        'howTo': 'Every room - empty all bins for fresh start Monday'
      },
      {
        'task': 'Meal prep and plan',
        'howTo': 'Review upcoming week schedule, plan meals, prep what you can'
      },
      {
        'task': 'Pet supply restock',
        'howTo': 'Check dog food, treats, pee pads, prep bowls and stations for week'
      },
      {
        'task': 'Review planner',
        'howTo': 'Check upcoming appointments, tasks, and priorities for the week'
      },
      {
        'task': 'Self-care check',
        'howTo': 'How are you feeling? What do you need this week? Plan accordingly'
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
