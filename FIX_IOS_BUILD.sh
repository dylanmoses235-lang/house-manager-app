#!/bin/bash

# ============================================================================
# iOS Build Fix Script for house-manager-app
# ============================================================================
# This script resolves CocoaPods integration issues and rebuilds the iOS app
# Run this from the project root: ~/Documents/house-manager-app
# ============================================================================

set -e  # Exit on any error

echo "=================================================="
echo "🔧 iOS Build Fix Script"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: Not in Flutter project root${NC}"
    echo "Please run this script from ~/Documents/house-manager-app"
    exit 1
fi

echo -e "${YELLOW}📍 Current directory: $(pwd)${NC}"
echo ""

# Step 1: Clean everything
echo -e "${YELLOW}Step 1: Deep cleaning iOS build artifacts...${NC}"
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec
rm -rf ios/Flutter/App.framework
rm -rf ios/Flutter/engine
rm -rf build
rm -rf .dart_tool/flutter_build
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/CocoaPods
echo -e "${GREEN}✅ Cleaned iOS artifacts${NC}"
echo ""

# Step 2: Flutter clean and get packages
echo -e "${YELLOW}Step 2: Flutter clean and get dependencies...${NC}"
flutter clean
flutter pub get
echo -e "${GREEN}✅ Flutter dependencies updated${NC}"
echo ""

# Step 3: Ensure Flutter iOS framework is built
echo -e "${YELLOW}Step 3: Building Flutter iOS framework...${NC}"
flutter precache --ios
flutter build ios-framework --no-debug --no-profile
echo -e "${GREEN}✅ Flutter iOS framework built${NC}"
echo ""

# Step 4: Update CocoaPods repo
echo -e "${YELLOW}Step 4: Updating CocoaPods repository...${NC}"
pod repo update
echo -e "${GREEN}✅ CocoaPods repo updated${NC}"
echo ""

# Step 5: Install pods
echo -e "${YELLOW}Step 5: Installing CocoaPods dependencies...${NC}"
cd ios
pod deintegrate || true  # Remove existing integration
pod install --repo-update
cd ..
echo -e "${GREEN}✅ CocoaPods dependencies installed${NC}"
echo ""

# Step 6: Verify workspace exists
echo -e "${YELLOW}Step 6: Verifying workspace...${NC}"
if [ -d "ios/Runner.xcworkspace" ]; then
    echo -e "${GREEN}✅ Workspace exists at ios/Runner.xcworkspace${NC}"
else
    echo -e "${RED}❌ Warning: Workspace not found${NC}"
fi
echo ""

# Step 7: Open Xcode
echo -e "${YELLOW}Step 7: Opening Xcode...${NC}"
open ios/Runner.xcworkspace
echo ""

echo "=================================================="
echo -e "${GREEN}✅ iOS Build Fix Complete!${NC}"
echo "=================================================="
echo ""
echo "Next steps in Xcode:"
echo "1. Wait for Xcode to open"
echo "2. Select the Runner target (top left)"
echo "3. Go to Signing & Capabilities tab"
echo "4. Enable 'Automatically manage signing'"
echo "5. Select your team: Dylan Moses (Personal Team)"
echo "6. Press ⌘K to Clean Build Folder"
echo "7. Press ⌘R to Run"
echo ""
echo "If you still see errors, run:"
echo "  flutter run --verbose"
echo ""
