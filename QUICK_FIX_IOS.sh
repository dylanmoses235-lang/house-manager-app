#!/bin/bash

# ============================================================================
# QUICK iOS Build Fix - Run this from ~/Documents/house-manager-app
# ============================================================================

set -e

echo "🔧 Quick iOS Build Fix..."
echo ""

# Navigate to project root
cd ~/Documents/house-manager-app

# 1. Pull latest code
echo "📥 Pulling latest code..."
git fetch origin genspark_ai_developer
git reset --hard origin/genspark_ai_developer

# 2. Remove all generated/cached iOS files
echo "🧹 Cleaning iOS build files..."
rm -rf ios/Flutter/Generated.xcconfig
rm -rf ios/Flutter/flutter_export_environment.sh
rm -rf ios/.symlinks
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf build
rm -rf .dart_tool
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Flutter clean and get dependencies
echo "📦 Getting Flutter dependencies..."
flutter clean
flutter pub get

# 4. Generate the missing iOS config files
echo "⚙️  Generating iOS configuration..."
flutter build ios --config-only

# 5. Install pods
echo "📚 Installing CocoaPods..."
cd ios
pod install
cd ..

# 6. Done
echo ""
echo "✅ iOS build files regenerated!"
echo ""
echo "Now run one of these:"
echo "  Option 1: flutter run"
echo "  Option 2: open ios/Runner.xcworkspace (then press Play in Xcode)"
echo ""
