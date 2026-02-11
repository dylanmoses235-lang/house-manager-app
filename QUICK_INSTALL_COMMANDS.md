# 🚀 Quick iOS Install Commands

## ⚡ Copy-Paste These Commands in Order

### 1. Navigate to Project
```bash
cd ~/Documents/house-manager-app
```

### 2. Get Latest Code
```bash
git pull origin main
```

### 3. Clean Previous Builds
```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
```

### 4. Install Flutter Dependencies
```bash
flutter pub get
```

### 5. Install iOS Dependencies
```bash
cd ios
pod install
cd ..
```

### 6. Connect iPhone and Build
```bash
# Check if iPhone is detected
flutter devices

# Build and install (takes 5-10 minutes first time)
flutter run --release
```

---

## 🎯 One-Line Command (After Initial Setup)

```bash
cd ~/Documents/house-manager-app && git pull origin main && flutter clean && rm -rf ios/Pods ios/Podfile.lock && flutter pub get && cd ios && pod install && cd .. && flutter run --release
```

---

## ⚠️ If Build Fails

### Error: "No devices found"
- Unlock your iPhone
- Trust the computer (popup on iPhone)
- Try: `flutter devices`

### Error: "Certificate not trusted"  
On iPhone:
1. Settings → General → VPN & Device Management
2. Tap your Apple ID under "Developer App"
3. Tap "Trust"

### Error: Xcode problems
```bash
# Force clean everything
cd ~/Documents/house-manager-app
flutter clean
rm -rf build ios/Pods ios/Podfile.lock ios/.symlinks ios/Flutter/Flutter.framework
flutter pub get
cd ios
pod deintegrate
pod install
cd ..
flutter run --release
```

---

## ✅ Success Indicators

During build, you should see:
```
✓ Built build/ios/iphoneos/Runner.app
Installing and launching...
Success!
```

The app will automatically launch on your iPhone!

---

## 📱 First Launch Setup

On your iPhone after installation:

1. **Trust the Developer**
   - Settings → General → VPN & Device Management
   - Tap your Apple ID → Trust

2. **Enable Notifications** (when prompted)
   - Allows cleaning reminders

3. **Allow Photos** (when prompted)  
   - For progress photo tracking

4. **Start Using the App!**
   - Daily Tasks tab shows your essentials
   - Deep Clean tab shows today's zone
   - Stats tab tracks your progress

---

## 🔄 Future Updates

To update the app later:

```bash
cd ~/Documents/house-manager-app
git pull origin main
flutter run --release
```

That's it! Only takes 2-3 minutes for updates.

---

## 📞 Need Help?

If you get stuck:
1. Check the full guide: **INSTALL_ON_IPHONE_FIXED.md**
2. Check error messages carefully
3. Try the "If Build Fails" section above
4. Make sure Xcode is fully installed

---

## ⏱️ Time Estimates

| Task | Time |
|------|------|
| First-time full install | ~60 min |
| Building the app (first) | 10-15 min |
| Building the app (after) | 5-10 min |
| Future updates | 2-3 min |

Most time is waiting for downloads and compilation!
