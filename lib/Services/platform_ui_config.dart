import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformUiConfig {
  const PlatformUiConfig._({
    required this.shouldInstallVisibilityCallback,
    required this.cameraRatioBarBottom,
    required this.cameraControlsBottomLift,
    required this.applySystemUiFn,
  });

  final bool shouldInstallVisibilityCallback;
  final double cameraRatioBarBottom;
  final double cameraControlsBottomLift;
  final Future<void> Function() applySystemUiFn;

  static const PlatformUiConfig android = PlatformUiConfig._(
    shouldInstallVisibilityCallback: true,
    cameraRatioBarBottom: 2.0,
    cameraControlsBottomLift: 14.0,
    applySystemUiFn: _applyAndroidSystemUi,
  );

  static const PlatformUiConfig iPhone = PlatformUiConfig._(
    shouldInstallVisibilityCallback: false,
    cameraRatioBarBottom: -10.0,
    cameraControlsBottomLift: 0.0,
    applySystemUiFn: _applyIPhoneSystemUi,
  );

  static const PlatformUiConfig fallback = PlatformUiConfig._(
    shouldInstallVisibilityCallback: false,
    cameraRatioBarBottom: -10.0,
    cameraControlsBottomLift: 0.0,
    applySystemUiFn: _applyFallbackSystemUi,
  );

  static PlatformUiConfig get current {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return iPhone;
      default:
        return fallback;
    }
  }

  Future<void> applySystemUi() => applySystemUiFn();

  static Future<void> _applyAndroidSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  static Future<void> _applyIPhoneSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  static Future<void> _applyFallbackSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }
}
