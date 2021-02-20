import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation.dart';
import 'package:salary_watch/model/salary_work_info.dart';
import 'package:salary_watch/model/stop_watch_time.dart';
import 'package:salary_watch/page/salary_clock_page.dart';
import 'package:salary_watch/page/salary_stopwatch_page.dart';
import 'package:salary_watch/page/setting_page.dart';

import 'dart:isolate';

import 'package:salary_watch/util/PreferenceUtils.dart';

class SalaryMain extends StatefulWidget {
  static String id = '/salary_main';

  List<String> arguments;

  SalaryMain({this.arguments});

  @override
  _SalaryMainState createState() => _SalaryMainState();
}

class _SalaryMainState extends State<SalaryMain> with WidgetsBindingObserver {
  int screenState = 1; // 1: clock, 2:watch

  AppLifecycleState _lastLifecycleState;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lastLifecycleState = state;

    if (_lastLifecycleState == AppLifecycleState.resumed) {
      // background에 있다가 다시 시작
      if (!readStopwatch(false)) {
        return;
      }
    } else if (_lastLifecycleState == AppLifecycleState.paused) {
      //background로 넘어감
      saveStopwatch();
    }
  }

  static bool isInit = true;
  //List<String> arguInfos = [];
  void resumeState(StopWatchTime stWatch) {}

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      // back button 제어. back button 시에도 stopwatch 저장.
      onWillPop: () async {
        saveStopwatch();
        return true;
      },
      child: Consumer2<StopWatchTime, SalaryWorkInfo>(
          builder: (context, stWatch, salWorkInfo, child) {
        stWatchGlb = stWatch;

        if (isInit) {
          // 근무 스케쥴
          readStopwatch(true);

          String strWorkInfo = '';
          String strSalaryInfo = '';
          if (widget.arguments == null || widget.arguments.length == 0) {
            strWorkInfo = PreferenceUtils.getString(kWorkSchedulInfo);
            strSalaryInfo = PreferenceUtils.getString(kSalaryInfo);
          } else {
            strWorkInfo = widget.arguments[0];
            strSalaryInfo = widget.arguments[1];
          }

          //근무정보
          if (strWorkInfo != '') {
            salWorkInfo.setWorkInfoJson(strWorkInfo);
          }
          // 연봉 정보
          if (strSalaryInfo != '') {
            salWorkInfo.setSalaryInfoWtJson(strSalaryInfo);
          }
          isInit = false;
        } else {
          if (stWatch.getRunningState() == 1) {
            _stop();
            // build 중에 changeNotifier의 notifyListeners()를 호출하는 경우 오류가 발생감. 새로 빌드 되기전이므로 값만 변경해줘도됨.
            // SalaryStopwatchPage의 reset 함수에서 안하는 이유는, isolate를 중지시키지않고 값을 먼저 리셋하면 중지되기까지 카운트가 생김.
            stWatch.setTimeWtoNoti(0);
          }
        }
        return Scaffold(
          //backgroundColor: Color(0xFFF3F7FD),
          //backgroundColor: Color(kBodyColor),
          backgroundColor: kBodyColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              screenState == 1
                  ? Translation.of(context).trans('clock_title')
                  : screenState == 2
                      ? Translation.of(context).trans('stopwatch_title')
                      : Translation.of(context).trans('setting_title'),
              style: kAppbarStyle,
            ),
          ),
          body: screenState == 1
              ? SalaryClockPage()
              : screenState == 2
                  ? SalaryStopWatchPage()
                  : SettingPage(),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 60.0,
              //color: Color(0xff4D2C45),
              color: Color(kBottomColor),
              child: Row(
                children: [
                  IconButton(
                    iconSize: kBottomItemSize,
                    color: screenState == 1
                        ? kBottomItemSelected
                        : kBottomItemNotSelected,
                    icon: Icon(Icons.access_time),
                    onPressed: () {
                      setState(() {
                        screenState = 1;
                      });
                    },
                  ),
                  IconButton(
                    iconSize: kBottomItemSize,
                    color: screenState == 2
                        ? kBottomItemSelected
                        : kBottomItemNotSelected,
                    icon: Icon(Icons.access_alarm),
                    onPressed: () {
                      setState(() {
                        screenState = 2;
                      });
                    },
                  ),
                  Spacer(),
                  IconButton(
                    iconSize: kBottomItemSize,
                    color: screenState == 3
                        ? kBottomItemSelected
                        : kBottomItemNotSelected,
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      setState(() {
                        screenState = 3;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: screenState == 2
              ? FloatingActionButton(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: CircleBorder(
                    // side: BorderSide(color: Color(0xFF1B1B1B), width: 2.0),
                    //side: BorderSide(color: Color(0xFFFDED90), width: 2.0),
                    side: BorderSide(color: Color(0xFFFDED90), width: 2.0),
                  ),
                  onPressed: () async {
                    _clickButton(stWatch);
                  },
                  child: stWatch.getRunningState() == 2
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      }),
    );
  }

  // Timer _timer;
  StopWatchTime stWatchGlb;
  void _clickButton(StopWatchTime stWatch) async {
    int chVal = stWatch.getRunningState() == 2 ? 0 : 2;

    if (chVal == 2) {
      await _start(stWatch);
    } else {
      _stop();
    }
    stWatch.changeRunning(chVal); //2 : start
  }

  /**
   *  STOPWATCH 정보 저장 및 읽기
   */
  bool readStopwatch(bool isInit) {
    String strWatchInfo = PreferenceUtils.getString(kWatchTime);
    if (strWatchInfo == '') {
      return false;
    }

    var watchInfo = json.decode(strWatchInfo);

    int lastState = int.parse(watchInfo[kState]);
    int diffTime = 0;

    if (lastState == 2) // 실행중이 아니었으면 diff 계산 안해도됨
    {
      var pastTime = DateTime.parse(watchInfo[kPastTime]);
      diffTime = DateTime.now().difference(pastTime).inMilliseconds ~/ 10;
      // Timer의 단위가 10Milliseconds 이므로 맞춰줌.
    }

    if (isInit) {
      stWatchGlb.setTimeWtoNoti(
          diffTime + int.parse(watchInfo[kTime])); // stopwatch 시간 할당
      stWatchGlb.setStateWtoNoti(lastState); // 상태값 변경

      if (lastState == 2) // 실행중
      {
        _start(stWatchGlb);
      }
    } else {
      stWatchGlb
          .setTime(diffTime + int.parse(watchInfo[kTime])); // stopwatch 시간 할당
      stWatchGlb.changeRunning(lastState);
      // 상태값 변경
    }

    return true;
  }

  void saveStopwatch() async {
    var jsonData = {
      kTime: stWatchGlb.getTime().toString(),
      kState: stWatchGlb.getRunningState().toString(),
      kPastTime: new DateTime.now().toString()
    };
    await PreferenceUtils.setString(kWatchTime, jsonEncode(jsonData));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (isolate != null) {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
    super.dispose();
  }

  /**
   *  Timer Isolate 동작 (main thread와 별도 스레드)
   */

  ReceivePort receivePort;
  Isolate isolate;
  // isolate timer 관련
  void _start(StopWatchTime stWatch) async {
    //_running = true;
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(_checkTimer, receivePort.sendPort);
    // SendPort sendPort = await receivePort.first;
    // receivePort.listen(_handleMessage, onDone: () {
    receivePort.listen((message) {
      //   print("timer started!");
      stWatchGlb.increaseTime();
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
      sendPort.send(receivePort.sendPort);
    });
  }

  void _stop() {
    if (isolate != null) {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
