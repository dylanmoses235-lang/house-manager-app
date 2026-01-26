#!/bin/bash

# House Manager - iPhone Build Script
# This script helps you build and deploy the app to your iPhone

set -e

echo "🏠 House Manager - iPhone Build Script"
echo "======================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo "Please install Flutter first: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check if in correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Not in project directory!"
    echo "Please run this script from the house-manager-app directory"
    exit 1
fi

echo "📦 Getting Flutter dependencies..."
flutter pub get
echo ""

echo "🧹 Cleaning previous builds..."
flutter clean
echo ""

echo "📱 Available devices:"
flutter devices
echo ""

echo "🔨 Building for iPhone..."
echo ""
echo "Choose build method:"
echo "1) Build and run on connected iPhone (recommended)"
echo "2) Build release IPA file"
echo "3) Open in Xcode"
echo ""

read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Building and installing on iPhone..."
        echo "Make sure your iPhone is connected and trusted!"
        echo ""
        flutter run --release
        ;;
    2)
        echo ""
        echo "📦 Building release IPA..."
        flutter build ios --release
        echo ""
        echo "✅ Build complete! IPA location:"
        echo "   build/ios/iphoneos/Runner.app"
        ;;
    3)
        echo ""
        echo "🔧 Opening in Xcode..."
        open ios/Runner.xcworkspace
        echo ""
        echo "ℹ️  In Xcode:"
        echo "   1. Select your iPhone as target"
        echo "   2. Click the ▶️ Play button to build and run"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✨ Done!"
echo ""
echo "📝 Remember to trust the developer certificate on your iPhone:"
echo "   Settings → General → VPN & Device Management"
echo ""
