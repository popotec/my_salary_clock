import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:intl/intl.dart';
import 'package:salary_watch/localization/translation.dart';
import 'package:salary_watch/model/salary_work_info.dart';

class SalaryClockPage extends StatefulWidget {
  static String id = '/salary_clock_page';

  @override
  _SalaryClockPageState createState() => _SalaryClockPageState();
}

class _SalaryClockPageState extends State<SalaryClockPage>
    with SingleTickerProviderStateMixin {
  Timer _timer;

  var _time = 0; // add 1 every 0.01 second

  int startHour = 9;
  int endHour = 18;

  // provider에서 가져오기

  // int _annualSalary = 100000; // unit: int
  String salCur = '\￦';
  int _milliSalary = 0;
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool isInit = true;

  List<int> workdays = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            Consumer<SalaryWorkInfo>(builder: (context, salWorkInfo, child) {
              milliSalary = salWorkInfo.getMilliSalary();
              salCur = salWorkInfo.getSalCur();
              startHour = salWorkInfo.getStartHour();
              endHour = salWorkInfo.getFinishHour();
              workdays = salWorkInfo.getWorkdays();
              if (isInit) {
                _start();
                isInit = false;
              }
              return Column(
                children: <Widget>[
                  Container(
                    height: 50,
                  ),
                  // Current time clock
                  Card(
                    //color: const Color(0xFFF3F7FD),
                    color: Color(kCardColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Container(
                      height: 28,
                      width: 160,
                      margin: EdgeInsets.fromLTRB(10, 4, 0, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '$_currentTime',
                            style: TextStyle(
                              fontSize: kTIME_FONT_SIZE,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                            width: 30,
                            child: Text(
                              '$_curMillsec',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                  ),
                  Container(
                    child: Text(
                      Translation.of(context).trans('clock_first_text'),
                      style: TextStyle(
                        fontSize: kTEXT_FONT_SIZE,
                        fontWeight: FontWeight.w300,
                        // fontFamily: 'Spoqa',
                        color: kBodyTextColor,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(salCur,
                          style: TextStyle(
                            fontSize: kCURRENCY_FONT_SIZE,
                            fontWeight: FontWeight.w400,
                            // fontFamily: 'Spoqa',
                            color: kBodyTextColor,
                          )),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                        child: Text(
                          '$dollar' + '.',
                          style: TextStyle(
                            fontSize: kDOLLAR_FONT_SIZE,
                            color: kBodyTextColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                        width: 40,
                        child: Text('$cent',
                            style: TextStyle(
                              fontSize: kCENT_FONT_SIZE,
                              color: kBodyTextColor,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String _currentTime = '';
  String _curMillsec = '';

  String dollar = '0';
  String cent = '00';

  double milliSalary = 0.0;

  void _updateTime() {
    // current time
    var _now = new DateTime.now();

    var timeFormat = new DateFormat('HH:mm:ss');
    _currentTime = timeFormat.format(_now);
    _curMillsec = '${_now.millisecond ~/ 10}'.padLeft(2, '0');

    if (workdays[_now.weekday - 1] == 0) {
      return; //근무요일이 아님
    }

    var workStartTime =
        new DateTime(_now.year, _now.month, _now.day, startHour, 0, 0, 0, 0);

    if (workStartTime.millisecondsSinceEpoch > _now.millisecondsSinceEpoch) {
      // 아직 근무 시작시간이 아님.
      return;
    }

    var workEndTime =
        new DateTime(_now.year, _now.month, _now.day, endHour, 0, 0, 0, 0);
    if (workEndTime.millisecondsSinceEpoch > _now.millisecondsSinceEpoch) {
      workEndTime = _now;
    }

    var workingTime = workEndTime.difference(workStartTime).inMilliseconds;
    workingTime = workingTime ~/ 10;

    if (workingTime > 0) {
      var timeValue = 0;

      timeValue = (workingTime * milliSalary * 100).floor(); // Value of Time

      dollar = '${timeValue ~/ 100}';

      var centAsNum = timeValue % 100;
      cent = '$centAsNum'.padLeft(2, '0');
    } else {
      workingTime = 0;
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
        _updateTime();
      });
    });
  }
}
