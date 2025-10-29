#!/bin/bash

# House Manager - iOS Build Script
# This script helps build and install the app on your iPhone

echo "🏠 House Manager - iOS Build Script"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo -e "${BLUE}Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed!${NC}"
    echo ""
    echo "Please install Flutter first:"
    echo "1. Visit: https://flutter.dev/docs/get-started/install/macos"
    echo "2. Or run: git clone https://github.com/flutter/flutter.git -b stable"
    echo "3. Add Flutter to PATH"
    echo ""
    exit 1
else
    echo -e "${GREEN}✅ Flutter is installed${NC}"
    flutter --version
    echo ""
fi

# Check Flutter doctor
echo -e "${BLUE}Running Flutter doctor...${NC}"
flutter doctor
echo ""

# Check for connected devices
echo -e "${BLUE}Checking for connected iPhone...${NC}"
DEVICES=$(flutter devices)
echo "$DEVICES"
echo ""

if [[ $DEVICES == *"No devices detected"* ]]; then
    echo -e "${YELLOW}⚠️  No iPhone detected!${NC}"
    echo ""
    echo "Please connect your iPhone via USB and:"
    echo "1. Unlock your iPhone"
    echo "2. Trust this computer if prompted"
    echo "3. Enable Developer Mode (iOS 16+):"
    echo "   Settings → Privacy & Security → Developer Mode → ON"
    echo ""
    read -p "Press Enter when iPhone is connected..."
    echo ""
    flutter devices
    echo ""
fi

# Clean previous builds
echo -e "${BLUE}Cleaning previous builds...${NC}"
flutter clean
echo -e "${GREEN}✅ Clean complete${NC}"
echo ""

# Get dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Check if iOS pods need updating
echo -e "${BLUE}Checking CocoaPods...${NC}"
cd ios
if [ -f "Podfile" ]; then
    echo "Installing iOS dependencies..."
    pod install
    echo -e "${GREEN}✅ Pods installed${NC}"
else
    echo -e "${YELLOW}⚠️  No Podfile found (this is normal for some setups)${NC}"
fi
cd ..
echo ""

# Ask user for build type
echo -e "${YELLOW}Select build type:${NC}"
echo "1) Debug (faster build, hot reload enabled)"
echo "2) Release (optimized, recommended for actual use)"
echo ""
read -p "Enter choice (1 or 2): " BUILD_TYPE
echo ""

# Build and run
if [ "$BUILD_TYPE" == "2" ]; then
    echo -e "${BLUE}Building in RELEASE mode...${NC}"
    echo "This may take 5-10 minutes for the first build..."
    echo ""
    flutter run --release
else
    echo -e "${BLUE}Building in DEBUG mode...${NC}"
    echo "This may take 5-10 minutes for the first build..."
    echo ""
    flutter run
fi

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✅ BUILD SUCCESSFUL!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Your House Manager app should now be running on your iPhone!"
    echo ""
    echo "If you see 'Untrusted Developer' on your iPhone:"
    echo "1. Go to Settings → General → VPN & Device Management"
    echo "2. Trust your developer profile"
    echo "3. Reopen the app"
    echo ""
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}❌ BUILD FAILED${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo "Common issues:"
    echo ""
    echo "1. SIGNING ERROR:"
    echo "   - Open: ios/Runner.xcworkspace in Xcode"
    echo "   - Select Runner → Signing & Capabilities"
    echo "   - Check 'Automatically manage signing'"
    echo "   - Select your Team (Apple ID)"
    echo ""
    echo "2. NO DEVICE:"
    echo "   - Connect iPhone via USB"
    echo "   - Unlock and trust computer"
    echo "   - Enable Developer Mode (iOS 16+)"
    echo ""
    echo "3. COCOAPODS ERROR:"
    echo "   - Run: sudo gem install cocoapods"
    echo "   - Then: cd ios && pod install && cd .."
    echo ""
    echo "For detailed logs, check the output above."
    echo ""
fi
