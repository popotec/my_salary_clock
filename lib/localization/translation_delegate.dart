import 'dart:async';
import 'package:flutter/material.dart';
import 'package:salary_watch/localization/translation.dart';

class TranslationDelegate extends LocalizationsDelegate<Translation> {
  const TranslationDelegate();

  @override
  bool isSupported(Locale locale) => ['ko', 'en'].contains(locale.languageCode);

  @override
  Future<Translation> load(Locale locale) async {
    Translation localizations = new Translation(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(TranslationDelegate old) => false;
}
