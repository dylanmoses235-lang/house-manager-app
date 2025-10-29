# 🚀 Simple Build Instructions

## You're in the right place! Just follow these steps:

### Step 1: Pull Latest Changes

```bash
git pull origin main
```

This will download the build script and all new features.

### Step 2: Install Flutter (if not already installed)

Check if Flutter is installed:
```bash
flutter --version
```

If you get "command not found", install Flutter:

```bash
# Install Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
cd flutter
export PATH="$PATH:`pwd`/bin"

# Add to your shell config (so it persists)
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc

# Reload shell
source ~/.zshrc

# Verify installation
flutter doctor
```

### Step 3: Install Dependencies

```bash
# Make sure you're in the house-manager-app folder
cd ~/house-manager-app  # or wherever your project is

# Install project dependencies
flutter pub get
```

### Step 4: Connect Your iPhone

1. Connect iPhone via USB cable
2. Unlock your iPhone
3. Trust the computer (prompt on iPhone)
4. If iOS 16+, enable Developer Mode:
   - Settings → Privacy & Security → Developer Mode → ON
   - Restart iPhone when prompted

Check if iPhone is detected:
```bash
flutter devices
```

You should see your iPhone listed.

### Step 5: Configure Signing in Xcode

```bash
# Open the iOS project in Xcode
open ios/Runner.xcworkspace
```

In Xcode:
1. Click **"Runner"** in the left sidebar (top item)
2. Select **"Runner"** under TARGETS
3. Click **"Signing & Capabilities"** tab
4. Check ✅ **"Automatically manage signing"**
5. Under **"Team"**, select your Apple ID
6. Under **"Bundle Identifier"**, change to something unique like:
   - `com.dylanmoses.housemanager`
   - (Use your name/email to make it unique)

### Step 6: Build and Install

Back in Terminal:

```bash
# Clean any previous builds
flutter clean

# Get dependencies again
flutter pub get

# Build and install on iPhone (this takes 5-10 min first time)
flutter run --release
```

### Step 7: Trust Developer on iPhone

After the app installs, you'll see "Untrusted Developer" on iPhone:

1. On iPhone: Settings → General → VPN & Device Management
2. Find your developer certificate
3. Tap "Trust"
4. Confirm

Now open the app - it will work! 🎉

---

## 🎯 Quick Commands (After Setup)

Once everything is set up, building again is simple:

```bash
cd house-manager-app
flutter run --release
```

That's it! Takes 1-2 minutes after the first build.

---

## 🔧 If You Get Errors

### "Flutter command not found"
→ Install Flutter (see Step 2 above)

### "No devices detected"
→ Connect iPhone, unlock, trust computer, enable Developer Mode

### "Signing error"
→ Follow Step 5 to configure signing in Xcode

### CocoaPods error
```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

### Build fails
```bash
# Clean and retry
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run --release
```

---

## ✅ What You Need

- ✅ Xcode (you have it!)
- ✅ Terminal (you're using it!)
- ✅ Flutter SDK (install if needed)
- ✅ iPhone + USB cable
- ✅ Apple ID (free works!)

---

## 📞 Need Help?

Run this to check your setup:
```bash
flutter doctor
```

It will tell you what's missing.

---

**Time Estimate:**
- Flutter install: 5 minutes
- First build: 5-10 minutes
- **Total: ~15 minutes**

After that, rebuilding takes only 1-2 minutes!

🚀 You're ready to build!
