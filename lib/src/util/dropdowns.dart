import 'package:flutter/material.dart';

class DropDownItems{
  DropDownItems({
    required this.value,
    required this.text
  });
  String value;
  String text;
}

List<DropDownItems> setDropDownFromString(List<String> info){
    List<DropDownItems> items = [];
    for (int i =0; i < info.length;i++) {
      items.add(DropDownItems(
        value: info[i],
        text: info[i]
      ));
    }
    return items;
}

List<DropdownMenuItem<String>> setDropDownItems(List<DropDownItems> info){
  List<DropdownMenuItem<String>> items = [];
  for (int i =0; i < info.length;i++) {
    items.add(DropdownMenuItem(
      value: info[i].value,
      child: Text(
        info[i].text, 
        overflow: TextOverflow.ellipsis,
      )
    ));
  }
  return items;
}

Widget dropDown({
    Key? key,
    required List<DropdownMenuItem<dynamic>> itemVal, 
    TextStyle style = const TextStyle(
      color: Color(0xff989898),
      fontFamily: 'Klavika',
      package: 'css',
      fontSize: 14
    ),
    required dynamic value,
    Function(dynamic)? onchange,
    double width = 80,
    double height = 36,
    EdgeInsets padding = const EdgeInsets.only(left:10),
    EdgeInsets margin = const EdgeInsets.fromLTRB(0, 5, 0, 5),
    Color color = Colors.transparent,
    double radius = 0,
    Alignment alignment = Alignment.center,
    Border? border,
  }){
    return Container(
      key: key,
      margin: margin,
      alignment: alignment,
      width: width,
      height:height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: border
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton <dynamic>(
          dropdownColor: color,
          isExpanded: true,
          items: itemVal,
          value: value,//ddInfo[i],
          isDense: true,
          focusColor: Color(0xFF06A7E2),
          style: style,
          onChanged: onchange,
        ),
      ),
    );
}