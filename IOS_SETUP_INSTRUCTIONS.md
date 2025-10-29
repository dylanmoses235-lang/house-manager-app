# iOS Setup Instructions - Custom Zones Fix

## 📱 Getting the Updated Code on Your Mac

### Step 1: Pull the Latest Changes

Open **Terminal** on your Mac and navigate to your project folder, then pull the updates:

```bash
# Navigate to your project folder
cd /path/to/house-manager-app

# Pull the latest changes from GitHub
git pull origin main

# You should see the custom zones fix being downloaded
```

### Step 2: Verify the Changes

Check that you have the updated files:

```bash
# List the changed files
git log --oneline -1

# You should see: "fix(zones): Add support for custom zones in zone cleaning workflow"
```

---

## 🛠️ Building and Running on iOS

### Method 1: Using Terminal (Recommended)

```bash
# Make sure you're in the project directory
cd /path/to/house-manager-app

# Get Flutter dependencies
flutter pub get

# Clean any previous builds
flutter clean

# Build for iOS (this will take a few minutes)
flutter build ios

# Run on your connected iOS device
flutter run -d ios
```

**OR** to run on a specific device:

```bash
# List available devices
flutter devices

# Run on specific device (replace DEVICE_ID with actual ID)
flutter run -d DEVICE_ID
```

### Method 2: Using Xcode

1. **Open the iOS project in Xcode:**
   ```bash
   # Navigate to the ios folder
   cd /path/to/house-manager-app/ios
   
   # Open in Xcode
   open Runner.xcworkspace
   ```
   
   ⚠️ **Important:** Open `Runner.xcworkspace` NOT `Runner.xcodeproj`!

2. **In Xcode:**
   - Select your iOS device from the device dropdown (top left, next to "Runner")
   - Click the ▶️ **Run** button (or press `Cmd + R`)
   - Xcode will build and install the app on your device

---

## 📋 First-Time iOS Setup (If Needed)

If this is your first time building for iOS, you may need to:

### 1. Install CocoaPods Dependencies
```bash
cd /path/to/house-manager-app/ios
pod install
```

### 2. Set up Code Signing in Xcode
1. Open `Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the left sidebar
3. Select the **Runner** target
4. Go to **Signing & Capabilities** tab
5. Check **"Automatically manage signing"**
6. Select your **Apple ID Team** from the dropdown
7. Change the **Bundle Identifier** if needed (make it unique, e.g., `com.yourname.housemanager`)

---

## ✅ Testing the Custom Zones Fix

Once the app is running on your iOS device:

1. **Go to Manage Zones** (from Settings or Navigation)
2. **Add a Custom Zone** (e.g., "Garage", "Basement", "Patio")
3. **Assign it to a day** (e.g., Monday = Garage)
4. **Go to Zone Cleaning screen**
5. **Tap the filter icon** (top right)
6. ✨ **Your custom zone should now appear in the dropdown!**
7. **Select your custom zone**
8. **Tap the ➕ "Add Task" button** in the app bar
9. **Add tasks** to your custom zone
10. **Check the Dashboard** - it should show your custom zone on the correct day

---

## 🐛 Troubleshooting

### Error: "Command not found: flutter"
```bash
# Add Flutter to your PATH (adjust the path to your Flutter installation)
export PATH="$PATH:/path/to/flutter/bin"

# Or permanently add to your shell profile
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Error: "No devices found"
```bash
# Make sure your iPhone/iPad is:
# 1. Connected via USB
# 2. Unlocked
# 3. Trusted (tap "Trust" when prompted on device)

# Check if device is detected
flutter devices

# Enable Developer Mode on iOS device (iOS 16+):
# Settings > Privacy & Security > Developer Mode > Enable
```

### Error: Code signing issues
- Open Xcode
- Go to Signing & Capabilities
- Make sure "Automatically manage signing" is checked
- Select your team/Apple ID
- Change Bundle Identifier if needed

### App crashes or doesn't load data
```bash
# Uninstall the old version from your device first
# Then rebuild and install:
flutter clean
flutter pub get
flutter run -d ios
```

---

## 📱 Alternative: Test on iOS Simulator

If you don't have a physical device connected:

```bash
# Open iOS Simulator
open -a Simulator

# Wait for simulator to open, then run:
flutter run -d iphone
```

---

## 🎉 What's Fixed

After updating, you should now have:

- ✅ Custom zones appearing in zone selection dropdown
- ✅ Ability to add tasks to custom zones
- ✅ Custom zones showing in weekly plan/dashboard
- ✅ Custom zones appearing in calendar on correct days
- ✅ Task management with "Add Task" button (➕)

---

## 📞 Need Help?

If you encounter issues:
1. Check that you pulled the latest code: `git log -1`
2. Make sure Flutter is up to date: `flutter upgrade`
3. Try: `flutter clean && flutter pub get`
4. Check for Xcode updates in App Store

---

**Happy Cleaning! 🏠✨**
