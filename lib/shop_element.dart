import 'package:flutter/cupertino.dart';
import 'package:mapbox_hexagon_map/SimpleElevatedCard.dart';

class ShopElement extends StatefulWidget {

  ShopElementController controller;

  ShopElement(this.controller);
  @override
  State<ShopElement> createState() => _ShopElementState();
}

class _ShopElementState extends State<ShopElement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: SimpleElevatedCard(
        boxShadow: BoxShadow(
          spreadRadius: -10,
          blurRadius: 10,
          color: Color(0x43343434)
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        height: 50,
        width: 100,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text(widget.controller.name),
          ),
        )
      ),
    );
  }
}

class ShopElementController extends ChangeNotifier {
  String name;
  bool _isActive = false;

  ShopElementController(this.name);

  bool get isActive => _isActive;

  set isActive(bool i) {
    _isActive = i;
    notifyListeners();
  }
}