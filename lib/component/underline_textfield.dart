import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salary_watch/constants/constant.dart';

class UnderLineTextField extends StatefulWidget {
  String hintText;
  Function onChanged;
  TextInputType textInputType;
  bool obscureText;
  double width;
  Function validator;
  Widget suffixIcon;
  TextEditingController controller;
  Function onTab;
  bool readOnly;
  List<TextInputFormatter> inputformatters;
  TextAlign textAlign;

  UnderLineTextField(
      {this.hintText,
      this.onChanged,
      this.textInputType,
      this.obscureText,
      this.width,
      this.validator,
      this.suffixIcon,
      this.controller,
      this.onTab,
      this.readOnly,
      this.inputformatters,
      this.textAlign});

  @override
  _UnderLineTextFieldState createState() => _UnderLineTextFieldState();
}

class _UnderLineTextFieldState extends State<UnderLineTextField> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width == null
          ? MediaQuery.of(context).size.width
          : widget.width,
      child: Container(
        height: 45.0,
        child: TextFormField(
          textAlign: widget.textAlign ?? TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          inputFormatters: widget.inputformatters,
          maxLines:
              widget.obscureText == null || widget.obscureText == true ? 1 : 2,
          // overflow: TextOverflow.ellipsis,
          //  softWrap: false,
          onTap: widget.onTab,
          controller: widget.controller,
          readOnly: widget.readOnly ?? false,
          keyboardType: widget.textInputType == null
              ? TextInputType.text
              : widget.textInputType,
          obscureText: widget.obscureText ?? false,
          //textAlign: TextAlign.center,
          onChanged: widget.onChanged,
          style: "$_value".isEmpty
              ? kUnderlineTextFieldTextStyle
              : kUnderlineTextFieldFilledTextStyle,
          decoration: kInputTextFieldDecoration.copyWith(
              hintText: widget.hintText, suffixIcon: widget.suffixIcon),
          validator: widget.validator,
        ),
      ),
    );
  }
}
//TextInputType.emailAddress
//TextFormField(
//decoration: const InputDecoration(
//icon: Icon(Icons.date_range),
//hintText: '2020.03.15 오후 2:32',
//labelText: '일시',
//),
//validator: (value) {
//if (value.isEmpty) {
//return '모임명을 입력하세요. (40자 이내)';
//}
//return null;
//},
//),
