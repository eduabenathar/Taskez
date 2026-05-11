import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  static const String _prefsKey = 'app.locale';

  static const Locale en = Locale('en');
  static const Locale ptBR = Locale('pt', 'BR');

  static const List<Locale> supported = <Locale>[en, ptBR];

  final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    locale.value = _decode(prefs.getString(_prefsKey));
  }

  Future<void> setLocale(Locale? value) async {
    locale.value = value;
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, _encode(value));
    }
  }

  static Locale resolve(Locale? device) {
    if (device != null && device.languageCode == 'pt') return ptBR;
    return en;
  }

  static String _encode(Locale l) {
    if (l.countryCode != null && l.countryCode!.isNotEmpty) {
      return '${l.languageCode}_${l.countryCode}';
    }
    return l.languageCode;
  }

  static Locale? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return Locale(parts[0]);
  }
}
