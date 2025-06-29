import 'package:flutter/material.dart';

class LocaleController {
  static final LocaleController _instance = LocaleController._internal();

  factory LocaleController() => _instance;

  LocaleController._internal();

  void Function(Locale)? setLocaleCallback;

  void setLocale(Locale locale) {
    if (setLocaleCallback != null) {
      setLocaleCallback?.call(locale);
      setLocaleCallback!(locale);
    }
  }
}
