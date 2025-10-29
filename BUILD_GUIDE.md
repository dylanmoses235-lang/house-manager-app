# 🏗️ House Manager - iOS Build & Installation Guide

## Prerequisites

Before building, ensure you have:
- ✅ Mac with macOS
- ✅ Xcode installed (latest version recommended)
- ✅ Terminal access
- ✅ Apple Developer account (free or paid)
- ✅ iPhone with USB cable

---

## 📋 Step-by-Step Build Instructions

### Step 1: Install Flutter (if not already installed)

Open Terminal and run:

```bash
# Check if Flutter is installed
flutter --version

# If not installed, install Flutter:
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/macos
# Or use this command:
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### Step 2: Navigate to Your Project

```bash
# Navigate to your project directory
cd /path/to/house-manager-app

# Or if you cloned from GitHub:
git clone https://github.com/dylanmoses235-lang/house-manager-app.git
cd house-manager-app
```

### Step 3: Install Dependencies

```bash
# Get all Flutter packages
flutter pub get

# This will install all dependencies from pubspec.yaml
```

### Step 4: Connect Your iPhone

1. Connect your iPhone to your Mac via USB cable
2. Unlock your iPhone
3. Trust the computer if prompted on your iPhone
4. In Terminal, check if device is detected:

```bash
flutter devices
```

You should see your iPhone listed.

### Step 5: Open Project in Xcode

```bash
# Open the iOS project in Xcode
open ios/Runner.xcworkspace
```

**Important:** Always open `.xcworkspace`, NOT `.xcodeproj`

### Step 6: Configure Signing in Xcode

In Xcode:

1. Click on **"Runner"** in the left sidebar (top item)
2. Select **"Runner"** under TARGETS
3. Go to **"Signing & Capabilities"** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (your Apple ID)
6. Change **Bundle Identifier** to something unique:
   - Example: `com.yourname.housemanager`
   - Make it unique to avoid conflicts

### Step 7: Set Deployment Target

In Xcode (same screen):

1. Under **"Deployment Info"**
2. Set **iOS Deployment Target** to `12.0` or higher
3. Ensure **"iPhone"** is checked under "Devices"

### Step 8: Add Required Permissions

The app needs permissions for photos and notifications. These should already be configured, but verify:

In Xcode:
1. Select **Runner** (project)
2. Go to **Info** tab
3. Verify these keys exist (add if missing):

```xml
Privacy - Camera Usage Description
Privacy - Photo Library Usage Description
Privacy - Notifications Usage Description
```

Or edit `ios/Runner/Info.plist` directly:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to the camera to take photos of your cleaning tasks.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to attach photos to tasks.</string>
<key>NSUserNotificationsUsageDescription</key>
<string>This app needs to send you reminders for your cleaning tasks.</string>
```

### Step 9: Build and Install via Terminal

Now return to Terminal:

```bash
# Clean previous builds
flutter clean

# Get dependencies again
flutter pub get

# Build and install on your iPhone
flutter run --release
```

This will:
- Build the app in release mode
- Install it on your connected iPhone
- Launch the app

**Alternative:** Build in Xcode directly:
1. In Xcode, select your iPhone from the device dropdown (top bar)
2. Click the **Play ▶** button to build and run

---

## 🔧 Troubleshooting

### Issue: "No provisioning profile found"

**Solution:**
1. In Xcode, go to Xcode → Preferences → Accounts
2. Add your Apple ID if not already added
3. Select your Apple ID → Manage Certificates → Create iOS Development Certificate
4. Return to Runner → Signing & Capabilities
5. Reselect your team

### Issue: "Untrusted Developer"

**Solution on iPhone:**
1. Go to Settings → General → VPN & Device Management
2. Find your developer profile
3. Tap "Trust [Your Name]"
4. Confirm trust

### Issue: "Command not found: flutter"

**Solution:**
```bash
# Add Flutter to your PATH permanently
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Or for bash:
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bash_profile
source ~/.bash_profile
```

### Issue: CocoaPods not installed

**Solution:**
```bash
# Install CocoaPods
sudo gem install cocoapods

# Navigate to iOS folder and install pods
cd ios
pod install
cd ..
```

### Issue: Build fails with dependency errors

**Solution:**
```bash
# Clean everything
flutter clean
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter pub get
flutter run --release
```

### Issue: "The application could not be verified"

**Solution on iPhone:**
1. Settings → General → VPN & Device Management
2. Trust the developer profile
3. Restart the app

---

## 🎯 Quick Build Commands Reference

### Development Build (with hot reload):
```bash
flutter run
```

### Release Build (optimized):
```bash
flutter run --release
```

### Build IPA for Distribution:
```bash
flutter build ios --release
```

### Check for Issues:
```bash
flutter doctor -v
```

### Clean Build:
```bash
flutter clean
flutter pub get
flutter run --release
```

---

## 📱 Installing on Multiple Devices

To install on another iPhone:

1. Connect the new iPhone
2. Trust the computer
3. Run: `flutter devices` to verify
4. Run: `flutter run --release`

---

## 🏪 App Store Deployment (Optional)

If you want to publish to the App Store:

### 1. Create App Icons

You'll need app icons in various sizes. Use a tool like:
- https://appicon.co/
- https://www.appicon.build/

Place icons in: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 2. Update App Info

Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>House Manager</string>
<key>CFBundleName</key>
<string>House Manager</string>
```

### 3. Create App in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Create new app
3. Fill in app details

### 4. Build Archive in Xcode

1. In Xcode, select **"Any iOS Device"** from device dropdown
2. Product → Archive
3. Wait for build to complete
4. Click **"Distribute App"**
5. Follow prompts to upload to App Store Connect

### 5. Submit for Review

In App Store Connect:
1. Fill in app description, screenshots, etc.
2. Submit for review
3. Wait for approval (1-3 days typically)

---

## 🎨 App Icon Creation

Your app needs an icon! Create a 1024x1024 PNG image with your desired design.

Suggestions for House Manager icon:
- 🏠 House with checkmark
- 📋 Clipboard with house
- ✨ Sparkles with broom
- 🧹 Cleaning supplies arranged nicely

Use online tools to generate all required sizes automatically.

---

## 📸 Screenshots for App Store (Optional)

You'll need screenshots for different iPhone sizes:
- iPhone 6.7" (iPhone 14 Pro Max)
- iPhone 6.5" (iPhone 11 Pro Max)
- iPhone 5.5" (iPhone 8 Plus)

Capture screenshots of:
1. Dashboard with tasks
2. Zone cleaning screen
3. Statistics with charts
4. Calendar view
5. Shopping list

---

## ⚙️ Build Settings Explained

### Debug vs Release:

**Debug Build (`flutter run`):**
- ✅ Hot reload enabled
- ✅ Faster compilation
- ❌ Larger app size
- ❌ Slower performance
- Use for: Development and testing

**Release Build (`flutter run --release`):**
- ✅ Optimized performance
- ✅ Smaller app size
- ❌ No hot reload
- ❌ Slower compilation
- Use for: Final testing and deployment

---

## 🔐 Signing Explained

### Free Apple Account:
- ✅ Can install on your devices
- ✅ App works for 7 days
- ❌ Need to re-sign after 7 days
- ❌ Cannot publish to App Store

### Paid Apple Developer Account ($99/year):
- ✅ Can install on your devices
- ✅ App doesn't expire
- ✅ Can publish to App Store
- ✅ TestFlight distribution

---

## 🎯 Quick Start Summary

For most users, follow these steps:

```bash
# 1. Navigate to project
cd /path/to/house-manager-app

# 2. Get dependencies
flutter pub get

# 3. Connect iPhone via USB

# 4. Build and install
flutter run --release
```

Then in Xcode:
- Configure signing with your Apple ID
- Trust developer on iPhone
- Run the app!

---

## 📞 Common Questions

**Q: Do I need a paid Apple Developer account?**
A: No, a free Apple ID works for personal use. Paid account needed only for App Store.

**Q: How long does the build take?**
A: First build: 5-10 minutes. Subsequent builds: 1-2 minutes.

**Q: Can I test on iOS Simulator?**
A: Yes! Run: `flutter run` without connecting iPhone. But some features (camera, notifications) won't work in simulator.

**Q: Will my data sync between devices?**
A: Currently no, data is stored locally. Cloud sync was not implemented.

**Q: Can I install on my iPad?**
A: Yes! The app works on iPad too. Just connect iPad and run the build command.

---

## ✅ Final Checklist

Before installing on your iPhone:

- [ ] Flutter installed and working (`flutter doctor`)
- [ ] Project dependencies installed (`flutter pub get`)
- [ ] iPhone connected and detected (`flutter devices`)
- [ ] Xcode signing configured
- [ ] Bundle identifier changed to unique value
- [ ] Permissions added to Info.plist
- [ ] App builds successfully (`flutter run --release`)
- [ ] Developer profile trusted on iPhone

---

## 🎉 Success!

Once built and installed, you'll have the complete House Manager app on your iPhone with:

- ✅ Task management with persistence
- ✅ Notifications
- ✅ Photo management
- ✅ Statistics & achievements
- ✅ Dark mode
- ✅ Timer functionality
- ✅ Shopping lists
- ✅ Calendar view
- ✅ Custom zones
- ✅ Export/backup

Enjoy your new household management app! 🏠✨

---

## 🆘 Need Help?

If you encounter issues:

1. Check `flutter doctor -v` for system issues
2. Try `flutter clean` and rebuild
3. Verify iPhone is in Developer Mode (iOS 16+):
   - Settings → Privacy & Security → Developer Mode → ON
4. Check Xcode console for detailed error messages
5. Ensure iOS version is 12.0+

---

**Last Updated:** 2025-10-29  
**App Version:** 1.1.0  
**Minimum iOS:** 12.0
