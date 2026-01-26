# 📱 Build House Manager App for Your iPhone

This guide will help you build and install the House Manager app on your iPhone from your Mac.

---

## ✅ Prerequisites

Before you begin, make sure you have:

1. **Mac** with macOS (latest version recommended)
2. **iPhone** with charging cable
3. **Apple ID** (the one you use for iCloud)
4. **Xcode** installed (free from App Store)
5. **Flutter SDK** installed

---

## 📋 Step 1: Install Required Software

### Install Xcode
```bash
# Open App Store and search for "Xcode"
# Or use this command:
open -a "App Store"

# After installation, open Xcode once to complete setup
# Then install command line tools:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### Install Homebrew (if not already installed)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install Flutter
```bash
# Download Flutter SDK
cd ~/Development  # or wherever you want to keep Flutter
git clone https://github.com/flutter/flutter.git -b stable
cd flutter

# Add Flutter to your PATH
echo 'export PATH="$PATH:$HOME/Development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
flutter doctor
```

---

## 🔧 Step 2: Setup Flutter for iOS

```bash
# Install CocoaPods (required for iOS)
sudo gem install cocoapods

# Run Flutter doctor to check setup
flutter doctor

# Accept Xcode license
sudo xcodebuild -license accept
```

---

## 📦 Step 3: Get the Project Code

```bash
# Navigate to where you want the project
cd ~/Documents  # or any folder you prefer

# Clone your repository
git clone https://github.com/dylanmoses235-lang/house-manager-app.git
cd house-manager-app

# Install Flutter dependencies
flutter pub get
```

---

## 🍎 Step 4: Setup iOS Project in Xcode

### Open the iOS project:
```bash
# From the house-manager-app directory
open ios/Runner.xcworkspace
```

### In Xcode, configure your project:

1. **Select the Runner project** in the left sidebar
2. **Select "Runner" target** under TARGETS
3. **Go to "Signing & Capabilities" tab**
4. **Set your Team:**
   - Click the Team dropdown
   - Select "Add Account..." if needed
   - Sign in with your Apple ID
   - Select your Personal Team
5. **Change Bundle Identifier:**
   - Change from `com.example.houseManager` to something unique
   - Example: `com.yourname.housemanager`
   - This must be unique and lowercase

---

## 📱 Step 5: Connect Your iPhone

1. **Connect your iPhone** to your Mac with a USB cable
2. **Unlock your iPhone** and tap "Trust This Computer"
3. **Enable Developer Mode** on your iPhone:
   - Go to: Settings → Privacy & Security → Developer Mode
   - Turn on Developer Mode
   - Restart your iPhone when prompted
4. **In Xcode**: Select your iPhone from the device dropdown (top bar)

---

## 🚀 Step 6: Build and Install

### Option A: Using Terminal (Recommended)
```bash
# Make sure you're in the project directory
cd ~/Documents/house-manager-app

# List available devices
flutter devices

# Build and install to your iPhone
flutter run --release

# Or if you want to build an .ipa file
flutter build ios --release
```

### Option B: Using Xcode
1. In Xcode, with your project open
2. Select your iPhone as the target device
3. Click the ▶️ (Play) button at the top
4. Wait for the build to complete
5. The app will install on your iPhone

---

## 🔓 Step 7: Trust Developer Certificate

When you first open the app on your iPhone, you'll see:
**"Untrusted Developer"**

To fix this:
1. Go to: **Settings → General → VPN & Device Management**
2. Find your Apple ID/email under "Developer App"
3. Tap it and select **"Trust [Your Name]"**
4. Confirm by tapping **"Trust"** again
5. Now open the House Manager app - it should work!

---

## 🎨 What's New in This Version

### 🔄 Major Changes:
- **Daily Tasks is now the main screen** (prevents dishes/trash pileup!)
- **13 comprehensive daily tasks** across all zones
- **Today's deep clean zone** shown prominently
- **Priority-based task sorting** (urgent tasks first)

### 📋 Task Categories:
- **High Priority**: Dishes, counters, dog bowls, trash, bathroom
- **Medium Priority**: Sink, stovetop, floor sweep, bed, bedroom pickup, living room
- **Low Priority**: Quick sweeps and optional tasks

### 🏠 Navigation:
- **Daily** → Main screen with daily recurring tasks
- **Deep Clean** → Today's zone with thorough cleaning tasks
- **Schedule** → Your daily time schedule
- **Declutter** → 30-day declutter challenge
- **Stats** → Progress tracking and achievements

---

## 🔧 Troubleshooting

### "No devices found"
```bash
# Check if iPhone is connected
flutter devices

# Restart both iPhone and Mac
# Ensure iPhone is unlocked
# Trust the computer when prompted
```

### "Code signing failed"
- Make sure you selected your Team in Xcode
- Change the Bundle Identifier to be unique
- Try cleaning the build: `flutter clean && flutter pub get`

### "Could not find an option named 'release'"
```bash
# Just use regular run command
flutter run
```

### Build takes too long / stuck
```bash
# Clean and rebuild
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
```

### "Command PhaseScriptExecution failed"
```bash
# Clean CocoaPods cache
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

---

## 📱 Using the App

### Daily Workflow:
1. **Open app** → See your daily tasks
2. **Complete tasks** → Tap "Mark Complete" on each
3. **Watch pileup indicators** → Shows days since last completed
4. **Tap "Today's Deep Clean"** → See zone-specific tasks
5. **Track progress** → Check Stats tab for achievements

### Understanding Pileup:
- **0 days** = ✅ Done! (Green)
- **1 day** = ⚠️ Warning (Orange)
- **2+ days** = 🚨 Urgent (Red)
- **3+ days** = 💥 Critical (Dark Red)

---

## 🔄 Updating the App

When you make code changes:

```bash
# Pull latest changes
cd ~/Documents/house-manager-app
git pull

# Rebuild and install
flutter clean
flutter pub get
flutter run --release
```

---

## 💡 Tips for Best Experience

### Daily Use:
- ✅ Check app first thing in morning
- ✅ Complete high-priority tasks first
- ✅ Dishes and dog bowls should be done daily
- ✅ Use deep clean tab for weekly zone cleaning

### Motivation:
- 🏆 Watch your stats grow
- 🔥 Maintain your streak
- 🎯 Unlock achievements
- 📊 See progress charts

### Time Management:
- ⏱️ Use the timer feature for tasks
- 📝 Add notes to remember details
- 📸 Take before/after photos (optional)
- 📅 Check schedule tab for time blocking

---

## 🆘 Need Help?

### Common Questions:

**Q: Can I change which tasks show up daily?**
A: Yes! You can customize this in the code. Edit `lib/data/daily_tasks_data.dart`

**Q: Can I change the zone schedule?**
A: Yes! Go to Deep Clean tab → Tap settings icon → Manage Zones

**Q: How do I backup my progress?**
A: Settings → Data Management → Export Backup

**Q: Does this work offline?**
A: Yes! All data is stored locally on your phone.

**Q: Can I use this on multiple devices?**
A: Currently, each device maintains its own data. Cloud sync is a future feature.

---

## 🎉 Success Checklist

After following this guide, you should have:

- ✅ Xcode installed and configured
- ✅ Flutter SDK installed and working
- ✅ Project cloned from GitHub
- ✅ iOS project configured with your Apple ID
- ✅ App built successfully
- ✅ App installed on your iPhone
- ✅ Developer certificate trusted
- ✅ App running with daily tasks as home screen

---

## 📚 Additional Resources

- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Xcode Documentation](https://developer.apple.com/xcode/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [GitHub Repository](https://github.com/dylanmoses235-lang/house-manager-app)

---

## 🚀 You're All Set!

Your House Manager app is now installed on your iPhone! Open it and start organizing your cleaning routine. 

Remember: **Daily tasks prevent pileup!** 🧹✨

---

**Version:** 1.2.0 (Daily Tasks Focus Update)  
**Last Updated:** January 26, 2026  
**Platform:** iOS (iPhone)
