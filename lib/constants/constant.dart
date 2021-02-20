import 'package:flutter/material.dart';

/**
 * SharedPreference
 */
// stopwatch state 저장
const String kTime = 'watchTime';
const String kPastTime = 'pastTime';
const String kState = 'watchState';
const String kWatchTime = 'stopwatchInfo';

// 연봉 저장
const String kSalCur = 'salaryCurrency';
const String kSalAmt = 'salaryAmt';
const String kSalaryInfo = 'salaryInfo';

// 근무 일정 저장
const String kWorkStart = 'workStartTime';
const String kWorkFinish = 'workFinishTime';
const String kWorkDays = 'workdays';
const String kWorkSchedulInfo = 'workdaysInfo';
// 개인 설정
const String kClockDp = 'clockDisplay';
//const String kSalaryInfo = 'salaryInfo';
//const String kWorkSchedulInfo = 'workdaysInfo';

/**
    디자인 설정
 */

// 색상 설정
//kBodyColor
const kCardColor = 0xFFC3C3C3;
const kBodyColor = Colors.white10;
const kBottomColor = 0XFF000000;

const kBodyTextColor = Colors.white;
//const

const kBottomItemSelected = Colors.amber;
const kBottomItemNotSelected = Colors.white30;
//Colors.white30
// 수치 설정
const kTITLE_FONT_SIZE = 20.0;
const kTEXT_FONT_SIZE = 22.0;
const kTIME_FONT_SIZE = 22.0;
const kSIGN_FONT_SIZE = 48.0;
const kCURRENCY_FONT_SIZE = 45.0;
const kDOLLAR_FONT_SIZE = 48.0;
const kCENT_FONT_SIZE = 25.0;

const kBottomItemSize = 40.0;

// style 설정

const kUnderlineTextFieldTextStyle = TextStyle(
  // fontWeight: FontWeight.w100,
  fontSize: 25,
  color: Color(0xffb7b7b7),
);

const kAppbarStyle = TextStyle(
  fontWeight: FontWeight.w500,
);

const kUnderlineTextFieldFilledTextStyle = TextStyle(
//  fontWeight: FontWeight.w300,
  fontSize: 25,
  color: Colors.white,
);

const kInputTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  //hintStyle: TextStyle(color: Color(0xffb7b7b7)),
  hintStyle: TextStyle(color: Color(0xff636e72)),
  //contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
  contentPadding: EdgeInsets.only(bottom: 0.0, left: 10.0),
  border: kUnderlineInputBorder,
  enabledBorder: kUnderlineInputBorder,
  focusedBorder: kUnderlineInputBorder,
);

const kUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Color(0xffb7b7b7),
    width: 0.5,
  ),
  borderRadius: BorderRadius.all(Radius.circular(2.0)),
);
