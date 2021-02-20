import 'package:flutter/material.dart';

class StopWatchTime extends ChangeNotifier {
  int _time = 0;
  String watchTime = '';
  int _runningState = 0; // 0: pause, 1: reset, 2: running

  int getTime() => _time;

  int getRunningState() => _runningState;

  void setTime(int setTime) {
    _time = setTime;
    notifyListeners();
  }

  void increaseTime() {
    _time++;
    notifyListeners();
  }

  void resetTime() {
    _time = 0;
    notifyListeners();
  }

  void changeRunning(int changeVal) {
    _runningState = changeVal;
    notifyListeners();
  }

  void setTimeWtoNoti(int setTime) {
    _time = setTime;
  }

  void setStateWtoNoti(int changeVal) {
    _runningState = changeVal;
  }
}
