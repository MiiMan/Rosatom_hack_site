import 'package:flutter/cupertino.dart';

class TableText extends StatelessWidget {
  String f,s;

  Color color;


  TableText(this.f, this.s, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(f, style: TextStyle(fontSize: 18)),
        Text(s, style: TextStyle(fontSize: 18, color: color)),
      ],
    );
  }

}