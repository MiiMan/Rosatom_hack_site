import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_hexagon_map/SimpleElevatedCard.dart';
import 'package:mapbox_hexagon_map/tip_widget.dart';

import 'consts.dart';

class MenuElement extends StatefulWidget {

  MenuElementController controller;
  String tip;

  MenuElement({
    required this.controller,
    required this.tip
  });
  @override
  State<MenuElement> createState() => _MenuElementState();
}

class _MenuElementState extends State<MenuElement> {

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.text = widget.controller._count.toString();

    widget.controller.addListener(() {
      if (f) {
        widget.controller.needState = 0;
      }
      else if (s) {
        widget.controller.needState = 0.5;
      } else if (t) {
        widget.controller.needState = 1;
      }
      if (double.tryParse(textController.text) != null) {
        widget.controller.count = double.parse(textController.text);
      } else {
        //
      }
    });

  }


  bool f = false, s = true, t = false;

  @override
  Widget build(BuildContext context) {
    return SimpleElevatedCard(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 40),
            child: SizedBox(
              width: double.infinity,
              child: TipWidget(text: Text(widget.controller.type, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),), tip: widget.tip,)
            )
          ),
          !f? Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 25),
              child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Введите желаемое количество",
                  )
              )
          ): Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: f? MaterialStateProperty.all(Colors.red): MaterialStateProperty.all(Colors.grey),
                  shape: Consts.button_shape
                ),
                onPressed: () {widget.controller._needState = 0; setState(() {f = true; s = false; t = false;});},
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Не важно', style: Consts.button_text_style,),
                )
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: s? MaterialStateProperty.all(Colors.blue): MaterialStateProperty.all(Colors.grey),
                shape: Consts.button_shape),
                onPressed: () {widget.controller._needState = 0.5; setState(() {s = true; f = false; t = false;});},
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Не уверен', style: Consts.button_text_style,),
                )
              ),
              TextButton(
                style: ButtonStyle(backgroundColor: t? MaterialStateProperty.all(Colors.green): MaterialStateProperty.all(Colors.grey),
                shape: Consts.button_shape),
                onPressed: () {widget.controller._needState = 1; setState(() {t = true; s = false; f = false;});},
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('   Важно   ', style: Consts.button_text_style,),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuElementController extends ChangeNotifier{

  MenuElementController(this._needState, this._type, this._count);

  double _needState = 1;
  String _type;
  double _count;

  double get needState {
    notifyListeners();
    return _needState;
  }

  String get type {
    notifyListeners();
    return _type;
  }

  double get count => _count;

  set needState(double n) => _needState = n;
  set type(String t) => _type = t;
  set count(double c) => _count = c;
}