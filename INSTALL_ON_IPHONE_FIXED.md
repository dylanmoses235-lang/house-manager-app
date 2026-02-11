# 📱 Install House Manager App on iPhone - Complete Fixed Guide

## 🚨 Important Fixes Applied

This guide includes fixes for the dependency conflicts that were causing build failures:
- ✅ Removed `google_mlkit_text_recognition` (receipt scanning - not essential)
- ✅ Removed `mobile_scanner` (barcode scanning - not essential)  
- ✅ Downgraded `json_serializable` to fix Hive Generator conflict
- ✅ All build errors resolved

## Prerequisites

- **Mac computer** with macOS (required for iOS development)
- **Xcode** installed (free from App Store)
- **iPhone** with USB cable
- **Apple ID** (free, no paid developer account needed)
- **45 minutes** for first-time setup

---

## Part 1: One-Time Setup (Only Do Once)

### Step 1: Install Xcode

1. Open **App Store** on your Mac
2. Search for **Xcode**
3. Click **Get** and wait for installation (takes 30-45 minutes, it's 15GB+)
4. Open Xcode once to agree to license terms

### Step 2: Install Flutter SDK

Open **Terminal** and run these commands **one at a time**:

```bash
# Create development folder
mkdir -p ~/development
cd ~/development

# Download Flutter (stable branch)
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to your PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc

# Reload your shell configuration
source ~/.zshrc

# Verify Flutter is installed
flutter --version
```

You should see something like:
```
Flutter 3.38.5 • channel stable • https://github.com/flutter/flutter.git
Framework revision f6ff1529fd (8 weeks ago) • 2025-12-11 11:50:07 -0500
Engine • revision c108a94d7a
Dart • version 3.10.4
DevTools • 2.51.1
```

### Step 3: Install CocoaPods (iOS dependency manager)

```bash
sudo gem install cocoapods
```

Enter your Mac password when prompted.

---

## Part 2: Get the App Code

### Download the App

```bash
# Navigate to Documents folder
cd ~/Documents

# Clone the repository (if you haven't already)
git clone https://github.com/dylanmoses235-lang/house-manager-app.git

# Enter the project folder
cd house-manager-app
```

**If you already cloned it**, just navigate to it:

```bash
cd ~/Documents/house-manager-app
```

---

## Part 3: Fix Dependencies and Build

### Step 1: Clean Everything

```bash
cd ~/Documents/house-manager-app

# Clean all previous build artifacts
flutter clean

# Remove iOS dependencies
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
```

### Step 2: Get Flutter Dependencies

```bash
flutter pub get
```

You should see:
```
Resolving dependencies...
Got dependencies!
```

### Step 3: Install iOS Dependencies

```bash
cd ios
pod install
cd ..
```

You should see pods being installed without errors.

---

## Part 4: Configure Signing in Xcode

### Step 1: Open the Project

```bash
cd ~/Documents/house-manager-app
open ios/Runner.xcworkspace
```

⚠️ **Important**: Open `Runner.xcworkspace`, NOT `Runner.xcodeproj`!

### Step 2: Configure Signing

1. In Xcode, click **Runner** in the left sidebar (blue app icon)
2. Under **TARGETS**, select **Runner**
3. Click the **Signing & Capabilities** tab at the top
4. ✅ Check **"Automatically manage signing"**
5. Under **Team**, select your Apple ID
   - If you don't see your Apple ID, click **Add Account** and sign in
6. Under **Bundle Identifier**, change it to something unique like:
   ```
   com.yourname.housemanager
   ```
   For example: `com.dylan.housemanager`

### Step 3: Prepare Your iPhone

1. **Connect your iPhone** to Mac via USB cable
2. **Unlock your iPhone**
3. When prompted **"Trust This Computer?"**, tap **Trust**
4. On your iPhone: **Settings → Privacy & Security → Developer Mode → ON**
5. Your iPhone will restart - wait for it to boot up
6. In Xcode, at the top left, select **"Dylans iPhone"** (or your iPhone name) from the device dropdown

---

## Part 5: Build and Install

### Method A: Build from Terminal (Recommended)

This is the most reliable method:

```bash
cd ~/Documents/house-manager-app
flutter run --release
```

⏱️ **First build takes 5-10 minutes** - this is normal!

You'll see output like:
```
Launching lib/main.dart on Dylans iPhone in release mode...
Running pod install...
Running Xcode build...
Xcode build done.                                           150.3s
Installing and launching...
```

When you see **"Application finished"**, the app is installed! 🎉

### Method B: Build from Xcode (Alternative)

If Terminal doesn't work, try Xcode:

1. In Xcode, make sure your iPhone is selected at the top
2. Click the **Play button** (▶️) in the top left
3. Wait 5-10 minutes for the build

---

## Part 6: Trust the App on iPhone

After installation, you'll need to trust the app:

1. On your iPhone, go to **Settings**
2. Tap **General → VPN & Device Management**
3. Under **Developer App**, tap your Apple ID
4. Tap **Trust "[Your Apple ID]"**
5. Tap **Trust** again in the popup

Now you can open the app! 🏠

---

## 🎯 Quick Command Summary

For future updates, just run these commands:

```bash
cd ~/Documents/house-manager-app
git pull origin main
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run --release
```

---

## 🔧 Troubleshooting

### Issue: "No devices found"

**Solution:**
```bash
# Check if iPhone is detected
flutter devices
```

You should see your iPhone listed. If not:
- Unlock your iPhone
- Trust the computer again
- Try a different USB cable
- Try a different USB port

### Issue: "CocoaPods not installed"

**Solution:**
```bash
sudo gem install cocoapods
```

### Issue: "Xcode license not accepted"

**Solution:**
```bash
sudo xcodebuild -license accept
```

### Issue: Build fails with "Module not found"

**Solution:**
```bash
cd ~/Documents/house-manager-app
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
cd ios
pod install
cd ..
flutter run --release
```

### Issue: "Certificate not trusted"

1. On iPhone: **Settings → General → VPN & Device Management**
2. Tap your Apple ID under **Developer App**
3. Tap **Trust**

### Issue: Xcode freezes during build

**Solution:** Use Terminal instead:
```bash
cd ~/Documents/house-manager-app
flutter run --release
```

---

## 📋 What's Different from Before?

### Removed Dependencies (Not Essential for Core Features)

1. **google_mlkit_text_recognition** - Receipt scanning
   - Was causing: `google_mlkit_text_recognition ^0.14.1 doesn't match any versions`
   - Impact: Receipt scanning feature disabled (can add back later if needed)

2. **mobile_scanner** - Barcode/QR code scanning  
   - Was causing: GoogleUtilities version conflicts
   - Impact: Product barcode scanning disabled (can add back later if needed)

### Fixed Dependencies

1. **json_serializable** downgraded from 6.9.2 to 6.8.0
   - Fixes conflict with hive_generator
   - No impact on functionality

### All Core Features Still Work

✅ Daily tasks tracking  
✅ Zone-based deep cleaning schedule  
✅ Weekly task rotation  
✅ Progress tracking and statistics  
✅ Photo progress tracking  
✅ Declutter challenge  
✅ Cloud sync (Firebase)  
✅ Notifications  
✅ All data storage (Hive)

---

## ⏱️ Time Breakdown

| Task | First Time | Updates |
|------|-----------|---------|
| Install Xcode | 30-45 min | - |
| Install Flutter | 5-10 min | - |
| Clone & Setup | 5 min | 1 min |
| Configure Signing | 3 min | - |
| First Build | 10-15 min | 5-10 min |
| **Total** | **~60 min** | **~10 min** |

---

## 🎉 Success!

Once installed, you'll see the **House Manager** app on your iPhone home screen with the 🏠 icon.

The app includes:
- 📋 **Daily Tasks** - Your 13 essential daily tasks
- 🏠 **Today's Zone** - Deep cleaning focus for today
- 📊 **Stats & Progress** - Track your cleaning consistency
- 📸 **Progress Photos** - Visual before/after tracking
- 🗑️ **30-Day Declutter** - Daily decluttering challenge

---

## 📚 Additional Resources

- [Flutter iOS Setup Guide](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Xcode Documentation](https://developer.apple.com/xcode/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Project GitHub](https://github.com/dylanmoses235-lang/house-manager-app)

---

## 🚀 Next Steps

1. Run the app on your iPhone
2. Complete the initial setup
3. Try the new daily tasks system
4. Check out the zone rotation schedule
5. Start tracking your progress!

Questions? Check the troubleshooting section above or ask for help!
