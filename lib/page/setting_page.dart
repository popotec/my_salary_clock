import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salary_watch/component/setting_item.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation.dart';
import 'package:salary_watch/model/salary_work_info.dart';
import 'package:salary_watch/page/setting_salary.dart';
import 'package:salary_watch/page/setting_work_schedule.dart';
import 'package:salary_watch/util/PreferenceUtils.dart';

class SettingPage extends StatefulWidget {
  static String id = '/setting_page';

  //List<String> arguments = [];

  // SettingPage({this.arguments});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void dispose() {
    super.dispose();
  }

  List<String> arguments;
  @override
  Widget build(BuildContext context) {
    String strSalaryInfo = PreferenceUtils.getString(kSalaryInfo);
    String strWorkInfo = PreferenceUtils.getString(kWorkSchedulInfo);
    arguments = [strWorkInfo, strSalaryInfo];
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Consumer<SalaryWorkInfo>(builder: (context, salWorkInfo, child) {
          return Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SettingItem(
                  settingName:
                      Translation.of(context).trans('setting_first_list'),
                  iconData: Icons.attach_money,
                  onTap: () async {
                    var strSalaryInfo = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingSalary(
                                  isInitTime: false,
                                )));
                    if (strSalaryInfo != null) {
                      salWorkInfo.setSalaryInfoWtJson(strSalaryInfo);
                      salWorkInfo.doNotifiListeners();
                    }
                    // widget.arguments[1] = strSalaryInfo;
                  },
                ),
                SettingItem(
                  settingName:
                      Translation.of(context).trans('setting_second_list'),
                  iconData: Icons.access_time,
                  onTap: () async {
                    var strWorkInfo = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingWorkSchedule(
                                  isInitTime: false,
                                )));

                    if (strWorkInfo != null) {
                      salWorkInfo.setWorkInfoJson(strWorkInfo);
                      salWorkInfo.doNotifiListeners();
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Route _createRoute(int listPage) {
  //   return PageRouteBuilder(
  //     //pageBuilder: (context, animation, secondaryAnimation) => SearchLoaction(),
  //     pageBuilder: (context, animation, secondaryAnimation) => listPage == 1
  //         ? SettingSalary(
  //             isInitTime: false,
  //           )
  //         : SettingWorkSchedule(isInitTime: false),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = Offset(0.1, 0.0);
  //       var end = Offset.zero;
  //       //  var curve = Curves.fastLinearToSlowEaseIn;
  //
  //       var tween = Tween(begin: begin, end: end);
  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }
}
