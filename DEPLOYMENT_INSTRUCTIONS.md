# House Manager App - Deployment Instructions

**Date**: February 11, 2026  
**Repository**: https://github.com/dylanmoses235-lang/house-manager-app  
**Branch for Development**: `genspark_ai_developer`  
**Current Status**: ✅ All Dart code verified and working

---

## 🎯 Executive Summary

**Good News**: All the Dart compilation errors mentioned in your context have already been resolved in the main branch:
- ✅ Zone screen syntax errors (line 315) - Fixed in commit `8c71f24`
- ✅ Daily tasks screen styleFrom issues (line 507) - No issues found
- ✅ Missing `getAllZoneTaskCompletions` method - Method not used; code uses `getZoneTaskCompletion` instead
- ✅ Dependency conflicts - `google_mlkit_text_recognition` already commented out

**The Only Remaining Issues Are iOS Build Environment Related** - they can only be resolved on your Mac.

---

## 📋 Complete Deployment Checklist

### Phase 1: Sync Code on Mac

```bash
# 1. Navigate to project
cd ~/Documents/house-manager-app

# 2. Ensure you're on the right branch
git checkout genspark_ai_developer

# 3. Pull all latest changes (including fixes)
git fetch origin
git merge origin/main
git pull origin genspark_ai_developer

# 4. Verify you have the latest code
git log --oneline -5
# You should see:
# - "docs: add comprehensive status summary and code verification results"
# - "fix: remove literal \n from spread operator"
# - "fix: resolve Dart compilation errors"
```

### Phase 2: Clean Mac Metadata (Critical!)

```bash
# Remove all extended attributes (this fixes codesign errors)
cd ~/Documents/house-manager-app
xattr -cr .
xattr -cr build
xattr -cr ios

# Verify cleanup
xattr -l ios/Flutter/Flutter.framework  # Should show nothing
```

### Phase 3: Fix CocoaPods Setup

```bash
# Navigate to iOS directory
cd ~/Documents/house-manager-app/ios

# Remove all Pods (clean slate)
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.podspec

# Update Pod repository (gets latest pod specs)
pod repo update

# Install pods fresh
pod install

# Return to project root
cd ..
```

### Phase 4: Create/Update Podfile Platform

If `ios/Podfile` doesn't exist or needs updating:

```bash
cd ~/Documents/house-manager-app/ios
```

Edit `Podfile` - the first line should be:

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '12.0'
```

Then run:

```bash
pod install
cd ..
```

### Phase 5: Clean Flutter Build

```bash
cd ~/Documents/house-manager-app

# Clean all build artifacts
flutter clean

# Clear .dart_tool cache
rm -rf .dart_tool

# Get dependencies
flutter pub get
```

### Phase 6: Configure Xcode Signing

This **MUST** be done in Xcode GUI:

1. Open Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. In Xcode:
   - Select **Runner** project in the left sidebar
   - Select **Runner** target (under TARGETS)
   - Click **Signing & Capabilities** tab
   - **Automatically manage signing**: ✅ Check this
   - **Team**: Select **Dylan Moses (JR2H3ZLP86)**
   - **Bundle Identifier**: Verify it's `com.dylan.housemanager`

3. Check for errors in the signing section - resolve any:
   - If provisioning profile errors appear, click "Download Manual Profiles"
   - If team isn't showing, log in with Apple ID in Xcode Preferences

### Phase 7: Connect iPhone and Trust Developer

1. Connect iPhone via USB cable (not wireless!)

2. On iPhone:
   - Go to **Settings** → **General** → **VPN & Device Management**
   - Find **Dylan Moses** developer profile
   - Tap **Trust "Dylan Moses"**
   - Confirm trust

3. In Xcode, verify device appears in device dropdown (top toolbar)

### Phase 8: Build and Deploy

```bash
# Option A: Using Flutter command (recommended)
cd ~/Documents/house-manager-app
flutter run --release -d "Dylans iphone"

# Option B: Using your build script (if it exists)
./build_for_iphone.sh

# Option C: Build in Xcode
# In Xcode: Product → Run (or Cmd+R)
```

---

## 🔧 Troubleshooting Common Issues

### Issue 1: "resource fork, Finder information, or similar detritus not allowed"

**Solution**:
```bash
cd ~/Documents/house-manager-app
xattr -cr .
xattr -cr build
xattr -cr ios
flutter clean
```

### Issue 2: "gRPC-C++ header not found"

**Solution**:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod repo update
pod install
cd ..
flutter clean
flutter pub get
```

### Issue 3: "IPHONEOS_DEPLOYMENT_TARGET is set to 9.0/10.0"

**Solution**: Edit `ios/Podfile`:
```ruby
platform :ios, '12.0'

# After the target 'Runner' do line, add:
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

Then:
```bash
cd ios
pod install
cd ..
```

### Issue 4: "No Development Team selected"

**Solution**: 
- Open `ios/Runner.xcworkspace` in Xcode
- Select Runner target → Signing & Capabilities
- Choose Team: **Dylan Moses (JR2H3ZLP86)**

### Issue 5: "Codesigning failed with exit code 1"

**Solution**:
```bash
# Clean everything
cd ~/Documents/house-manager-app
flutter clean
rm -rf build
rm -rf ios/build
xattr -cr .

# Rebuild
flutter pub get
flutter build ios --release
```

### Issue 6: "flutter clean hangs"

**Solution**:
```bash
# Manual clean
cd ~/Documents/house-manager-app
rm -rf build
rm -rf .dart_tool
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks

# Then proceed with flutter pub get
```

---

## 📊 Expected Build Timeline

| Phase | Task | Time |
|-------|------|------|
| 1 | Sync code | 30 seconds |
| 2 | Clean metadata | 10 seconds |
| 3 | Fix CocoaPods | 2-3 minutes |
| 4 | Update Podfile | 30 seconds |
| 5 | Clean Flutter | 30 seconds |
| 6 | Configure signing | 1-2 minutes |
| 7 | Trust developer | 30 seconds |
| 8 | Build & deploy | 3-5 minutes |
| **Total** | | **8-12 minutes** |

---

## ✅ Pre-Flight Checklist

Before starting, verify you have:

- [ ] Mac with macOS 12+ (Monterey or later)
- [ ] Xcode installed (14.0 or later)
- [ ] Flutter SDK installed (3.9.2+)
- [ ] CocoaPods installed (`gem install cocoapods`)
- [ ] iPhone connected via USB cable
- [ ] iPhone set to Developer Mode (Settings → Privacy & Security → Developer Mode)
- [ ] Apple ID signed in to Xcode
- [ ] Internet connection (for pod repo updates)

---

## 🎯 Quick Start (TL;DR)

For experienced developers, here's the fastest path:

```bash
cd ~/Documents/house-manager-app
git checkout genspark_ai_developer
git pull origin genspark_ai_developer
xattr -cr .
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter clean && flutter pub get
open ios/Runner.xcworkspace  # Configure signing in Xcode
flutter run --release
```

---

## 📞 If Build Still Fails

If you follow all steps above and still encounter issues:

1. **Check Flutter doctor**:
   ```bash
   flutter doctor -v
   ```
   Resolve any ❌ issues it reports.

2. **Check Xcode version**:
   ```bash
   xcodebuild -version
   ```
   Should be 14.0 or higher.

3. **Verify pod version**:
   ```bash
   pod --version
   ```
   Should be 1.11 or higher.

4. **Check iOS deployment target** in Xcode:
   - Runner target → Build Settings
   - Search for "iOS Deployment Target"
   - Should be 12.0 or higher

5. **Rebuild from scratch**:
   ```bash
   cd ~/Documents/house-manager-app
   git status  # Ensure clean working tree
   rm -rf ios build .dart_tool
   flutter create --platforms=ios .
   # Restore your signing settings in Xcode
   flutter run --release
   ```

---

## 🎉 Success Indicators

You'll know it worked when you see:

```
✓ Built build/ios/iphoneos/Runner.app
Launching lib/main.dart on Dylans iphone in release mode...
Syncing files to device Dylans iphone...
```

And the House Manager app appears on your iPhone! 📱

---

## 📝 Notes

- **All Dart code is correct** - No source code changes needed
- **Issues are environment-only** - Mac tooling setup required
- **Fixes already committed** - Recent commits resolved compilation errors
- **Ready for deployment** - Code is production-ready

**Last Code Verification**: February 11, 2026  
**Status**: ✅ All clear - Ready for iOS deployment on Mac
