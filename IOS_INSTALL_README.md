# 🏠 House Manager - iOS Installation

## 🚀 Ready to Install on Your iPhone!

All dependency issues have been fixed. The app is ready to build and install!

---

## ⚡ Quick Start (3 Guides Available)

Choose the guide that fits your needs:

### 1. 📋 **INSTALLATION_CHECKLIST.md** - Start Here!
- Interactive checklist with checkboxes
- Perfect for first-time installation
- Tracks your progress step-by-step
- Clear success criteria

### 2. 📖 **INSTALL_ON_IPHONE_FIXED.md** - Complete Guide  
- Full detailed instructions
- Xcode setup and configuration
- Comprehensive troubleshooting
- Time estimates for each step

### 3. ⚡ **QUICK_INSTALL_COMMANDS.md** - Fast Reference
- Copy-paste terminal commands
- One-line update command
- Quick error fixes
- For repeat installations

---

## 🎯 Super Quick Install (If You Know What You're Doing)

```bash
cd ~/Documents/house-manager-app
git pull origin main
flutter clean && rm -rf ios/Pods ios/Podfile.lock
flutter pub get && cd ios && pod install && cd ..
flutter run --release
```

⏱️ Takes 5-10 minutes

---

## ✅ What's Fixed

The following issues have been resolved:

✅ **google_mlkit_text_recognition** dependency conflict → Commented out  
✅ **mobile_scanner** GoogleUtilities conflict → Commented out  
✅ **json_serializable** version conflict → Downgraded to 6.8.0  
✅ Pod install errors → Fixed  
✅ iOS build errors → Fixed  

All core features still work:
- ✅ Daily tasks tracking
- ✅ Zone-based cleaning  
- ✅ Progress statistics
- ✅ Photo tracking
- ✅ Cloud sync
- ✅ Notifications

Temporarily disabled (non-essential):
- ⚠️ Receipt scanning (can re-enable later)
- ⚠️ Barcode scanning (can re-enable later)

---

## 📋 Prerequisites

Before installing, make sure you have:

- ✅ **Mac computer** (required for iOS development)
- ✅ **Xcode** installed from App Store
- ✅ **Flutter SDK** installed and in PATH
- ✅ **iPhone** with USB cable
- ✅ **Apple ID** (free, no paid account needed)

---

## 🎉 What You'll Get

### Daily Essentials (Every Day)
- 🍽️ Wash all dishes
- 🧽 Clear & wipe counters  
- 🐕 Clean dog bowls
- 🗑️ Take out trash
- 🧹 Quick floor sweep
- 🚽 Bathroom quick-clean
- 👔 One load of laundry

**No more pileup!** These tasks prevent dishes, laundry, and trash from accumulating over days.

### Zone Deep-Cleaning (Rotating Daily)
- Monday: Kitchen deep-clean
- Tuesday: Bathroom deep-clean
- Wednesday: Bedroom deep-clean
- Thursday: Living Room deep-clean
- Friday: Laundry Room deep-clean
- Saturday: Office deep-clean
- Sunday: Reset day

---

## 🚨 Common Issues & Fixes

### "No devices found"
- Unlock iPhone
- Trust computer (check for iPhone popup)
- Run: `flutter devices`

### "Certificate not trusted"  
On iPhone:
1. Settings → General → VPN & Device Management
2. Tap your Apple ID
3. Tap "Trust"

### Build fails
```bash
cd ~/Documents/house-manager-app
flutter clean
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
flutter pub get
cd ios
pod deintegrate && pod install
cd ..
flutter run --release
```

---

## 📞 Need Help?

1. **Start with**: INSTALLATION_CHECKLIST.md
2. **Detailed guide**: INSTALL_ON_IPHONE_FIXED.md
3. **Quick commands**: QUICK_INSTALL_COMMANDS.md

---

## 🔗 Pull Request

All changes are in PR #3:
https://github.com/dylanmoses235-lang/house-manager-app/pull/3

Includes:
- Daily Essentials system
- Zone Deep-Cleaning schedule
- iOS build fixes
- Complete installation documentation

---

## ⏱️ Time Estimates

| Task | First Time | Updates |
|------|-----------|---------|
| Xcode install | 30-45 min | - |
| Flutter install | 5-10 min | - |
| First build | 10-15 min | 5-10 min |
| Future updates | - | 2-3 min |

---

## 🎯 Installation Flow

1. **Setup** (One-time)
   - Install Xcode
   - Install Flutter
   - Clone repository

2. **Configure** (One-time)
   - Open in Xcode
   - Set Team and Bundle ID

3. **Build** (Every time)
   ```bash
   flutter run --release
   ```

4. **Trust** (First time only)
   - Trust developer on iPhone

5. **Done!** 🎉
   - App installs and launches

---

Ready to get started? Open **INSTALLATION_CHECKLIST.md** and let's do this! 🚀
