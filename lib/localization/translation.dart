import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Translation {
  Translation(this.locale);

  final Locale locale;

  static Translation of(BuildContext context) {
    return Localizations.of<Translation>(context, Translation);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String strLoc = this.locale.languageCode;
    if (strLoc != 'ko') {
      // 한국어 외에는 영어만 지원
      strLoc = 'en';
    }
    String data =
        await rootBundle.loadString('./assets/locale/${strLoc}.json'); // 경로 유의
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }
}
