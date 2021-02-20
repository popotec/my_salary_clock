import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:salary_watch/constants/constant.dart';

class SalaryWorkInfo extends ChangeNotifier {
  int _annualSalary = 30000000;
  String _salCur = '￦';
  double _milliSalary = 0.0;

  List<int> _workdays = [1, 1, 1, 1, 1, 0, 0];
  int _startHour = 9;
  int _finishHour = 18;

  int getAnnualSalary() => _annualSalary;
  String getSalCur() => _salCur;
  double getMilliSalary() => _milliSalary;

  int getStartHour() => _startHour;
  int getFinishHour() => _finishHour;
  List<int> getWorkdays() => _workdays;

  void setSalaryInfoWtJson(String strSalaryInfo) {
    var salaryInfo = json.decode(strSalaryInfo);
    //연봉

    _annualSalary = int.parse(salaryInfo[kSalAmt]);
    //통화
    _salCur = salaryInfo[kSalCur];
    //주당 근무시간

    setMilliSalary();
  }

  void setMilliSalary() {
    int numOfWork = 0;

    for (int i = 0; i < _workdays.length; i++) {
      if (_workdays[i] == 1) {
        numOfWork++;
      }
    }

    int daySalary = (_annualSalary / (52 * numOfWork)).floor();

    //double hourSalary = daySalary / (finishHour - startHour);
    _milliSalary = daySalary /
        ((_finishHour - _startHour) * 360000); // 60*60*100 miliisecond 단위
    // print('millisalary');
    // print(_milliSalary);
    // _milliSalary =
    //     (_milliSalary * 100000000).floor() / 100000000; // 소수 둘째자리까지 유지
    //
    // print('millisalary');
    // print(_milliSalary);
  }

  void setSalaryInfo(int annualSalary, String salCur) {
    _annualSalary = annualSalary;
    _salCur = salCur;
    setMilliSalary();
  }

  void setWorkInfoJson(String strWorkInfo) {
    var workInfo = json.decode(strWorkInfo);

    //시작시간
    _startHour = int.parse(workInfo[kWorkStart]);

    //끝시간
    _finishHour = int.parse(workInfo[kWorkFinish]);

    //근무요일
    _workdays = new List<int>.from(workInfo[kWorkDays]);
    setMilliSalary();
  }

  void doNotifiListeners() {
    notifyListeners();
  }

  void setWorkInfo() {}
}
