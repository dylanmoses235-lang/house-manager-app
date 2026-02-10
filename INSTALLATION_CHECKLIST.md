# ✅ iPhone Installation Checklist

Follow these steps in order. Check off each one as you complete it!

---

## 📋 Pre-Installation Checklist

- [ ] **Xcode installed** from App Store (takes 30-45 minutes)
- [ ] **Flutter installed** and in PATH (`flutter --version` works)
- [ ] **iPhone connected** via USB cable
- [ ] **iPhone unlocked** and showing home screen
- [ ] **Trusted computer** on iPhone (popup when first connected)

---

## 🔧 Build Steps

Copy these commands into Terminal **one at a time**:

### Step 1: Navigate to project
```bash
cd ~/Documents/house-manager-app
```
- [ ] Completed (should show project path)

### Step 2: Get latest code
```bash
git pull origin main
```
- [ ] Completed (should say "Already up to date" or show updates)

### Step 3: Clean everything
```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
```
- [ ] Completed (deletes old build files)

### Step 4: Get Flutter packages
```bash
flutter pub get
```
- [ ] Completed (should say "Got dependencies!")

### Step 5: Install iOS packages
```bash
cd ios
pod install
cd ..
```
- [ ] Completed (should show pods being installed)

### Step 6: Check iPhone is detected
```bash
flutter devices
```
- [ ] Completed - iPhone shows in list
- If not, check USB connection, unlock iPhone, trust computer

### Step 7: Build and install
```bash
flutter run --release
```
- [ ] Started (will take 5-10 minutes)
- [ ] Xcode build completed
- [ ] Installing on iPhone...
- [ ] Success! App launched

---

## 📱 iPhone Setup (After Install)

Do these on your iPhone:

- [ ] Settings → General → VPN & Device Management
- [ ] Tap your Apple ID under "Developer App"  
- [ ] Tap "Trust" → Confirm "Trust"
- [ ] Open House Manager app from home screen
- [ ] Allow notifications (when prompted)
- [ ] Allow photos (when prompted)
- [ ] App is working!

---

## 🎯 Verify Installation

Open the app and check:

- [ ] **Daily Tasks** tab loads
- [ ] Shows 13 daily tasks (dishes, counters, dog bowls, etc.)
- [ ] **Deep Clean** tab loads  
- [ ] Shows today's zone tasks
- [ ] **Stats** tab loads
- [ ] Can toggle task completion ✓

---

## 🚨 Troubleshooting

### If "flutter devices" doesn't show iPhone:

- [ ] iPhone is unlocked
- [ ] Trusted this computer (check iPhone for popup)
- [ ] Try different USB cable
- [ ] Try different USB port
- [ ] Restart iPhone and Mac

### If build fails with certificate errors:

On your Mac in Terminal:
```bash
open ios/Runner.xcworkspace
```

In Xcode:
- [ ] Click "Runner" in left sidebar
- [ ] Select "Runner" under TARGETS
- [ ] Click "Signing & Capabilities" tab
- [ ] ✅ Enable "Automatically manage signing"
- [ ] Select your Apple ID under "Team"
- [ ] Change Bundle ID to: `com.yourname.housemanager`

Then try `flutter run --release` again

### If "pod install" fails:

```bash
cd ~/Documents/house-manager-app/ios
pod deintegrate
rm -rf Pods Podfile.lock
pod install
cd ..
```

### If everything fails:

Complete nuclear clean:
```bash
cd ~/Documents/house-manager-app
flutter clean
rm -rf build ios/Pods ios/Podfile.lock ios/.symlinks
flutter pub get
cd ios
pod deintegrate
pod install  
cd ..
flutter run --release
```

---

## ✅ Success!

If you see this in Terminal:
```
✓ Built build/ios/iphoneos/Runner.app
Installing and launching...
```

And the app opens on your iPhone - **YOU'RE DONE!** 🎉

---

## 📝 Notes

**First build**: 10-15 minutes (downloads packages, compiles code)  
**Future builds**: 2-5 minutes (only rebuilds changes)

The app is now installed on your iPhone and will stay there even after disconnecting!

To update later:
```bash
cd ~/Documents/house-manager-app
git pull origin main
flutter run --release
```

---

## 📚 Full Guides

For detailed explanations:
- **INSTALL_ON_IPHONE_FIXED.md** - Complete guide with screenshots
- **QUICK_INSTALL_COMMANDS.md** - Just the commands

---

## 🎉 What's Next?

Once installed:
1. Complete your first daily tasks
2. Check out today's zone deep-clean  
3. Take a before photo in the Stats tab
4. Track your progress over the week!

The new daily essentials system means:
- ✅ Dishes done every day (no more pileup!)
- ✅ Trash emptied as needed
- ✅ One load of laundry daily  
- ✅ Bathroom stays fresh
- ✅ Each zone gets deep-cleaned weekly

Happy cleaning! 🏠✨
