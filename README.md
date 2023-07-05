# AnimeApp
### Change name
- Android

Open AndroidManifest.xml (located at android/app/src/main)
```xml
<application
    android:label="AnimeApp" ...> // Your app name here
```
- iOS

Open Info.plist (located at ios/Runner)
```xml
<key>CFBundleDisplayName</key>
<string>AnimeApp</string> // Your app name here
```
### Change icon
Sample:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_launcher_icons: "^0.13.1"
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/icon.png"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/images/icon.png"
```

Execute:
```bash
dart run flutter_launcher_icons -f pubspec.yaml
```
