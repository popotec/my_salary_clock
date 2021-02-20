import 'package:flutter/material.dart';

class BackButtonLeadingAppbar extends StatelessWidget {
  Color color;

  BackButtonLeadingAppbar({this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //radius: 5.0,
      child: Container(
        //margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.only(left: 10.0),
        child: Icon(
          Icons.arrow_back_ios,
          color: color == null ? Colors.black : color,
          size: 20.0,
        ),
      ),
      onTap: () {
        Navigator.pop(context, null);
      },
    );
  }
}
