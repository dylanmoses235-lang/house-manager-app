# iOS Deployment Target Fix - Manual Steps

## The Problem
Your iOS build is failing because:
1. **Deployment target mismatch**: Pods are set to iOS 9.0/11.0 but need 12.0+
2. **Codesigning errors**: macOS metadata (resource forks) interfering with signing
3. **Missing Podfile configuration**: No platform specification in Podfile

## The Solution (Run on Your Mac)

### Option 1: Automated Fix (Recommended)
```bash
cd ~/Documents/house-manager-app
chmod +x FIX_IOS_DEPLOYMENT.sh
./FIX_IOS_DEPLOYMENT.sh
```

Then open Xcode, configure signing, and run:
```bash
open ios/Runner.xcworkspace
# In Xcode: Runner > Signing & Capabilities > Team: Dylan Moses (JR2H3ZLP86)
# Close Xcode
flutter run --release
```

---

### Option 2: Manual Fix (Step-by-Step)

#### Step 1: Complete Cleanup
```bash
cd ~/Documents/house-manager-app
flutter clean
rm -rf build
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks
find . -name "*.DS_Store" -delete
xattr -cr .
```

#### Step 2: Create Podfile
Create `ios/Podfile` with this content:
```ruby
platform :ios, '12.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      config.build_settings['OTHER_CODE_SIGN_FLAGS'] = '--generate-entitlement-der'
    end
  end
end
```

#### Step 3: Update Xcode Project Deployment Target
```bash
# Set deployment target to 12.0 in project file
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9]*\.[0-9]*/IPHONEOS_DEPLOYMENT_TARGET = 12.0/g' ios/Runner.xcodeproj/project.pbxproj
```

#### Step 4: Reinstall Dependencies
```bash
flutter pub get
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

#### Step 5: Final Cleanup
```bash
xattr -cr .
xattr -cr ios
```

#### Step 6: Configure Signing in Xcode
```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select **Runner** (blue app icon) in the left panel
2. Under **TARGETS** > **Runner**
3. Go to **Signing & Capabilities** tab
4. Enable ✅ **Automatically manage signing**
5. **Team**: Select **Dylan Moses (JR2H3ZLP86)**
6. **Bundle Identifier**: `com.dylan.housemanager`
7. **Close Xcode completely**

#### Step 7: Build and Run
```bash
flutter run --release
```

---

## What Each Step Does

1. **Cleanup**: Removes all cached builds, pods, and macOS metadata
2. **Podfile**: Sets minimum iOS version to 12.0 for all dependencies
3. **Xcode Project**: Updates project-level deployment target to 12.0
4. **Dependencies**: Reinstalls all pods with correct deployment targets
5. **Metadata Cleanup**: Removes macOS resource forks that break codesigning
6. **Signing**: Configures proper code signing with your Apple Developer account
7. **Build**: Creates release build and deploys to your iPhone

---

## Troubleshooting

### If you still get "resource fork" errors:
```bash
# More aggressive metadata cleanup
sudo xattr -cr ~/Documents/house-manager-app
sudo xattr -cr ~/Documents/house-manager-app/build
# Clear derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*
flutter clean
flutter run --release
```

### If pods fail to install:
```bash
# Update CocoaPods
sudo gem install cocoapods
pod repo update
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

### If signing fails:
1. Open **Keychain Access**
2. Check for valid **Apple Development** certificate
3. In Xcode, go to **Preferences** > **Accounts**
4. Select your Apple ID
5. Click **Download Manual Profiles**

---

## Expected Results

✅ **Success indicators:**
- Pod install completes with iOS 12.0 deployment target
- No "resource fork" codesigning errors
- App builds and deploys to iPhone in ~5 minutes
- App launches on iPhone successfully

🎉 **You should see:** "Running on Dylans iPhone" in the terminal!

---

## Quick Command Summary (Copy-Paste All at Once)

```bash
cd ~/Documents/house-manager-app
flutter clean
rm -rf build ios/Pods ios/Podfile.lock ios/.symlinks
find . -name "*.DS_Store" -delete
xattr -cr .
flutter pub get
cd ios && pod deintegrate && pod install --repo-update && cd ..
xattr -cr . && xattr -cr ios
open ios/Runner.xcworkspace
```

Then in Xcode: Runner > Signing & Capabilities > Team: Dylan Moses

Then close Xcode and run:
```bash
flutter run --release
```

---

**Time estimate:** 5-10 minutes total
**Success rate:** Should work on first try after these fixes! 🚀
