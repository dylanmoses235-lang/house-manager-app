#!/bin/bash
# Complete iOS Deployment Fix Script
# Run this on your Mac in the house-manager-app directory

echo "🔧 Starting iOS deployment fix..."

# 1. Clean all build artifacts and metadata
echo "📦 Step 1: Cleaning build artifacts and metadata..."
flutter clean
rm -rf build
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData/*
find . -name "*.DS_Store" -type f -delete
xattr -cr .

# 2. Create/Update Podfile with correct iOS deployment target
echo "📝 Step 2: Creating Podfile with iOS 12.0+ deployment target..."
cat > ios/Podfile << 'EOF'
# Uncomment this line to define a global platform for your project
platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
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
    
    # Set deployment target to 12.0 for all pods
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Fix warnings
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      config.build_settings['CLANG_ANALYZER_NONNULL'] = 'NO'
      config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'NO'
      
      # Remove resource fork attributes
      config.build_settings['OTHER_CODE_SIGN_FLAGS'] = '--generate-entitlement-der'
    end
  end
end
EOF

# 3. Update project.pbxproj to set iOS 12.0 deployment target
echo "🎯 Step 3: Setting Xcode project deployment target to iOS 12.0..."
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9]*\.[0-9]*/IPHONEOS_DEPLOYMENT_TARGET = 12.0/g' ios/Runner.xcodeproj/project.pbxproj

# 4. Run flutter pub get
echo "📥 Step 4: Running flutter pub get..."
flutter pub get

# 5. Install pods with updated deployment target
echo "🍎 Step 5: Installing CocoaPods..."
cd ios
pod deintegrate
pod install --repo-update
cd ..

# 6. Clean metadata again (after pod install)
echo "🧹 Step 6: Final metadata cleanup..."
xattr -cr .
xattr -cr ios
xattr -cr build 2>/dev/null || true

echo ""
echo "✅ iOS deployment fix complete!"
echo ""
echo "🚀 Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Select Runner target > Signing & Capabilities"
echo "3. Enable 'Automatically manage signing'"
echo "4. Team: Dylan Moses (JR2H3ZLP86)"
echo "5. Bundle ID: com.dylan.housemanager"
echo "6. Close Xcode"
echo "7. Run: flutter run --release"
echo ""
