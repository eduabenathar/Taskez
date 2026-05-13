import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'Controllers/locale_controller.dart';
import 'Screens/splash_screen.dart';
import 'Services/calendar_store.dart';
import 'Services/platform_ui_config.dart';
import 'Theme/app_theme.dart';
import 'Theme/theme_controller.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load();
  await LocaleController.instance.load();
  await CalendarStore.instance.init();
  await PlatformUiConfig.current.applySystemUi();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _platformUi = PlatformUiConfig.current;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_platformUi.shouldInstallVisibilityCallback) {
      SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
        if (systemOverlaysAreVisible) {
          await Future.delayed(const Duration(milliseconds: 250));
          await _platformUi.applySystemUi();
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _platformUi.applySystemUi();
    }
  }

  @override
  void dispose() {
    if (_platformUi.shouldInstallVisibilityCallback) {
      SystemChrome.setSystemUIChangeCallback(null);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.mode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Locale?>(
          valueListenable: LocaleController.instance.locale,
          builder: (context, locale, __) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Taskez',
              theme: buildLightTheme(),
              darkTheme: buildDarkTheme(),
              themeMode: mode,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (device, supported) =>
                  LocaleController.resolve(device),
              home: SplashScreen(),
            );
          },
        );
      },
    );
  }
}
