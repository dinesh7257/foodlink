# FoodLink - Mobile App

A low-connectivity multilingual food access platform for daily wage workers to locate affordable or free food resources.

## Features

✅ **Offline-First Architecture** - Works without internet using local SQLite database
✅ **Multilingual Support** - English, Hindi, Tamil, Telugu, Kannada
✅ **Voice Search** - Find food centers using voice commands
✅ **Map & List View** - Visual and text-based food center discovery
✅ **Real-time Alerts** - Emergency food distribution notifications
✅ **Distance Calculation** - Shows nearest food centers
✅ **Call & Navigate** - Direct phone calls and Google Maps integration
✅ **Filter by Type** - Government canteens, NGOs, community kitchens, etc.

## Installation Steps

### Prerequisites

1. **Install Flutter SDK**
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH
   - Run: `flutter doctor` to verify installation

2. **Install Android Studio**
   - Download from: https://developer.android.com/studio
   - Install Android SDK and emulator

### Setup Instructions

1. **Clone/Navigate to project directory**
   ```bash
   cd food_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Google Maps API**
   - Get API key from: https://console.cloud.google.com/
   - Enable Maps SDK for Android
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`

4. **Run the app**
   ```bash
   # Connect Android device or start emulator
   flutter devices
   
   # Run app
   flutter run
   ```

5. **Build APK for deployment**
   ```bash
   flutter build apk --release
   ```
   APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── food_center.dart      # Food center data model
├── providers/
│   ├── food_provider.dart    # Food data state management
│   ├── location_provider.dart # Location services
│   └── language_provider.dart # Multilingual support
├── screens/
│   ├── splash_screen.dart    # Loading screen
│   ├── home_screen.dart      # Main navigation
│   ├── list_screen.dart      # Food centers list
│   ├── map_screen.dart       # Map view
│   ├── alerts_screen.dart    # Notifications
│   ├── settings_screen.dart  # App settings
│   └── food_center_detail_screen.dart
├── services/
│   ├── database_service.dart # SQLite operations
│   └── api_service.dart      # Network calls
├── widgets/
│   ├── food_center_card.dart # List item widget
│   ├── filter_chips.dart     # Category filters
│   └── voice_search_button.dart # Voice input
└── utils/
    └── app_localizations.dart # Translation helper

assets/
└── lang/
    ├── en.json              # English translations
    ├── hi.json              # Hindi translations
    └── ta.json              # Tamil translations
```

## Key Technologies

- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **SQLite** - Offline data storage
- **Google Maps** - Location services
- **Speech-to-Text** - Voice commands
- **Flutter TTS** - Text-to-speech for accessibility

## Deployment

### Android APK

```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### Testing on Device

```bash
# Install on connected device
flutter install

# Or use ADB directly
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Backend Integration

Update `lib/services/api_service.dart` with your backend API:

```dart
static const String baseUrl = 'https://your-api-endpoint.com/api';
```

## Permissions Required

- Internet access
- Location (GPS)
- Microphone (voice search)
- Camera (QR scanning - future feature)

## Troubleshooting

**Flutter not recognized:**
```bash
# Add to PATH (Windows)
setx PATH "%PATH%;C:\flutter\bin"
```

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**Google Maps not showing:**
- Verify API key is correct
- Enable Maps SDK in Google Cloud Console
- Check billing is enabled

## Future Enhancements

- SMS/USSD fallback for feature phones
- QR token system for food distribution
- AI-driven food shortage predictions
- Crowd-sourced reporting
- Integration with government welfare schemes

## License

MIT License - Free to use and modify

## Contact

For support or contributions, contact the development team.
