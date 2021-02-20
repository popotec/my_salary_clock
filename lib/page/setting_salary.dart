import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salary_watch/component/back_button_leading_appbar.dart';
import 'package:salary_watch/component/underline_textfield.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation.dart';
import 'package:salary_watch/model/AmtFormat.dart';
import 'package:salary_watch/page/setting_work_schedule.dart';
import 'package:salary_watch/util/PreferenceUtils.dart';

class SettingSalary extends StatefulWidget {
  static String id = '/setting_salary';

  bool isInitTime = true;
  SettingSalary({this.isInitTime});
  // List<String> arguments;
  //
  // SettingSalary({this.arguments});
  @override
  _SettingSalaryState createState() => _SettingSalaryState();
}

class _SettingSalaryState extends State<SettingSalary> {
  int listState = 0; // 0: nothing, 1:currencyList, 2:amountList

  final int salaryInfoIndex = 1;

  //sharedPreference에서 읽어와서 셋팅
  List<String> currencies = ['\$', '€', '￦'];
  String salCur;
  int selectedIndex;

  TextEditingController _salaryCtrl = TextEditingController();
  //events = jsonDecode(json).cast<String>();
  @override
  void initState() {
    salCur = currencies[0];
    selectedIndex = 0;

    String strSalaryInfo = PreferenceUtils.getString(kSalaryInfo);

    //   String strSalaryInfo = widget.arguments[salaryInfoIndex]; // salaryinfo
    if (strSalaryInfo != '') {
      // 저장된 salary 정보가 있으면
      var salaryInfo = json.decode(strSalaryInfo);
      salCur = salaryInfo[kSalCur];
      for (int i = 0; i < currencies.length; i++) {
        if (currencies[i] == salCur) {
          selectedIndex = i;
          break;
        }
      }
      String newText = new NumberFormat('###,###,###,###,###,###,###,###,###')
          .format(int.parse((salaryInfo[kSalAmt])))
          .replaceAll(' ', '');

      _salaryCtrl.text = newText;
    }

    // if()
    //  String strSalaryInfo = PreferenceUtils.getString(kSalaryInfo);
    //  if (strSalaryInfo != '') {
    //    // 저장된 salary 정보가 있으면
    //    var salaryInfo = json.decode(strSalaryInfo);
    //    salCur = salaryInfo[kSalCur];
    //    for (int i = 0; i < currencies.length; i++) {
    //      if (currencies[i] == salCur) {
    //        selectedIndex = i;
    //        break;
    //      }
    //    }
    //    String newText = new NumberFormat('###,###,###,###,###,###,###,###,###')
    //        .format(int.parse((salaryInfo[kSalAmt])))
    //        .replaceAll(' ', '');
    //
    //    _salaryCtrl.text = newText;
    //  }

    super.initState();
  }

  int amtVal = 0;

  bool isInit = true;

  //List<String> arguments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        title: Text(
          Translation.of(context).trans('setting_first_list'),
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
                  Translation.of(context).trans('setting_salary_title'),
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
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  minWidth: 0, //wraps child's width
                  height: 0, //wraps child's height
                  onPressed: () {
                    setState(() {
                      listState = listState == 1 ? 0 : 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 50.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      salCur,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white
                          // fontFamily: 'Spoqa',
                          ),
                    ),
                  ),
                ),
                UnderLineTextField(
                  textInputType: TextInputType.number,
                  inputformatters: [AmtFormat()],
                  controller: _salaryCtrl,
                  width: MediaQuery.of(context).size.width - 100,
                  hintText: '0',
                  onChanged: (value) {
                    amtVal = int.parse(value);
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: 20.0,
                      color: Color(0xffb7b7b7),
                    ),
                    onPressed: () {
                      setState(() {
                        _salaryCtrl.text = '';
                      });
                    },
                  ),
                ),
              ],
            ),
            listState == 1 ? getCurrencyListView() : Container(),
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
                if (_salaryCtrl.text.length > 20) {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context).trans('message_salAmt_too_big')));

                  return;
                }

                if (_salaryCtrl.text.length == 0) {
                  Scaffold.of(snackContext).showSnackBar(getSnackBar(
                      Translation.of(context)
                          .trans('message_salAmt_required')));

                  return;
                }
                String newText = _salaryCtrl.text.replaceAll(",", "");
                var jsonData = {
                  kSalCur: salCur,
                  kSalAmt: newText,
                };

                String strSalInfo = jsonEncode(jsonData);
                await PreferenceUtils.setString(kSalaryInfo, strSalInfo);

                if (!widget.isInitTime) {
                  //초기 셋팅이 아니면
                  Navigator.pop(context, strSalInfo);
                } else {
                  //  widget.arguments[salaryInfoIndex] = strSalInfo;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SettingWorkSchedule(isInitTime: true)));
                  // Navigator.pushReplacementNamed(context, SettingSalary.id,
                  //     arguments: widget.arguments);
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

  // currency 정렬
  Widget getCurrencyListView() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: currencies == null ? 0 : currencies.length,
        itemBuilder: (BuildContext context, int index) {
          return FlatButton(
            padding: EdgeInsets.all(0.0),
            minWidth: 0, //wraps child's width
            height: 0, //wraps child's height
            onPressed: () {
              setState(() {
                selectedIndex = index;
                salCur = currencies[index];
              });
            },
            child: Container(
              width: 70.0,
              height: 55.0,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              color: selectedIndex == index ? Colors.amber : null,
              alignment: Alignment.center,
              child: Text(
                currencies[index],
                style: TextStyle(
                  color: selectedIndex == index ? Colors.black : Colors.white,
                  fontSize: 22.0,
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
}
