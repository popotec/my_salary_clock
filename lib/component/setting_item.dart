import 'package:flutter/material.dart';
import 'package:salary_watch/constants/constant.dart';
import 'package:salary_watch/localization/translation.dart';

class SettingItem extends StatelessWidget {
  String settingName = '';
  IconData iconData;
  Function onTap;

  SettingItem({this.settingName, this.iconData, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 0.1, color: Color(0xffeeeeee)),
          // top: BorderSide(width: 0.5, color: Colors.black),
          bottom:
              //BorderSide(width: 0.5, color: Colors.black),
              BorderSide(width: 0.1, color: Color(0xffeeeeee)),
        ),
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          color: kBodyTextColor,
        ),
        title: Text(
          settingName,
          style: TextStyle(color: kBodyTextColor, fontSize: 18.0),
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: kBodyTextColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
