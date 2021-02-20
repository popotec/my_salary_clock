import 'package:flutter/material.dart';

class CurrencyCard extends StatefulWidget {
  String currencyName;
  Function onTab;
  bool isSelected = false;

  CurrencyCard({this.currencyName, this.onTab, this.isSelected});
  @override
  _CurrencyCardState createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTab,
      child: Container(
        width: 45.0,
        //height: 40.0,
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        color: widget.isSelected ? Colors.blue : null,
        alignment: Alignment.center,
        child: Text(
          widget.currencyName,
          style: TextStyle(
              color: widget.isSelected ? Colors.white : Colors.black12,
              fontSize: 16.0),
        ),
      ),
    );
  }
}
