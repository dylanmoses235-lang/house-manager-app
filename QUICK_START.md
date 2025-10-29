# 🚀 Quick Start - Build for iPhone

## For You (With Terminal & Xcode)

### Option 1: Automated Script (Easiest!)

```bash
# 1. Open Terminal
# 2. Navigate to your project
cd /path/to/house-manager-app

# 3. Run the build script
./build_for_iphone.sh
```

The script will:
- ✅ Check Flutter installation
- ✅ Detect your iPhone
- ✅ Install dependencies
- ✅ Build and install the app

---

### Option 2: Manual Steps (More Control)

#### Step 1: Open Terminal

```bash
# Navigate to project
cd /path/to/house-manager-app

# Install dependencies
flutter pub get
```

#### Step 2: Connect iPhone

- Plug in iPhone via USB
- Unlock iPhone
- Trust computer if prompted
- Check connection:

```bash
flutter devices
```

#### Step 3: Open Xcode

```bash
# Open the iOS project
open ios/Runner.xcworkspace
```

#### Step 4: Configure in Xcode

1. Click **Runner** (top left)
2. Select **Runner** under TARGETS
3. Go to **Signing & Capabilities** tab
4. ✅ Check "Automatically manage signing"
5. Select your **Apple ID** as Team
6. Change **Bundle Identifier** to: `com.yourname.housemanager`

#### Step 5: Build & Install

Back in Terminal:

```bash
# Build in release mode (optimized)
flutter run --release
```

Or in Xcode:
- Select your iPhone from device dropdown
- Click ▶ Play button

---

## ⚡ Super Quick Version

If Flutter is already installed and iPhone is connected:

```bash
cd house-manager-app
flutter pub get
flutter run --release
```

Then configure signing in Xcode when prompted.

---

## 🔧 If You Get Errors

### "Flutter command not found"

Install Flutter:
```bash
git clone https://github.com/flutter/flutter.git -b stable ~/development/flutter
export PATH="$PATH:$HOME/development/flutter/bin"
flutter doctor
```

### "No devices detected"

1. Connect iPhone via USB
2. Unlock iPhone
3. Trust computer
4. Enable Developer Mode (iOS 16+):
   - Settings → Privacy & Security → Developer Mode → ON

### "Signing error"

1. Open: `open ios/Runner.xcworkspace`
2. Runner → Signing & Capabilities
3. Select your Apple ID
4. Change Bundle ID to unique value

### "Untrusted Developer" on iPhone

1. Settings → General → VPN & Device Management
2. Trust your developer profile
3. Reopen app

---

## 📱 What You'll Get

Once installed, your iPhone will have:

- 🏠 Complete household management app
- 📊 Statistics & achievements
- ⏱️ Task timer
- 📅 Calendar view
- 🛒 Shopping lists
- 📝 Notes & photos
- 🔔 Notifications
- 🌙 Dark mode
- And all 13 features!

---

## 🎯 First Time Building?

**Estimated time:** 10-15 minutes
- Flutter installation: 5 min
- First build: 5-10 min
- Xcode signing: 1 min

**Next builds:** 1-2 minutes

---

## 💡 Pro Tips

1. **Keep iPhone unlocked** during first build
2. **Use release mode** for actual usage: `flutter run --release`
3. **Trust developer profile** on iPhone after first install
4. **Restart Xcode** if signing issues persist
5. **Check flutter doctor** if weird errors occur

---

## 🆘 Need Help?

Check **BUILD_GUIDE.md** for detailed instructions and troubleshooting.

---

## ✅ Success Checklist

- [ ] Flutter installed
- [ ] iPhone connected
- [ ] Xcode signing configured
- [ ] App builds successfully
- [ ] Developer profile trusted on iPhone
- [ ] App launches on iPhone

---

**You're ready to build! 🎉**

Run `./build_for_iphone.sh` or follow the manual steps above.
