#!/bin/bash

# iOS Certificate and Build Cleanup Script
# This script fixes iOS code signing issues by removing the bad certificate
# and cleaning all cached build artifacts

set -e  # Exit on error

echo "========================================="
echo "iOS Certificate and Build Cleanup Script"
echo "========================================="
echo ""

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Bad certificate hash that causes signing failures
BAD_CERT="070528733D7BEC375CDF0729424D21C6C7AD7615"
GOOD_CERT="946EE24BB58F45CEAB3A9ACF4DAF626B0923ED11"

PROJECT_DIR="$HOME/Documents/house-manager-app"

echo -e "${YELLOW}Step 1: Checking if we're in the correct directory...${NC}"
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project directory not found at $PROJECT_DIR${NC}"
    echo "Please ensure the project is located at: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"
echo -e "${GREEN}✓ Project directory found${NC}"
echo ""

echo -e "${YELLOW}Step 2: Checking for bad certificate in Xcode project...${NC}"
if grep -q "$BAD_CERT" ios/Runner.xcodeproj/project.pbxproj 2>/dev/null; then
    echo -e "${YELLOW}Found bad certificate in project file. Replacing...${NC}"
    sed -i '' "s/$BAD_CERT/$GOOD_CERT/g" ios/Runner.xcodeproj/project.pbxproj
    echo -e "${GREEN}✓ Certificate replaced in project file${NC}"
else
    echo -e "${GREEN}✓ No bad certificate found in project file${NC}"
fi
echo ""

echo -e "${YELLOW}Step 3: Attempting to remove bad certificate from keychain...${NC}"
if security find-certificate -c "$BAD_CERT" -a -Z 2>/dev/null | grep -q "SHA-1"; then
    echo -e "${YELLOW}Found bad certificate in keychain. Attempting removal...${NC}"
    security delete-certificate -Z "$BAD_CERT" 2>/dev/null && echo -e "${GREEN}✓ Certificate removed from keychain${NC}" || echo -e "${YELLOW}! Certificate removal failed (may not have permissions)${NC}"
else
    echo -e "${GREEN}✓ Bad certificate not found in keychain${NC}"
fi
echo ""

echo -e "${YELLOW}Step 4: Cleaning Flutter build artifacts...${NC}"
rm -rf build
rm -rf ios/build
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf .dart_tool/flutter_build
rm -f ios/Podfile.lock
echo -e "${GREEN}✓ Flutter build artifacts cleaned${NC}"
echo ""

echo -e "${YELLOW}Step 5: Cleaning Xcode DerivedData...${NC}"
rm -rf ~/Library/Developer/Xcode/DerivedData/*
echo -e "${GREEN}✓ Xcode DerivedData cleaned${NC}"
echo ""

echo -e "${YELLOW}Step 6: Removing extended attributes from frameworks...${NC}"
find . -name "*.framework" -exec xattr -cr {} \; 2>/dev/null
xattr -cr . 2>/dev/null
echo -e "${GREEN}✓ Extended attributes removed${NC}"
echo ""

echo -e "${YELLOW}Step 7: Cleaning iOS Flutter artifacts...${NC}"
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec  
rm -rf ios/Flutter/App.framework
rm -rf ios/Flutter/engine
echo -e "${GREEN}✓ iOS Flutter artifacts cleaned${NC}"
echo ""

echo -e "${YELLOW}Step 8: Deintegrating CocoaPods...${NC}"
cd ios
pod deintegrate 2>/dev/null || true
echo -e "${GREEN}✓ CocoaPods deintegrated${NC}"
echo ""

echo -e "${YELLOW}Step 9: Reinstalling CocoaPods...${NC}"
pod install
cd ..
echo -e "${GREEN}✓ CocoaPods reinstalled${NC}"
echo ""

echo -e "${YELLOW}Step 10: Running Flutter clean...${NC}"
flutter clean
echo -e "${GREEN}✓ Flutter cleaned${NC}"
echo ""

echo -e "${YELLOW}Step 11: Getting Flutter dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Flutter dependencies downloaded${NC}"
echo ""

echo ""
echo "========================================="
echo -e "${GREEN}✓ Cleanup Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Go to: Runner (root) → Target: Runner → Signing & Capabilities"
echo "3. Ensure:"
echo "   - 'Automatically manage signing' is CHECKED"
echo "   - Team: Dylan Moses (Personal Team) [JR2H3ZLP86]"
echo "   - Bundle Identifier: com.dylan.housemanager"
echo "   - Signing Certificate: Apple Development: Dylan Moses (NUJX6SZ5Z4)"
echo ""
echo "4. Then run: flutter run"
echo ""
echo -e "${YELLOW}Note: If you still get signing errors, try:${NC}"
echo "   xattr -cr ~/Documents/house-manager-app"
echo "   flutter clean && flutter run"
echo ""
