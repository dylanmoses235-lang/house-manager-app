# 🚀 Quick Start for Mac Terminal

## Copy & Paste These Commands:

### Step 1: Navigate to Your Project
```bash
cd ~/house-manager-app
# OR wherever you keep your project
```

### Step 2: Pull the Latest Code (WITH CUSTOM ZONES FIX!)
```bash
git pull origin main
```

### Step 3: Update Dependencies
```bash
flutter pub get
```

### Step 4: Clean Previous Builds
```bash
flutter clean
```

### Step 5: Connect Your iPhone/iPad
- Connect via USB
- Unlock your device
- Tap "Trust" when prompted
- Enable Developer Mode (iOS 16+): Settings → Privacy & Security → Developer Mode

### Step 6: Run on Your Device
```bash
flutter run
```

That's it! 🎉

---

## 🎯 One-Line Command (All Steps)

```bash
cd ~/house-manager-app && git pull origin main && flutter clean && flutter pub get && flutter run
```

---

## 📱 Using Xcode Instead?

```bash
cd ~/house-manager-app/ios && open Runner.xcworkspace
```

Then click the ▶️ Run button in Xcode!

---

## ✨ New Features You'll See:

1. **Custom zones in dropdown** - Tap the filter icon in Zone Cleaning
2. **Add tasks button (➕)** - In the top right of Zone Cleaning screen
3. **Custom zones in schedule** - Check your Dashboard and Calendar

---

## ⚠️ Troubleshooting

**Device not showing up?**
```bash
flutter devices
```

**Build errors?**
```bash
cd ios && pod install && cd ..
flutter clean && flutter pub get
```

**App crashes?**
- Delete the old app from your device first
- Then run `flutter run` again

---

**Need the full guide?** Check `IOS_SETUP_INSTRUCTIONS.md`
