import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation_delegate.dart';
import 'package:salary_watch/model/salary_work_info.dart';
import 'package:salary_watch/page/salary_main.dart';
import 'package:salary_watch/page/setting_salary.dart';
import 'package:salary_watch/util/PreferenceUtils.dart';

import 'model/stop_watch_time.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int state = 2;

    String strWorkInfo = PreferenceUtils.getString(kWorkSchedulInfo);
    String strSalaryInfo = PreferenceUtils.getString(kSalaryInfo);

    List<String> arguments = [strWorkInfo, strSalaryInfo];

    if (strWorkInfo == '' || strSalaryInfo == '') {
      state = 1; // 새로 정보 입력
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StopWatchTime()),
        ChangeNotifierProvider(create: (context) => SalaryWorkInfo()),
      ],
      child: MaterialApp(
        title: 'SALARY CLOCK',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Color(0XFF1B1B1B),
          accentColor: Color(0XFFFFCA28),
          fontFamily: 'NotoSansKR',
          // fontFamily: 'Spoqa',
        ),
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KR'),
        ],
        localizationsDelegates: [
          const TranslationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            debugPrint("*language locale is null!");
            return supportedLocales.first;
          }

          //Intl.defaultLocale = locale.toString() ?? 'ko_KR';
          //  initializeDateFormatting(locale.countryCode ?? 'KR');

          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode ||
                supportedLocale.countryCode == locale.countryCode) {
              debugPrint("*language ok $supportedLocale");
              return supportedLocale;
            }
          }

          debugPrint("*language to fallback ${supportedLocales.first}");
          return supportedLocales.first;
        },
        home: state == 1
            ? SettingSalary(
                isInitTime: true,
              )
            : SalaryMain(arguments: arguments),
      ),
    );
  }
}
