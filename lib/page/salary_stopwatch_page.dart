import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation.dart';
import 'package:salary_watch/model/salary_work_info.dart';
import 'package:salary_watch/model/stop_watch_time.dart';

class SalaryStopWatchPage extends StatefulWidget {
  static String id = '/salary_stop_watch_page';

  @override
  _SalaryStopWatchPageState createState() => _SalaryStopWatchPageState();
}

class _SalaryStopWatchPageState extends State<SalaryStopWatchPage>
    with SingleTickerProviderStateMixin {
  String salCur = '\￦';
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    //  _timer?.cancel();
    super.dispose();
  }

  double milliSalary = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer2<StopWatchTime, SalaryWorkInfo>(
        builder: (context, stWatch, salWorkInfo, child) {
      milliSalary = salWorkInfo.getMilliSalary();
      salCur = salWorkInfo.getSalCur();
      updateTime(stWatch);
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Card(
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
                            '$watchTime',
                            style: TextStyle(
                                fontSize: kTIME_FONT_SIZE, color: Colors.black),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                            width: 30,
                            child: Text(
                              '$watchMillsec',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 120,
                  ),

                  Container(
                    child: Text(
                      Translation.of(context).trans('stopwatch_first_text'),
                      style: TextStyle(
                          fontSize: kTEXT_FONT_SIZE,
                          fontWeight: FontWeight.w300,
                          color: kBodyTextColor),
                    ),
                  ),
                  SizedBox(
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
                              color: kBodyTextColor)),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                        child: Text(
                          '$dollar' + '.',
                          style: TextStyle(
                              fontSize: kDOLLAR_FONT_SIZE,
                              color: kBodyTextColor),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                        width: 40,
                        child: Text('$cent',
                            style: TextStyle(
                                fontSize: kCENT_FONT_SIZE,
                                color: kBodyTextColor)),
                      ),
                      //  Text(' USD', style: TextStyle(fontSize: kTEXT_FONT_SIZE)),
                    ],
                  ),
                  // Money
                  // Text(
                  //   Translation.of(context).trans('stopwatch_second_text'),
                  //   style: TextStyle(
                  //       fontSize: kTEXT_FONT_SIZE,
                  //       fontWeight: FontWeight.w400,
                  //       fontFamily: 'Spoqa',
                  //       color: kBodyTextColor),
                  // ),
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
              Positioned(
                right: 20,
                bottom: 30,
                child: IconButton(
                  onPressed: () async {
                    await _reset(stWatch);
                  },
                  icon: Icon(Icons.rotate_left),
                  color: Colors.deepOrangeAccent,
                  iconSize: 45,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String dollar = '';
  String cent = '';

  String watchTime = '';
  String watchMillsec = '';

  void updateTime(StopWatchTime stWatch) {
    var _time = stWatch.getTime();

    if (_time == 0) {
      //  setState(() {
      watchTime = '00:00:00';
      watchMillsec = '00';
      dollar = '0';
      cent = '00';
      //   });
    } else {
      String hour = '${_time ~/ 360000}'.padLeft(2, '0');
      String min = '${(_time ~/ 6000) % 60}'.padLeft(2, '0');
      String sec = '${(_time ~/ 100) % 60}'.padLeft(2, '0');
      // setState(() {
      watchTime = '$hour:$min:$sec';
      watchMillsec = '${_time % 100}'.padLeft(2, '0');

      // Value of Time
      var timeValue = (milliSalary * _time * 100).floor();
      dollar = '${timeValue ~/ 100}';
      cent = '${timeValue % 100}'.padLeft(2, '0');
      //  });
    }
  }

  void _reset(StopWatchTime stWatch) async {
    stWatch.changeRunning(1); // 1 : reset
  }
}
