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
      // ── TOP TO BOTTOM: clear → high → counters → low → floor ──
      // 1. Clear clutter first so every surface is accessible
      {
        'task': 'Clear all clutter from center table & counters',
        'howTo': 'Put away items, trash garbage, clear the center table and any counter clutter — you need clear surfaces before you can actually clean them'
      },
      // 2. High appliances first — crumbs & spray fall DOWN onto counters
      {
        'task': 'Clean microwave inside/out',
        'howTo': 'Microwave is above counter level — clean inside first (crumbs fall), then wipe top, buttons and door. Debris falls to counter below.'
      },
      {
        'task': 'Wipe fridge exterior',
        'howTo': 'Start at the top and work down — top of fridge, sides, then handles and dog nose-height areas. Dust falls downward.'
      },
      // 3. Countertop appliances — toaster crumbs land on counter & backsplash area
      {
        'task': 'Clean small appliances',
        'howTo': 'Toaster: pull out tray, shake crumbs onto counter, wipe exterior. Coffee maker: wipe exterior and underneath. Do this BEFORE wiping backsplash so crumbs get caught in the backsplash wipe.'
      },
      // 4. Backsplash before stovetop — spray drips DOWN onto the stovetop surface
      {
        'task': 'Wipe backsplash tiles',
        'howTo': 'Spray and wipe backsplash BEFORE stovetop — any drips land on the stovetop which you\'re cleaning next anyway. Behind sink and stove areas.'
      },
      // 5. Stovetop after backsplash — catches any drips from above
      {
        'task': 'Deep clean stovetop',
        'howTo': 'Remove grates and burner caps, soak if needed, scrub with degreaser, clean knobs. Any backsplash drips from step above are already here.'
      },
      // 6. Sink last of the counter-level items — rinse everything down it
      {
        'task': 'Deep clean sink and faucet',
        'howTo': 'Do sink AFTER stovetop so you can rinse your cleaning cloths and degreaser here. Deep scrub basin and drain, polish faucet and handles, detail caulk edges.'
      },
      // 7. Cabinet fronts & light switches — vertical surfaces, mid-height
      {
        'task': 'Wipe cabinets & drawer fronts',
        'howTo': 'All cabinet doors and drawer fronts — handles, lower edges where dogs put their paws. Work top row down to bottom.'
      },
      {
        'task': 'Wipe light switches & outlet covers',
        'howTo': 'Entry switch and any near the sink — quick wipe with damp cloth'
      },
      // 8. Trash can & dog bowl — messy jobs that splash/drip, do before floor
      {
        'task': 'Deep clean trash can',
        'howTo': 'Take outside or to sink — wash inside and out, scrub lid, sanitize. Let drain. Any drips go to floor which gets mopped last.'
      },
      {
        'task': 'Deep clean dog bowl area',
        'howTo': 'Scrub feeding mat, wash bowls, wipe surrounding area. Any splashing here gets swept up with the floor sweep next.'
      },
      // 9. FLOOR LAST — every crumb, drip and bit of debris from above has settled here
      {
        'task': 'Sweep entire floor',
        'howTo': 'Now every crumb from the microwave, toaster, stovetop and dog bowls has fallen. Sweep corners, under table, under appliances — get it all.'
      },
      {
        'task': 'Mop floor',
        'howTo': 'VERY LAST — mop after sweeping. Watch for dark grout lines. Floor is now genuinely clean because everything dirty was done before this.'
      },
    ],
    'Bathroom': [
      // TOP TO BOTTOM — surfaces first, floor always last
      // Step 1: Clear clutter so you can actually clean
      {
        'task': 'Pick up all floor items & clear surfaces',
        'howTo': 'Clothes to hamper, trash to bin, clear vanity countertop — get everything off the floor and surfaces before you start'
      },
      // Step 2: Mirror first — glass cleaner drips onto vanity below
      {
        'task': 'Clean mirror edge to edge',
        'howTo': 'Glass cleaner or microfiber, no streaks — do this before vanity so drips get wiped up next'
      },
      // Step 3: Vanity/sink — backsplash drips fall to counter
      {
        'task': 'Deep clean vanity and backsplash',
        'howTo': 'Scrub backsplash first (drips fall down), then clean under items, organize drawers'
      },
      {
        'task': 'Clean sink & faucet',
        'howTo': 'Scrub basin, polish faucet and handles — water drips fall to floor last'
      },
      // Step 4: Shower/tub — water and soap scum splashes during scrubbing
      {
        'task': 'Deep clean shower/tub',
        'howTo': 'Scrub walls top to bottom, then floor, ledges — tackle soap scum and grime. Splashes will land on floor.'
      },
      {
        'task': 'Wipe shower ledge & bottles',
        'howTo': 'Clean ledge, wipe bottle bottoms — any drips land on floor below'
      },
      // Step 5: Toilet — messy job, do before floor
      {
        'task': 'Deep clean toilet',
        'howTo': 'Scrub bowl + under rim first, then wipe tank/lid/seat/base — any drips/splashes go on floor below'
      },
      // Step 6: Cabinet fronts & trash
      {
        'task': 'Wipe cabinet fronts',
        'howTo': 'Vanity and linen closet doors, black handles'
      },
      {
        'task': 'Empty trash can',
        'howTo': 'Replace liner if needed'
      },
      // Step 7: Puppy pad — replace before mopping so you only mop once
      {
        'task': 'Check puppy pad area',
        'howTo': 'Replace pad if needed, wipe mat underneath — do this before mopping'
      },
      // Step 8: Baseboards — low level, above the floor
      {
        'task': 'Wipe baseboards',
        'howTo': 'White baseboards show dog nose prints easily — wipe before mopping so drips get mopped up'
      },
      // Step 9: FLOOR LAST — all drips, hair, debris has settled
      {
        'task': 'Deep sweep and mop floor',
        'howTo': 'LAST TASK — thorough sweep of all corners, behind toilet, then disinfectant mop. Everything from cleaning above has settled here.'
      },
    ],
    'Bedroom': [
      // TOP TO BOTTOM ORDER — surfaces first, floor always last
      // Step 1: Strip & laundry first so linens are washing while you clean
      {
        'task': 'Strip bed & start laundry',
        'howTo': 'Strip all sheets, pillowcases, blankets - put straight in washer so they\'re running while you clean'
      },
      // Step 2: Pick up clutter so you have clear surfaces and floor to work with
      {
        'task': 'Collect boyfriend\'s scattered items',
        'howTo': 'Pick up change, clothes, shoes, random items - organize in designated spot'
      },
      {
        'task': 'Pick up ALL clothes from floor & surfaces',
        'howTo': 'Gather scattered clothes from floor, chair, bed - put away or in laundry pile'
      },
      // Step 3: High surfaces first — dust falls DOWN
      {
        'task': 'Dust wall art & frames',
        'howTo': 'Start at the top — gently wipe all visible artwork, dust falls down to surfaces below'
      },
      {
        'task': 'Deep dust all surfaces',
        'howTo': 'Nightstand, floating shelf, bar cart, dresser top - move all items to clean under. Dust from top shelves down.'
      },
      // Step 4: Furniture surfaces
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
        'howTo': 'Remove all items, wipe with appropriate marble cleaner, polish'
      },
      {
        'task': 'Clean marble table bottom shelf',
        'howTo': 'Remove items, deep dust and clean, reorganize neatly'
      },
      // Step 5: Bed (after dusting so no new dust lands on it)
      {
        'task': 'Make bed fully',
        'howTo': 'Put on fresh clean sheets from the washer/dryer, straighten pillows and blankets, lint-roll for dog hair'
      },
      {
        'task': 'Remove dog hair from bedding',
        'howTo': 'Lint roll comforter, pillows, throw blankets — full retriever hair removal'
      },
      // Step 6: Low surfaces — baseboards, doors
      {
        'task': 'Full baseboards and door wipe',
        'howTo': 'Wipe all baseboards, both sides of doors, handles, dog-height smudges'
      },
      // Step 7: Under bed before sweeping so debris gets swept up
      {
        'task': 'Under bed deep clean',
        'howTo': 'Pull out all items, vacuum/sweep under bed area thoroughly, organize storage, get lost dog toys'
      },
      // Step 8: FLOOR LAST — all dust and debris has settled by now
      {
        'task': 'Sweep & spot mop floor',
        'howTo': 'LAST TASK — sweep entire floor including corners and under furniture, then spot mop. All the dust from above has settled by now.'
      },
    ],
    'Living Room': [
      // ── TOP TO BOTTOM: laundry first → clutter → high → mid → low → floor ──
      // 1. Start laundry FIRST so dog beds are washing the whole time you clean
      {
        'task': 'Start dog blanket & bed laundry',
        'howTo': 'Gather all dog blankets, beds and throws from the living room and put them in the wash NOW — they\'ll be done by the time you finish cleaning. Hot wash cycle.'
      },
      // 2. Clear all clutter so surfaces and floor are accessible
      {
        'task': 'Collect boyfriend\'s scattered items',
        'howTo': 'Gather change, clothes, random items from all surfaces and floor — put in his designated spot'
      },
      {
        'task': 'Pick up ALL dog toys',
        'howTo': 'Gather every toy from floor, couch, under furniture — put in toy basket. Floor needs to be clear for vacuuming later.'
      },
      // 3. HIGH surfaces — dust & spray fall DOWN. Wall art first, then shelves.
      {
        'task': 'Dust wall art & frames',
        'howTo': 'Start at the very top — dust falls onto surfaces below. Gently wipe all mounted décor and frames.'
      },
      // 4. Windows & mirror — spray can drip down onto surfaces/baseboards below
      {
        'task': 'Clean large mirror',
        'howTo': 'Top to bottom — spray falls down. Full edge-to-edge wipe, no streaks, get dog nose prints at the bottom last.'
      },
      {
        'task': 'Clean windows & glass door — nose prints',
        'howTo': 'Top to bottom — spray drips downward. Remove dog nose prints from all windows and glass panels.'
      },
      // 5. Mid-height surfaces — after dusting so no fresh dust lands on freshly wiped surfaces
      {
        'task': 'Deep clean all surfaces',
        'howTo': 'Island, entry table, side tables — deep wipe and organize. Do AFTER dusting above so no dust rains down on your clean surfaces.'
      },
      {
        'task': 'Deep clean entertainment area',
        'howTo': 'TV screen (dry microfiber only), dust TV stand top to bottom, organize cords, wipe all devices. Dust from electronics falls onto stand below.'
      },
      {
        'task': 'Wipe door & glass panel',
        'howTo': 'Front door top to bottom, glass insert, black door surface — focus on dog-height smudges last'
      },
      {
        'task': 'Wipe light switches & outlet covers',
        'howTo': 'Entry switches and any outlet covers — quick wipe'
      },
      // 6. Couch — vacuum FIRST to remove bulk hair, then lint roll for the rest
      {
        'task': 'DEEP vacuum couch — retriever hair',
        'howTo': 'Remove ALL cushions, vacuum under and between every crevice with pet hair attachment. Do this BEFORE lint rolling — vacuuming removes bulk hair, lint rolling gets what\'s left.'
      },
      {
        'task': 'Lint roll ALL furniture & throws',
        'howTo': 'AFTER vacuuming — lint roll couch, chairs and any throw blankets still in the room. Gets the fine hair the vacuum missed.'
      },
      {
        'task': 'Straighten couch cushions & pillows',
        'howTo': 'Now the couch is clean — fluff pillows, fold blankets neatly, arrange cushions. Do this AFTER cleaning so you\'re not re-dirtying it.'
      },
      // 7. Baseboards — low level, above floor. Any wipe drips go on floor which is mopped last.
      {
        'task': 'Deep clean baseboards and trim',
        'howTo': 'Wipe all baseboards — along couch wall, mirror wall, all corners. Get ALL dog nose prints and drool. Any drips fall to floor which gets mopped next.'
      },
      // 8. Move furniture & vacuum under — debris goes on floor, swept up last
      {
        'task': 'Vacuum under ALL furniture',
        'howTo': 'Move couch and chairs if possible — hair tumbleweeds, hidden dog toys, debris. This all gets swept/mopped in the final step.'
      },
      // 9. FLOOR LAST — everything has fallen here
      {
        'task': 'Deep sweep and mop floors',
        'howTo': 'LAST TASK — every hair, crumb and dust from above has settled. Thorough sweep first (corners, under furniture), then full mop. Dark tile shows everything so take your time.'
      },
    ],
    'Laundry Room': [
      // ── SMART ORDER: laundry running → high → mid → low → floor ──
      // 1. Start a laundry load FIRST so machines are running while you clean around them
      {
        'task': 'Start catch-up laundry loads',
        'howTo': 'Throw in your first load NOW before you do anything else — machines will be running the whole time you clean the room. Do multiple loads throughout the session to get fully caught up.'
      },
      // 2. Clear floor clutter so you can actually move around
      {
        'task': 'Pick up ALL floor clutter',
        'howTo': 'Clear the walking path completely — stray socks, bottles, bags, anything on the floor. You need to move freely to clean everything.'
      },
      // 3. High/wall-mounted items — dust falls DOWN
      {
        'task': 'Wipe window sill & blinds',
        'howTo': 'Start high — dust the blinds top to bottom, wipe window sill. Dust falls onto the shelf and machines below which you\'re cleaning next.'
      },
      // 4. Storage shelf — above the machines, dust falls onto them
      {
        'task': 'Organize and deep clean storage shelf',
        'howTo': 'Remove ALL items, deep dust and wipe the shelf top to bottom. Reorganize neatly. Dust from shelf falls onto washer/dryer below — which you clean next.'
      },
      // 5. Washer & dryer — after shelf dust has fallen onto them
      {
        'task': 'Washer and dryer deep clean',
        'howTo': 'Wipe tops first (shelf dust has settled here), then wipe fronts, knobs and sides. Clean inside drum, wipe rubber door seals, clean lint trap thoroughly. Run a cleaning cycle if needed.'
      },
      {
        'task': 'Clean detergent area',
        'howTo': 'Deep clean any detergent spills on or around the machines, sanitize dispensers and bottles, wipe the surrounding surface.'
      },
      // 6. Chest freezer — mid-height, after machines
      {
        'task': 'Wipe chest freezer top & sides',
        'howTo': 'Wipe top first (things get set on it), then sides. Full exterior wipe down.'
      },
      // 7. Door & frame — vertical surface, before baseboards
      {
        'task': 'Wipe door & frame',
        'howTo': 'Both sides of door if accessible, wipe frame and clean handle — often touched with laundry-product hands'
      },
      // 8. Baseboards — low level, just above floor
      {
        'task': 'Wipe baseboards',
        'howTo': 'White baseboards along both walls — any wipe-drips fall to floor which gets mopped last'
      },
      // 9. Supplies check BEFORE sweeping — so you can add items to shopping list
      {
        'task': 'Check supplies stock',
        'howTo': 'Check detergent, dryer sheets, stain spray, dryer balls — note anything low so you can add it to the shopping list before you forget'
      },
      // 10. FLOOR LAST
      {
        'task': 'Deep sweep and mop',
        'howTo': 'LAST TASK — all the dust from the blinds, shelf and machines has settled. Thorough sweep of the narrow space, both walls, all corners, then full mop.'
      },
    ],
    'Office': [
      // ── TOP TO BOTTOM: clutter → high → mid-surfaces → electronics → low → floor ──
      // 1. Clear clutter first — floor and desk need to be accessible
      {
        'task': 'Pick up all floor clutter & clear desk surface',
        'howTo': 'Clear the walking path and clear the desk surface — deep organization, not just surface pick-up. You can\'t clean around stuff.'
      },
      // 2. Empty trash EARLY — you\'ll be generating more trash as you declutter/shred
      {
        'task': 'Empty trash and shred papers',
        'howTo': 'Empty trash bin NOW so you have a fresh empty bin for all the paper, wrappers and junk you\'ll throw away while organizing. Shred sensitive papers.'
      },
      // 3. HIGH — mirror and window first, spray drips fall DOWN onto desk
      {
        'task': 'Windows and large mirror',
        'howTo': 'Start HIGH — dust curtain rod first (dust falls on window sill), then clean window top to bottom, then large mirror behind desk. Spray drips fall down onto desk which you wipe next.'
      },
      // 4. Desk — after mirror spray drips have landed
      {
        'task': 'Deep organize and wipe desk',
        'howTo': 'Now wipe all desk surfaces — any mirror/window spray drips are already here. Clear all levels, sort papers, organize drawers, wipe all shelf levels top to bottom.'
      },
      // 5. Electronics — keyboard crumbs fall onto the desk you just wiped, so do a final wipe after
      {
        'task': 'Clean all electronics',
        'howTo': 'Monitors (dry microfiber), keyboard (shake out crumbs, then compressed air, then wipe), mouse, equipment. Use proper electronics wipes. Crumbs fall to desk — give desk a quick final wipe after.'
      },
      // 6. Cable management — after desk and electronics are clean
      {
        'task': 'Cable management',
        'howTo': 'Bundle all cords properly, secure loose wires, organize charging stations. Much easier when desk is already clear.'
      },
      // 7. Furniture — chair and armchair produce debris (hair, crumbs) that falls to floor
      {
        'task': 'Deep clean all furniture',
        'howTo': 'Vacuum office chair thoroughly — crevices, arm rests, between seat and back, wheels. Vacuum/spot clean armchair. Hair and debris fall to floor — swept up last.'
      },
      // 8. Baseboards — low, above floor level
      {
        'task': 'Wipe baseboards',
        'howTo': 'Around entire room perimeter — any drips land on floor which gets cleaned last'
      },
      // 9. FLOOR LAST — all dust, crumbs, chair debris has settled
      {
        'task': 'Deep floor clean',
        'howTo': 'LAST TASK — all keyboard crumbs, chair debris and dust from above has settled. Thorough sweep/vacuum under desk, around chair wheels, all corners, then full floor clean.'
      },
    ],
    'Reset': [
      // ── SUNDAY RESET: logical flow so each task supports the next ──
      // 1. Start laundry FIRST — it runs in the background the whole time
      {
        'task': 'Start laundry marathon',
        'howTo': 'Throw in load #1 immediately — laundry runs in the background while you do everything else. Keep rotating loads throughout the day to get fully caught up.'
      },
      // 2. Take out ALL trash BEFORE fridge clean — you need empty bins for tossing food
      {
        'task': 'Take out ALL trash',
        'howTo': 'Empty every bin in every room BEFORE the fridge clean — you need fresh empty bins so you have somewhere to throw expired food and leftovers. Fresh start for Monday.'
      },
      // 3. Fridge clean — now you have empty trash bins to toss things into
      {
        'task': 'Fridge deep clean',
        'howTo': 'Toss old leftovers and expired items into the empty trash bags you just changed. Wipe shelves, door shelves, organize. Much easier with an empty bin right there.'
      },
      // 4. Quick tidy all rooms — resets the visual before planning the week
      {
        'task': 'Quick tidy all rooms',
        'howTo': 'Walk through every room — quick surface tidy, put items back where they belong, fluff pillows. Sets a calm baseline before your planning.'
      },
      // 5. Catch up any missed zones — while you have the cleaning mindset
      {
        'task': 'Catch up any missed zone tasks',
        'howTo': 'Did you skip any zone days this week? Now\'s the time to do a quick version of what was missed. Check the app — it shows which zones weren\'t completed.'
      },
      // 6. Bathroom restock — after tidy, fresh towels ready for the week
      {
        'task': 'Bathroom restock',
        'howTo': 'Swap towels for fresh ones (laundry is already running!), refill TP, restock toiletries, check soap levels. Ready for Monday.'
      },
      // 7. Pet supplies — prep for the week
      {
        'task': 'Pet supply restock',
        'howTo': 'Check dog food level, treats, pee pads — restock anything low. Prep bowls and feeding station for the week ahead.'
      },
      // 8. Meal prep — fridge is already cleaned so you can see what you have
      {
        'task': 'Meal prep and plan',
        'howTo': 'Fridge is clean so you can see exactly what you have. Plan meals for the week, do any prep you can (chop veggies, marinate, boil eggs).'
      },
      // 9. Review planner — near end so you have full picture of what\'s done
      {
        'task': 'Review planner & to-do list',
        'howTo': 'Check upcoming appointments, deadlines, tasks. Write down priorities for Monday. Review shopping list in the app and add anything low.'
      },
      // 10. Self-care last — reward yourself after a productive reset day
      {
        'task': 'Self-care check',
        'howTo': 'You reset the whole house today — how are you feeling? Plan your self-care for the week. Bath, face mask, early bedtime, whatever you need.'
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
