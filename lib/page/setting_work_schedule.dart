import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:salary_watch/component/back_button_leading_appbar.dart';
import 'package:salary_watch/component/underline_textfield.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation.dart';
import 'package:salary_watch/model/day_data.dart';
import 'package:salary_watch/page/salary_main.dart';
import 'package:salary_watch/util/PreferenceUtils.dart';

class SettingWorkSchedule extends StatefulWidget {
  static String id = '/setting_work_schedule';

  // List<String> arguments;
  //
  // SettingWorkSchedule({this.arguments});
  bool isInitTime = true;
  SettingWorkSchedule({this.isInitTime});

  @override
  _SettingWorkScheduleState createState() => _SettingWorkScheduleState();
}

class _SettingWorkScheduleState extends State<SettingWorkSchedule> {
  int listState = 0; // 0: nothing, 1:currencyList, 2:amountList

  //sharedPreference에서 읽어와서 셋팅
  List<DayData> dayDataList = [];

  TextEditingController _startHour = TextEditingController();
  TextEditingController _endHour = TextEditingController();

  List<int> selectDays = [];

  final int workInfoIndex = 0;

  @override
  void initState() {
    String strWorkInfo = PreferenceUtils.getString(kWorkSchedulInfo);
    if (strWorkInfo != '') {
      var workInfo = json.decode(strWorkInfo);
      _startHour.text = workInfo[kWorkStart];

      _endHour.text = workInfo[kWorkFinish];

      selectDays = new List<int>.from(workInfo[kWorkDays]);
    } else {
      selectDays = [1, 1, 1, 1, 1, 0, 0];
    }
    super.initState();
  }

  bool isInit = true;

  // List<String> arguments = [];

  @override
  Widget build(BuildContext context) {
    if (isInit) {
      setDayData([
        Translation.of(context).trans('mon'),
        Translation.of(context).trans('tue'),
        Translation.of(context).trans('wed'),
        Translation.of(context).trans('thu'),
        Translation.of(context).trans('fri'),
        Translation.of(context).trans('sat'),
        Translation.of(context).trans('sun')
      ]);
      // salCur = currencies[0];
      // selectedIndex = 0;
      isInit = false;
    }
    return Scaffold(
      backgroundColor: kBodyColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        title: Text(
          Translation.of(context).trans('setting_second_list'),
          //  'Input your work schedule',
          // Translation.of(context).trans('setting_first_list'),
          style: kAppbarStyle,
        ),
        leading: BackButtonLeadingAppbar(
          color: Colors.white,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  //'Input your work schedule',
                  Translation.of(context).trans('setting_workinfo_title'),
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                )),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20.0, right: 10.0),
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                      size: 18.0,
                    )),
                Container(
                  alignment: Alignment.bottomLeft,
                  width: 120.0,
                  height: 45.0,
                  child: Text(
                    Translation.of(context).trans('setting_workinfo_time'),
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                getTimeInput(true),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 50.0,
                  height: 45.0,
                  child: Text(
                    '~',
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
                getTimeInput(false),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20.0, right: 10.0),
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      Icons.today,
                      color: Colors.white,
                      size: 18.0,
                    )),
                Container(
                  alignment: Alignment.bottomLeft,
                  width: 120.0,
                  height: 45.0,
                  child: Text(
                    Translation.of(context).trans('setting_workinfo_day'),
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            getCurrencyListView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          //color: Color(0xff4D2C45),
          color: Color(kBottomColor),
          child: new Builder(builder: (BuildContext snackContext) {
            return FlatButton(
              onPressed: () async {
                if (_startHour.text == '') {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context)
                          .trans('message_work_stime_require')));
                  return;
                }

                if (_endHour.text == '') {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context)
                          .trans('message_work_etime_require')));
                  return;
                }
                int startHr = int.parse(_startHour.text);
                int endHr = int.parse(_endHour.text);

                if (startHr <= 0 || startHr > 24 || endHr <= 0 || endHr > 24) {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context)
                          .trans('message_work_time_validate')));
                  return;
                }

                if (startHr >= endHr) {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context)
                          .trans('message_work_setime_compare')));
                  return;
                }

                int count = 0;
                for (int j = 0; j < dayDataList.length; j++) {
                  if (dayDataList[j].IsSelected()) {
                    selectDays[j] = 1;
                    count++;
                  } else {
                    selectDays[j] = 0;
                  }
                }

                if (count == 0) {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context)
                          .trans('message_work_day_require')));
                  return;
                }

                var jsonData = {
                  kWorkStart: _startHour.text,
                  kWorkFinish: _endHour.text,
                  kWorkDays: selectDays,
                };

                String strWorkInfo = jsonEncode(jsonData);

                await PreferenceUtils.setString(kWorkSchedulInfo, strWorkInfo);

                if (!widget.isInitTime) {
                  // 초기설정이 아니면
                  Navigator.pop(context, strWorkInfo);
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SalaryMain()));
                }
                return;
              },
              child: Text(
                Translation.of(context).trans('setting_salary_confirm'),
                style: TextStyle(color: Colors.amber, fontSize: 22.0),
              ),
            );
          }),
        ),
      ),
    );
  }

  SnackBar getSnackBar(String text) {
    return SnackBar(
      backgroundColor: Colors.blueAccent.withOpacity(0.3),
      duration: Duration(milliseconds: 1000),
      content: Container(
        height: 20.0,
        alignment: Alignment.center,
        child: new Text(
          text,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  void setDayData(List<String> days) {
    for (int i = 0; i < days.length; i++) {
      dayDataList.add(new DayData(
          dayIndex: i + 1,
          dayStr: days[i],
          isSelected: selectDays[i] == 1 ? true : false));
    }
  }

  // currency 정렬
  Widget getCurrencyListView() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: dayDataList == null ? 0 : dayDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return FlatButton(
            padding: EdgeInsets.all(0.0),
            minWidth: 0, //wraps child's width
            height: 0, //wraps child's height
            onPressed: () {
              setState(() {
                dayDataList[index].changeSelection();
              });
            },
            child: Container(
              width: 45.0,
              height: 55.0,
              decoration: BoxDecoration(
                color: dayDataList[index].IsSelected() ? Colors.amber : null,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.amber,
                    width: dayDataList[index].IsSelected() ? 0 : 2,
                  ),
                ),
              ),
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 3.0),
              alignment: Alignment.center,
              child: Text(
                dayDataList[index].dayStr,
                style: TextStyle(
                  color: dayDataList[index].IsSelected()
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  // fontFamily: 'Spoqa',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getTimeInput(bool isFront) {
    return UnderLineTextField(
      //  textAlignment: Alignment.center,
      controller: isFront ? _startHour : _endHour,
      textAlign: TextAlign.center,
      textInputType: TextInputType.number,
      //    controller: _salaryCtrl,
      width: 50.0,
      hintText: isFront ? '9' : '18',
      onChanged: (value) {},
    );
  }
}
