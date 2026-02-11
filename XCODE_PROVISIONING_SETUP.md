# Xcode Provisioning Profile Setup Guide

## Current Issue
- **Error**: "No provisioning profile for Runner"
- **Certificate Issue**: Bad certificate (070528733D7BEC375CDF0729424D21C6C7AD7615) has been deleted
- **Good Certificate**: 946EE24BB58F45CEAB3A9ACF4DAF626B0923ED11
- **Team**: JR2H3ZLP86 (Dylan Moses)
- **Device**: Dylan's iPhone
- **Bundle ID**: com.dylan.housemanager

---

## Step-by-Step Fix (Follow Exactly)

### Step 1: Open Xcode Workspace
```bash
cd ~/Documents/house-manager-app
open ios/Runner.xcworkspace
```

**⚠️ IMPORTANT**: Wait for Xcode to fully load (15-30 seconds)

---

### Step 2: Configure Signing in Xcode

1. **Select the Project**:
   - In the left sidebar (Project Navigator), click on the **blue Runner icon** (top item)

2. **Select the Target**:
   - In the main panel, under "TARGETS", select **Runner** (the one with the app icon, not "PROJECTS")

3. **Go to Signing & Capabilities Tab**:
   - Click the **"Signing & Capabilities"** tab at the top of the main panel

4. **Configure Automatic Signing**:
   - ✅ Check **"Automatically manage signing"**
   - **Team**: Select **"Dylan Moses (JR2H3ZLP86)"** from dropdown
   - **Bundle Identifier**: Should show **"com.dylan.housemanager"**

5. **Wait for Provisioning**:
   - Xcode will display a spinner: "Downloading provisioning profile..."
   - This takes **5-15 seconds**
   - You'll see: ✅ "iOS Team Provisioning Profile: com.dylan.housemanager"

6. **Check for Errors**:
   - **No red errors** should appear in the "Signing & Capabilities" section
   - If you see "Register Device" warning, continue to Step 3

---

### Step 3: Register Your iPhone (If Needed)

If you see a "Register Device" error or warning:

1. **Open Devices Window**:
   - Menu: **Window** → **Devices and Simulators** (or press **Shift+Cmd+2**)

2. **Find Your iPhone**:
   - In the left sidebar under "Devices", you should see **"Dylan's iPhone"**
   - If it shows a yellow ⚠️ warning icon, proceed to next step

3. **Enable for Development**:
   - **Connect your iPhone** via USB (if not already)
   - Unlock your iPhone
   - On iPhone: Trust the computer if prompted
   - In Xcode: Right-click **"Dylan's iPhone"** → **"Use for Development"**
   - Wait 10-30 seconds for processing

4. **Verify Registration**:
   - Device status should change to ✅ "Connected"
   - Close the Devices window

5. **Return to Signing**:
   - Go back to **Runner target** → **Signing & Capabilities**
   - Provisioning profile should now appear without errors

---

### Step 4: Verify Signing Configuration

Before closing Xcode, verify these settings:

#### Debug Configuration
- **Signing Certificate**: Apple Development
- **Provisioning Profile**: iOS Team Provisioning Profile: com.dylan.housemanager
- **Team**: Dylan Moses (JR2H3ZLP86)

#### Release Configuration
- Scroll down to **"Release"** section
- Same settings should apply:
  - ✅ Automatically manage signing
  - **Team**: Dylan Moses (JR2H3ZLP86)
  - **Provisioning Profile**: iOS Team Provisioning Profile: com.dylan.housemanager

---

### Step 5: Close Xcode and Build

1. **Save Changes**: Press **Cmd+S** to save
2. **Quit Xcode**: Press **Cmd+Q** (don't just close the window)

3. **Clean and Build**:
```bash
cd ~/Documents/house-manager-app
flutter clean
flutter run
```

---

## Expected Terminal Output

After `flutter run`, you should see:

```
Launching lib/main.dart on Dylan's iPhone in debug mode...
Running pod install...                                              4.5s
Running Xcode build...
 └─Compiling, linking and signing...                                8.2s
Xcode build done.                                           52.3s
Installing and launching...                                         3.1s
Syncing files to device Dylan's iPhone...                          123ms

Flutter run key commands.
r Hot reload. 🔥🔥🔥
```

---

## Common Issues & Solutions

### Issue 1: "Register Device" Error Persists
**Solution**:
- In Xcode: Window → Devices and Simulators
- Select your iPhone → Right-click → "Unpair Device"
- Disconnect and reconnect iPhone
- Retry: "Use for Development"

### Issue 2: "Certificate Not Valid" or "Expired"
**Solution**:
```bash
# Check certificate validity
security find-identity -v -p codesigning

# If both certificates expired, regenerate in Xcode:
# Xcode → Preferences → Accounts → Select Apple ID → Manage Certificates → + → Apple Development
```

### Issue 3: "Bundle ID Already in Use"
**Solution**:
- Change Bundle Identifier in Xcode:
  - Runner → General → Bundle Identifier
  - Change to: `com.dylan.housemanager.app` or `com.dylan.housemanager2`
- Update in `ios/Runner.xcodeproj/project.pbxproj` as well

### Issue 4: "App Already Installed with Different Signature"
**Solution**:
- Uninstall the app from your iPhone:
  - Long-press the app icon → Remove App
  - Or in Xcode: Window → Devices → Apps → select Runner → Remove (-)
- Retry `flutter run`

---

## Debug Mode vs Release Mode

### Use Debug Mode (Recommended for Development)
```bash
flutter run
```
- Faster build times
- Hot reload enabled
- Easier debugging
- Same functionality

### Use Release Mode (For Testing Performance)
```bash
flutter run --release
```
- Optimized performance
- No hot reload
- Longer build times

---

## Verification Checklist

After following the steps above, verify:

- ✅ Xcode shows no red errors in Signing & Capabilities
- ✅ Provisioning profile displays: "iOS Team Provisioning Profile: com.dylan.housemanager"
- ✅ `flutter run` completes without signing errors
- ✅ App installs on Dylan's iPhone
- ✅ App launches successfully

---

## Next Steps After Successful Deployment

Once the app is running on your device, the remaining code issues can be addressed:

1. **Dependency Resolution** (optional):
   - `google_mlkit_text_recognition` is commented out (not blocking)
   - Run `flutter pub outdated` to see available updates

2. **Code Quality** (optional):
   - UI errors in `zone_screen.dart` and `daily_tasks_screen.dart` were fixed in commits 8c71f24 and a65760b
   - Verify by testing the app functionality

3. **API Implementation** (if needed):
   - `HouseService.getAllZoneTaskCompletions` - check if actually used in the app

---

## Quick Reference Commands

```bash
# Navigate to project
cd ~/Documents/house-manager-app

# Open Xcode workspace
open ios/Runner.xcworkspace

# Clean and rebuild
flutter clean
flutter run

# Check certificates
security find-identity -v -p codesigning

# View connected devices
flutter devices
```

---

## Support Resources

- [Flutter iOS Deployment](https://flutter.dev/docs/deployment/ios)
- [Apple Developer Portal](https://developer.apple.com)
- [Xcode Code Signing Guide](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution)

---

**Created**: 2026-02-11  
**Project**: house-manager-app  
**Branch**: main  
**Team**: Dylan Moses (JR2H3ZLP86)  
**Device**: Dylan's iPhone
