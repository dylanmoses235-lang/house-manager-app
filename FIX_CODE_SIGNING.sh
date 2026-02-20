#!/bin/bash

# ============================================================================
# iOS Code Signing Fix for house-manager-app
# ============================================================================
# This script fixes the "CodeSign failed with a nonzero exit code" error
# Run this from: ~/Documents/house-manager-app
# ============================================================================

set -e

echo "=================================================="
echo "🔐 iOS Code Signing Fix"
echo "=================================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Navigate to project
cd ~/Documents/house-manager-app

echo -e "${YELLOW}Step 1: Cleaning all build artifacts...${NC}"
rm -rf build
rm -rf ios/build
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/App.framework
rm -rf .dart_tool
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -f ios/Podfile.lock
echo -e "${GREEN}✅ Build artifacts cleaned${NC}"
echo ""

echo -e "${YELLOW}Step 2: Removing extended attributes (quarantine flags)...${NC}"
xattr -cr .
find . -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true
echo -e "${GREEN}✅ Extended attributes removed${NC}"
echo ""

echo -e "${YELLOW}Step 3: Reinstalling dependencies...${NC}"
flutter clean
flutter pub get
cd ios
pod install
cd ..
echo -e "${GREEN}✅ Dependencies reinstalled${NC}"
echo ""

echo -e "${YELLOW}Step 4: Regenerating iOS configuration...${NC}"
flutter build ios --config-only
echo -e "${GREEN}✅ iOS config regenerated${NC}"
echo ""

echo "=================================================="
echo -e "${GREEN}✅ Code Signing Fix Complete!${NC}"
echo "=================================================="
echo ""
echo "Now try ONE of these options:"
echo ""
echo "📱 OPTION 1: Run directly from terminal (RECOMMENDED)"
echo "   flutter run --release"
echo ""
echo "📱 OPTION 2: Run in debug mode"
echo "   flutter run"
echo ""
echo "📱 OPTION 3: Use Xcode (if previous options fail)"
echo "   open ios/Runner.xcworkspace"
echo "   Then in Xcode:"
echo "   - Select Runner target → Signing & Capabilities"
echo "   - Uncheck 'Automatically manage signing'"
echo "   - Then RE-CHECK 'Automatically manage signing'"
echo "   - Select Team: Dylan Moses (Personal Team)"
echo "   - Press ⌘K to Clean Build Folder"
echo "   - Press ⌘R to Run"
echo ""
echo "If you STILL get signing errors, run this command:"
echo "   security unlock-keychain -p YOUR_MAC_PASSWORD ~/Library/Keychains/login.keychain-db"
echo ""
