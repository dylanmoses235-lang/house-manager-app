# 🔧 Custom Zones - Troubleshooting Guide

## Issue: Can't Add Tasks to Custom Zones

I've just pushed an improved version with better debugging and features. Here's how to fix the issue:

---

## 🚀 Step 1: Update Your App

On your Mac terminal:

```bash
cd ~/house-manager-app
git pull origin main
flutter clean
flutter pub get
flutter run
```

---

## ✨ New Features in This Update

### 1. **Better Task Dialog**
- ✅ Auto-focuses on task name field
- ✅ Better validation (shows error if field is empty)
- ✅ Trim whitespace from inputs
- ✅ Better error messages

### 2. **Edit/Delete Tasks** 
- ✅ Edit button (✏️) appears for custom zone tasks
- ✅ Click edit to modify or delete tasks
- ✅ Only shows for custom zones (not default zones)

### 3. **Debug Logging**
- ✅ Console logs show when tasks are saved/loaded
- ✅ Helps identify if data is persisting

### 4. **Better Visual Feedback**
- ✅ Helper text when zone has no tasks
- ✅ Success messages when tasks are added
- ✅ Loading indicators during operations

---

## 🧪 How to Test (Step by Step)

### Test 1: Check if Button Works

1. **Open the app**
2. **Go to Zone Cleaning screen**
3. **Select your custom zone** from the dropdown (tap filter icon)
4. **Look for the ➕ button** in the top-right (next to filter)
5. **Tap the ➕ button**
6. **Does a dialog appear?**
   - ✅ **YES** → Dialog works, go to Test 2
   - ❌ **NO** → See "Dialog Not Appearing" below

### Test 2: Check if Tasks Save

1. **In the dialog, type a task name** (e.g., "Clean garage floor")
2. **Optionally add instructions** (e.g., "Sweep and mop")
3. **Tap "Add" button**
4. **Look for:**
   - Green success message at bottom
   - Task appears in the list
   - Loading indicator briefly shows
5. **Did the task appear?**
   - ✅ **YES** → It's working! 🎉
   - ❌ **NO** → See "Tasks Not Saving" below

### Test 3: Check if Tasks Persist

1. **Add a task** (follow Test 2)
2. **Close the app completely** (swipe up in app switcher)
3. **Reopen the app**
4. **Go back to Zone Cleaning**
5. **Select your custom zone**
6. **Is the task still there?**
   - ✅ **YES** → Perfect! Everything works! 🎊
   - ❌ **NO** → See "Tasks Disappear After Restart" below

---

## 🐛 Troubleshooting Issues

### Issue: Dialog Not Appearing

**Possible Causes:**
- App didn't update properly
- UI rendering issue

**Solutions:**
```bash
# 1. Make sure you have latest code
cd ~/house-manager-app
git pull origin main

# 2. Completely clean and rebuild
flutter clean
rm -rf ios/Pods ios/.symlinks
cd ios && pod install && cd ..
flutter pub get

# 3. Delete app from device, then reinstall
flutter run
```

### Issue: Tasks Not Saving

**Check Debug Logs:**

When you run the app from terminal with `flutter run`, you should see logs like:
```
Saved tasks for Garage: [{"task":"Clean floor","howTo":"Sweep and mop"}]
```

**If you DON'T see these logs:**
- The save function isn't being called
- Try restarting the app

**If you DO see these logs:**
- Tasks are being saved
- Issue might be with loading them back

**Solutions:**
```bash
# 1. Check if you're looking at the right zone
# Make sure the zone name matches exactly (case-sensitive)

# 2. Try adding debug output
# Look for these lines in terminal:
# "Add Task button clicked for zone: YourZoneName"
# "Loading tasks for YourZoneName: ..."
# "Saved tasks for YourZoneName: ..."

# 3. If logs show tasks saving but not loading:
# Uninstall app completely and reinstall
flutter clean
flutter run
```

### Issue: Tasks Disappear After Restart

**This means:**
- Tasks are being added to memory
- But not persisting to SharedPreferences

**Solutions:**

```bash
# 1. Check device storage permissions
# iOS: Settings > Privacy > Files and Folders > Your App

# 2. Try on a different device or simulator
open -a Simulator
flutter run -d iphone

# 3. Clear app data and try again
# Delete app from device
# Reinstall with flutter run
```

### Issue: Empty Task Names

**Problem:** 
- Accidentally submitting empty tasks

**Solution:**
- Latest update validates this
- Shows error: "Please enter a task name"
- Make sure you type something before clicking "Add"

---

## 📱 How to View Debug Logs

### While Running from Terminal

```bash
flutter run
# Logs appear automatically in terminal
# Look for lines starting with:
# "Add Task button clicked..."
# "Loading tasks for..."
# "Saved tasks for..."
```

### In Xcode Console

1. Open Xcode
2. Open `ios/Runner.xcworkspace`
3. Click Run (▶️)
4. Open **Debug Console** (View > Debug Area > Activate Console)
5. Tap the ➕ button in your app
6. Watch for logs in console

---

## 🎯 Expected Behavior After Fix

### When You Add a Custom Zone:

1. **Manage Zones screen:**
   - Add zone (e.g., "Garage") ✅
   - Assign to a day (e.g., Monday) ✅

2. **Zone Cleaning screen:**
   - Garage appears in dropdown ✅
   - Select Garage ✅
   - Shows "No tasks for this zone" ✅
   - Shows hint: "Tap the ➕ button above to add tasks" ✅

3. **Adding Tasks:**
   - Tap ➕ in app bar ✅
   - Dialog opens with title "Add Task to Garage" ✅
   - Cursor auto-focuses on task name ✅
   - Type task name and instructions ✅
   - Tap "Add" ✅
   - See success message: "Task added to Garage!" ✅
   - Task immediately appears in list ✅

4. **Editing Tasks (Custom Zones Only):**
   - See ✏️ edit button on each task ✅
   - Tap to edit or delete ✅
   - Changes save immediately ✅

5. **After App Restart:**
   - All custom zones still there ✅
   - All tasks still there ✅
   - Task completion status preserved ✅

---

## 📞 Still Having Issues?

If none of the above works, try this **nuclear option**:

```bash
# Complete reset
cd ~/house-manager-app

# Delete all build artifacts
flutter clean
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf build/
rm ios/Podfile.lock

# Reinstall everything
cd ios && pod install && cd ..
flutter pub get

# Delete app from device completely
# Then reinstall
flutter run
```

---

## 🎉 Success Checklist

After the fix, you should be able to:

- ✅ See custom zones in dropdown
- ✅ Tap ➕ button to add tasks
- ✅ Fill in task name and instructions
- ✅ See tasks appear immediately
- ✅ Tasks persist after app restart
- ✅ Edit tasks with ✏️ button (custom zones)
- ✅ Delete tasks from edit dialog
- ✅ See custom zones in dashboard/calendar

---

## 📝 What Changed in This Update

### Before:
- ❌ Dialog might not have validated input
- ❌ No visual feedback during save
- ❌ No way to edit/delete tasks
- ❌ No debug logging

### After:
- ✅ Input validation with error messages
- ✅ Success messages and loading states
- ✅ Edit/delete functionality for custom zones
- ✅ Debug logs to track operations
- ✅ Auto-focus and better UX
- ✅ Helper text for empty zones

---

**Last Updated:** Just now with debugging improvements

**Questions?** Check the logs when you tap the ➕ button!
