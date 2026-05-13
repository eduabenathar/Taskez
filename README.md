# Taskez
<p align="center">A productivity mobile application UI kit built with Flutter</p>
<h3 align="center">Designs and inspiration by <a href="https://www.behance.net/gallery/108149857/TaskEz-Productivity-App-iOS-UI-Kit"> Taskez IOS UI kit.</a></h3>
<div align="center"> <a href="https://play.google.com/store/apps/details?id=com.taskez.io" target="_blank"><img src="screenshots/playstore.png"/></a></div> 
<h3 align="center"> Application Flow - <a href="https://youtu.be/VpYzfUInOYE">Youtube</a></h3>

### Show some :heart: and star the repo to support the project

[![GitHub stars](https://img.shields.io/github/stars/Davies-K/Taskez.svg?style=social&label=Star)](https://github.com/Davies-K/Taskez) [![GitHub forks](https://img.shields.io/github/forks/Davies-K/Taskez.svg?style=social&label=Fork)](https://github.com/Davies-K/Taskez/fork) [![GitHub watchers](https://img.shields.io/github/watchers/Davies-K/Taskez.svg?style=social&label=Watch)](https://github.com/Davies-K/Taskez) [![GitHub followers](https://img.shields.io/github/followers/Davies-K.svg?style=social&label=Follow)](https://github.com/Davies-K/Taskez)
[![Twitter Follow](https://img.shields.io/twitter/follow/SterlinJohn.svg?style=social)](https://twitter.com/@SterlinJohn)

<p><a href="https://www.buymeacoffee.com/davieskwarteng" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a></p> 

<div>
  <p>Screenshots</p>
  <p align="center">
  <img src="screenshots/sample-1.png" width="100%" title="sample-1">
  <img src="screenshots/sample-2.png" width="100%" title="sample-2">
  </p>
</div>
<a href="https://www.behance.net/gallery/108149857/TaskEz-Productivity-App-iOS-UI-Kit"> Taskez UI Designs.</a>
<p align="center">
  <!-- <img src="screenshots/screenshot-1.png" width="100%" title="homescreen1"> -->
  <img src="screenshots/screenshot-2.png" width="100%" title="homescreen2">
  <img src="screenshots/screenshot-3.png" width="100%" title="homescreen3">
  <img src="screenshots/screenshot-4.png" width="100%" title="homescreen4">
  <img src="screenshots/screenshot-5.png" width="100%" title="homescreen5">
  <img src="screenshots/screenshot-6.png" width="100%" title="homescreen6">
  <img src="screenshots/screenshot-7.png" width="100%" title="homescreen7">
  <img src="screenshots/screenshot-8.png" width="100%" title="homescreen8">
</p>


## iPhone Release Install (Flutter)

Use this flow to install on a physical iPhone in release mode (not debug):

```bash
flutter clean
flutter pub get
flutter devices
flutter run --release -d <IPHONE_DEVICE_ID>
```

Example:

```bash
flutter run --release -d 00008101-00126C8A0A38001E
```

Notes:
- Keep the iPhone unlocked and connected by cable.
- If signing fails, open `ios/Runner.xcworkspace` in Xcode and set your Team in `Runner > Signing & Capabilities`.

## Samsung Galaxy S9 Release Install (Flutter)

### 1) Prepare macOS environment (Android)

Install Android Studio, then in Android Studio install:
- Android SDK Platform (recommended latest stable)
- Android SDK Platform-Tools
- Android SDK Command-line Tools

After install, configure Flutter with your SDK path:

```bash
flutter config --android-sdk "$HOME/Library/Android/sdk"
flutter doctor --android-licenses
flutter doctor -v
```

If `adb` is not in PATH, add this to your shell profile (`~/.zshrc`):

```bash
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
```

Then reload shell:

```bash
source ~/.zshrc
```

### 2) Configure Galaxy S9

On the phone:
1. Settings > About phone > Software information
2. Tap **Build number** 7 times (enable Developer options)
3. Settings > Developer options:
   - Enable **USB debugging**
   - (Optional) Enable **Install via USB**
4. Connect the phone by USB and accept the RSA prompt:
   - **Allow USB debugging** -> tap **Allow**

Validate connection:

```bash
adb devices
```

### 3) Install app in release mode

From this project:

```bash
flutter clean
flutter pub get
flutter devices
flutter run --release -d <GALAXY_DEVICE_ID>
```

### 4) Optional APK build

```bash
flutter build apk --release
```

Output:
- `build/app/outputs/flutter-apk/app-release.apk`
