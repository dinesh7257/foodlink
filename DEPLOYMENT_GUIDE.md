# FoodLink - Complete Deployment Guide

## Step-by-Step Deployment Instructions

### Phase 1: Environment Setup (30 minutes)

#### 1.1 Install Flutter

**Windows:**
```bash
# Download Flutter SDK
# Visit: https://docs.flutter.dev/get-started/install/windows

# Extract to C:\flutter
# Add to PATH: C:\flutter\bin

# Verify installation
flutter doctor
```

**Mac/Linux:**
```bash
# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:`pwd`/flutter/bin"

# Verify
flutter doctor
```

#### 1.2 Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android SDK (API 34)
3. Install Android Emulator
4. Accept licenses: `flutter doctor --android-licenses`

### Phase 2: Project Setup (15 minutes)

#### 2.1 Install Dependencies

```bash
cd food_app
flutter pub get
```

#### 2.2 Configure Google Maps

1. Go to: https://console.cloud.google.com/
2. Create new project "FoodLink"
3. Enable "Maps SDK for Android"
4. Create API Key
5. Update `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY_HERE"/>
   ```

### Phase 3: Testing (20 minutes)

#### 3.1 Run on Emulator

```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Or open Android Studio > AVD Manager > Start emulator

# Run app
flutter run
```

#### 3.2 Run on Physical Device

```bash
# Enable USB Debugging on Android device
# Settings > Developer Options > USB Debugging

# Connect device via USB
adb devices

# Run app
flutter run
```

### Phase 4: Build APK (10 minutes)

#### 4.1 Build Release APK

```bash
# Build APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk
```

#### 4.2 Build App Bundle (for Play Store)

```bash
flutter build appbundle --release

# Bundle location:
# build/app/outputs/bundle/release/app-release.aab
```

### Phase 5: Deploy to Device (5 minutes)

#### 5.1 Install APK on Device

**Method 1: USB**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Method 2: File Transfer**
1. Copy APK to device
2. Open file manager
3. Tap APK file
4. Allow "Install from Unknown Sources"
5. Install

### Phase 6: Backend Setup (Optional)

#### 6.1 Create Backend API

Sample Node.js backend structure:

```javascript
// server.js
const express = require('express');
const app = express();

app.get('/api/food-centers', (req, res) => {
  res.json([
    {
      id: '1',
      name: 'Amma Canteen',
      type: 'Government Canteen',
      latitude: 13.0827,
      longitude: 80.2707,
      address: 'Chennai, Tamil Nadu',
      phone: '+91-1234567890',
      operatingHours: '7 AM - 9 PM',
      isAvailable: true,
      isVerified: true
    }
  ]);
});

app.listen(3000);
```

#### 6.2 Update API Endpoint

In `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-domain.com/api';
```

### Phase 7: Google Play Store Deployment

#### 7.1 Prepare for Play Store

1. **Create Keystore:**
```bash
keytool -genkey -v -keystore foodlink-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias foodlink
```

2. **Create `android/key.properties`:**
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=foodlink
storeFile=../foodlink-key.jks
```

3. **Update `android/app/build.gradle`:**
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

4. **Build signed bundle:**
```bash
flutter build appbundle --release
```

#### 7.2 Play Store Submission

1. Go to: https://play.google.com/console
2. Create app "FoodLink"
3. Upload app bundle
4. Fill app details:
   - Title: FoodLink
   - Short description: Find free food near you
   - Full description: (Use project description)
   - Screenshots: (Take from emulator)
   - Category: Food & Drink
5. Set pricing: Free
6. Submit for review

### Phase 8: Testing Checklist

- [ ] App launches successfully
- [ ] Location permission works
- [ ] Map displays correctly
- [ ] Food centers list loads
- [ ] Search functionality works
- [ ] Voice search works
- [ ] Language switching works
- [ ] Phone call integration works
- [ ] Navigation to Google Maps works
- [ ] Offline mode works (airplane mode test)
- [ ] Alerts screen displays
- [ ] Settings save correctly

### Troubleshooting

**Issue: Flutter not found**
```bash
# Add to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

**Issue: Google Maps not showing**
- Check API key is correct
- Enable billing in Google Cloud
- Enable Maps SDK for Android

**Issue: Build fails**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Issue: App crashes on startup**
- Check AndroidManifest.xml permissions
- Verify minSdk is 21 or higher
- Check logs: `flutter logs`

### Performance Optimization

1. **Reduce APK size:**
```bash
flutter build apk --split-per-abi
```

2. **Enable ProGuard:**
In `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
    }
}
```

### Monitoring & Analytics

Add Firebase Analytics:
```bash
flutter pub add firebase_core firebase_analytics
```

### Support & Maintenance

- Monitor crash reports
- Update dependencies regularly: `flutter pub upgrade`
- Test on multiple devices
- Gather user feedback
- Release updates every 2-3 months

## Estimated Timeline

- Setup: 30 minutes
- Development: Already complete
- Testing: 20 minutes
- Build: 10 minutes
- Deployment: 5 minutes
- Play Store submission: 1-3 days review

## Cost Breakdown

- Flutter SDK: Free
- Android Studio: Free
- Google Maps API: Free (with limits)
- Play Store Developer Account: $25 one-time
- Backend hosting: $5-20/month (optional)

## Next Steps

1. Install Flutter
2. Run `flutter pub get`
3. Configure Google Maps API
4. Test on emulator
5. Build APK
6. Deploy to device
7. Submit to Play Store

Good luck with your deployment! 🚀
