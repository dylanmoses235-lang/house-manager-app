# 📱 Install House Manager on Your iPhone - Simple Guide

## 🎯 What You Need
- ✅ Mac computer
- ✅ iPhone with USB cable
- ✅ Xcode (free from App Store)
- ✅ Terminal (built into macOS)
- ✅ Apple ID (the one you use for iCloud)

**Time needed: 15-20 minutes (first time)**

---

## 📋 Step-by-Step Instructions

### **Step 1: Install Xcode** (if you haven't already)

1. Open **App Store** on your Mac
2. Search for **"Xcode"**
3. Click **Get** or **Install** (it's free!)
4. Wait for it to download (~12 GB, takes 10-30 minutes depending on internet)

After Xcode installs, open **Terminal** and run:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

(Type your Mac password when prompted, press **space** to scroll through license, type **agree**)

---

### **Step 2: Install Flutter SDK**

Open **Terminal** and paste these commands one by one:

```bash
# Create a development folder
mkdir -p ~/development
cd ~/development

# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable
cd flutter

# Add Flutter to your system PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc

# Reload your terminal settings
source ~/.zshrc

# Check if Flutter is working
flutter doctor
```

You'll see a list of what's installed. ✅ means good, ❌ means needs fixing.

---

### **Step 3: Install CocoaPods** (Required for iOS)

In **Terminal**, run:

```bash
sudo gem install cocoapods
```

(Type your Mac password when prompted)

---

### **Step 4: Get Your App Code**

If you **already have the folder** on your Mac, skip to Step 5.

Otherwise, in **Terminal**:

```bash
# Go to your Documents folder (or wherever you want it)
cd ~/Documents

# Download the app code
git clone https://github.com/dylanmoses235-lang/house-manager-app.git

# Go into the app folder
cd house-manager-app

# Install dependencies
flutter pub get
```

---

### **Step 5: Setup iOS Project in Xcode**

In **Terminal**, navigate to your project folder:

```bash
# If you're not already there:
cd ~/Documents/house-manager-app

# Open the iOS project in Xcode
open ios/Runner.xcworkspace
```

**Xcode will open.** Now in Xcode:

1. Click **"Runner"** in the left sidebar (blue icon at the very top)
2. In the main area, make sure **"Runner"** is selected under **TARGETS**
3. Click the **"Signing & Capabilities"** tab at the top
4. You'll see a section called **"Signing"**

#### Configure Signing:

- **Check the box** ✅ for **"Automatically manage signing"**
- Under **"Team"**, click the dropdown:
  - If you see your name/Apple ID, select it
  - If you DON'T see it, click **"Add Account..."** and sign in with your Apple ID
  - After signing in, select your Personal Team
  
- Under **"Bundle Identifier"**, change it to something unique:
  ```
  Change from: com.example.houseManager
  To: com.yourname.housemanager
  ```
  (Use lowercase, no spaces - like: `com.dylan.housemanager`)

**Keep Xcode open!**

---

### **Step 6: Connect Your iPhone**

1. **Connect your iPhone** to your Mac with USB cable
2. **Unlock your iPhone**
3. You'll see a pop-up on iPhone saying **"Trust This Computer?"** → Tap **Trust**
4. Enter your iPhone passcode

#### Enable Developer Mode (iOS 16+):

On your iPhone:
1. Go to **Settings** → **Privacy & Security** → **Developer Mode**
2. Turn **Developer Mode ON**
3. Your iPhone will restart - that's normal!
4. After restart, unlock and confirm Developer Mode again

---

### **Step 7: Select Your iPhone in Xcode**

Back in **Xcode**:

1. Look at the top toolbar - you'll see device selector dropdown (usually says "Any iOS Device" or similar)
2. Click that dropdown
3. Find and select **your iPhone's name**

---

### **Step 8: Build and Install**

You have **two options**:

#### **Option A: Using Terminal** (Recommended - easier to see progress)

In **Terminal**:

```bash
# Make sure you're in the project folder
cd ~/Documents/house-manager-app

# Build and install on your iPhone
flutter run --release
```

This takes **5-10 minutes** the first time. You'll see lots of text scrolling - that's normal!

When you see **"✓ Built..."** and the app opens on your iPhone, it worked! 🎉

---

#### **Option B: Using Xcode**

In **Xcode**:

1. Make sure your iPhone is selected at the top (from Step 7)
2. Click the **▶️ Play button** at the top left
3. Wait for the build to complete (5-10 minutes first time)
4. The app will install on your iPhone

---

### **Step 9: Trust Developer Certificate on iPhone**

When you try to open the app on your iPhone, you'll see:

**"Untrusted Enterprise Developer"** or similar message

To fix this:

1. On your iPhone, go to **Settings** → **General** → **VPN & Device Management**
2. Under "Developer App", find your Apple ID or email
3. Tap it
4. Tap **"Trust [Your Name]"**
5. Tap **"Trust"** again to confirm

Now go back to your home screen and **open the House Manager app** - it will work! 🎉

---

## ✅ You're Done!

The app is now installed on your iPhone! 

### What You Can Do Now:

- ✅ View your **Daily Essentials** checklist (dishes, counters, dog bowls, etc.)
- ✅ See **Today's Zone Deep-Clean** tasks
- ✅ Check off completed tasks
- ✅ Track your progress and streaks
- ✅ Use the 30-day declutter challenge
- ✅ View your daily schedule

---

## 🔄 Updating the App Later

When there are updates or you make changes:

```bash
cd ~/Documents/house-manager-app
git pull origin main
flutter run --release
```

Takes only 1-2 minutes after the first build!

---

## 🔧 Troubleshooting

### "Flutter: command not found"
Your PATH isn't set up. Run:
```bash
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
flutter doctor
```

### "No devices found"
1. Make sure iPhone is **unlocked**
2. **Trust the computer** (check iPhone screen)
3. **Enable Developer Mode** (Settings → Privacy & Security → Developer Mode)
4. Try unplugging and reconnecting the cable
5. Check if iPhone appears:
   ```bash
   flutter devices
   ```

### "Signing error" in Xcode
1. Make sure you selected your **Team** in Signing & Capabilities
2. Change the **Bundle Identifier** to something unique
3. Try cleaning:
   ```bash
   flutter clean
   flutter pub get
   ```

### "CocoaPods not installed"
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### Build is stuck or taking forever
```bash
# Clean everything and start fresh
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run --release
```

### "Certificate not trusted"
Follow Step 9 again - you need to trust the developer certificate on your iPhone in Settings.

---

## 💡 Pro Tips

### Building Faster:
- First build: 5-10 minutes
- Subsequent builds: 1-2 minutes
- Keep iPhone connected and Xcode open for faster rebuilds

### Debugging:
```bash
# Check Flutter setup
flutter doctor

# Check connected devices
flutter devices

# See detailed build logs
flutter run --verbose
```

### Keeping iPhone Awake:
- In Xcode, select **Product** → **Scheme** → **Edit Scheme**
- Under **Run** → **Options**, check ✅ **"Keep Screen Awake"**

---

## 📞 Still Need Help?

Run this diagnostic:
```bash
flutter doctor -v
```

This shows exactly what's working and what needs fixing.

Common issues:
- ❌ **Xcode** → Install from App Store
- ❌ **CocoaPods** → Run `sudo gem install cocoapods`
- ❌ **iOS deployment** → Connect iPhone, trust computer, enable Developer Mode
- ❌ **Signing** → Configure in Xcode (Step 5)

---

## 🎉 Success Checklist

After following this guide:

- ✅ Xcode installed
- ✅ Flutter SDK installed and working (`flutter doctor` shows mostly ✅)
- ✅ CocoaPods installed
- ✅ Project code downloaded
- ✅ Xcode signing configured with your Apple ID
- ✅ iPhone connected and trusted
- ✅ Developer Mode enabled on iPhone
- ✅ App built and installed
- ✅ Developer certificate trusted on iPhone
- ✅ App opens and runs!

---

**🏠 Welcome to House Manager!**

Your cleaning routine is about to get WAY easier with the new Daily Essentials + Zone Deep-Cleaning system! 

No more dish pileup! 🍽️✨

---

**Questions?** Check the detailed guides:
- `BUILD_FOR_IPHONE.md` - Comprehensive guide
- `SIMPLE_BUILD_INSTRUCTIONS.md` - Quick reference
- `NEW_CLEANING_SYSTEM_EXPLAINED.md` - How the new system works
