#!/bin/bash

# 🚀 House Manager App - Automated iOS 13.0 Fix Script
# Run this script on your Mac to fix all iOS deployment issues

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  House Manager App - iOS 13.0 Fix${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found!${NC}"
    echo -e "${YELLOW}Please run this script from the house-manager-app root directory.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found pubspec.yaml - we're in the right directory${NC}"
echo ""

# Step 1: Clean everything
echo -e "${BLUE}Step 1/7: Cleaning build artifacts...${NC}"
flutter clean
rm -rf build ios/Pods ios/Podfile.lock ios/.symlinks
find . -name "*.DS_Store" -delete
xattr -cr .
xattr -cr ios
echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

# Step 2: Update Xcode project deployment target
echo -e "${BLUE}Step 2/7: Updating Xcode project to iOS 13.0...${NC}"
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9]*\.[0-9]*/IPHONEOS_DEPLOYMENT_TARGET = 13.0/g' ios/Runner.xcodeproj/project.pbxproj
echo -e "${GREEN}✓ Xcode project updated${NC}"
echo ""

# Step 3: Verify/create Podfile
echo -e "${BLUE}Step 3/7: Checking Podfile...${NC}"
if [ ! -f "ios/Podfile" ]; then
    echo -e "${YELLOW}⚠ Podfile not found. Please copy the Podfile from the sandbox.${NC}"
    echo -e "${YELLOW}The Podfile should be at: /home/user/webapp/ios/Podfile${NC}"
    exit 1
else
    # Check if Podfile has correct platform
    if grep -q "platform :ios, '13.0'" ios/Podfile; then
        echo -e "${GREEN}✓ Podfile already has iOS 13.0 platform${NC}"
    else
        echo -e "${YELLOW}⚠ Updating Podfile platform to iOS 13.0...${NC}"
        sed -i '' "s/platform :ios, '[0-9]*\.[0-9]*'/platform :ios, '13.0'/g" ios/Podfile
        echo -e "${GREEN}✓ Podfile platform updated${NC}"
    fi
fi
echo ""

# Step 4: Get Flutter dependencies
echo -e "${BLUE}Step 4/7: Getting Flutter dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies fetched${NC}"
echo ""

# Step 5: Deintegrate CocoaPods
echo -e "${BLUE}Step 5/7: Deintegrating old CocoaPods...${NC}"
cd ios
if command -v pod &> /dev/null; then
    pod deintegrate --verbose
else
    echo -e "${YELLOW}⚠ CocoaPods not found. Installing...${NC}"
    sudo gem install cocoapods
fi
cd ..
echo -e "${GREEN}✓ Deintegration complete${NC}"
echo ""

# Step 6: Install CocoaPods
echo -e "${BLUE}Step 6/7: Installing CocoaPods (this may take a minute)...${NC}"
cd ios
pod install --repo-update
cd ..
echo -e "${GREEN}✓ CocoaPods installed${NC}"
echo ""

# Step 7: Final cleanup
echo -e "${BLUE}Step 7/7: Final cleanup of extended attributes...${NC}"
xattr -cr .
xattr -cr ios
echo -e "${GREEN}✓ Final cleanup complete${NC}"
echo ""

# Success message
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✓ All fixes applied successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Open Xcode workspace: ${YELLOW}open ios/Runner.xcworkspace${NC}"
echo -e "  2. Configure signing (if needed):"
echo -e "     - Select Runner → TARGETS → Runner"
echo -e "     - Go to Signing & Capabilities"
echo -e "     - Enable 'Automatically manage signing'"
echo -e "     - Select Team: Dylan Moses (JR2H3ZLP86)"
echo -e "  3. Close Xcode"
echo -e "  4. Run: ${YELLOW}flutter run --release${NC}"
echo ""
echo -e "${GREEN}🎉 Your app should build and deploy in 3-5 minutes!${NC}"
