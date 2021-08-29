import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TipWidget extends StatefulWidget {

  Text text;
  String tip;

  TipWidget({required this.text, required this.tip});
  @override
  State<TipWidget> createState() => _TipWidgetState();
}

class _TipWidgetState extends State<TipWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.text,
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Tooltip(
              message: widget.tip,
              textStyle: TextStyle(fontSize: 18, color: Colors.white),
              child: Text('?', style: TextStyle(color: Color(0xACB3B3B3), fontSize: 20),)
          ),
        )
      ],
    );
  }
}