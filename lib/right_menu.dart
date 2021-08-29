import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_hexagon_map/SimpleElevatedCard.dart';
import 'package:mapbox_hexagon_map/shop_element.dart';
import 'package:mapbox_hexagon_map/table_text_widget.dart';

class RightMenu extends StatefulWidget {

  RightMenuController controller;

  RightMenu(this.controller);
  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> {

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    //ASK!!!!!
    String count_objects = widget.controller.response != null? widget.controller.response["count_objects"].toString() : '';
    String transactions_sum = widget.controller.response != null? widget.controller.response["transactions_sum"].toString() : '';
    String transaction_count = widget.controller.response != null? widget.controller.response["transaction_count"].toString() : '';
    String buyers_count = widget.controller.response != null? widget.controller.response["buyers_count"].toString() : '';

    String Rcount_objects = RightMenuController.full != null? RightMenuController.full!["count_objects"].toString() : '';
    String Rtransactions_sum = RightMenuController.full != null? RightMenuController.full!["transactions_sum"].toString() : '';
    String Rtransaction_count = RightMenuController.full != null? RightMenuController.full!["transaction_count"].toString() : '';
    String Rbuyers_count = RightMenuController.full != null? RightMenuController.full!["buyers_count"].toString() : '';

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 120, left: 40, bottom: 40),
              child: Text('Параметры квадрата', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),),
            ),
            Padding(
                padding: EdgeInsets.only(left: 40),
                child: SimpleElevatedCard(
                    width: 430,
                    height: 200,
                    child: Padding(
                        padding: EdgeInsets.all(30),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableText('Количество заведений:', count_objects, Colors.black),
                              TableText('Количество уникальных клиентов: ', buyers_count, Colors.black),
                              TableText('Сумма транзакций: ', transactions_sum , Colors.black,),
                              TableText('Количество транзакций: ', transaction_count, Colors.black),
                            ],
                          ),
                        )
                    )
                )
            ),
            Container(
              padding: EdgeInsets.only(top: 80, left: 40),
              child: Text('Конкуренты', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
            ),
            Padding(
                padding: EdgeInsets.only(left: 40, top: 40),
                child: Container(
                  width: 430,
                  height: 800,
                  child: ListView.builder(
                      itemCount: widget.controller.shopControllers.length,
                      itemBuilder: (BuildContext b, int id) {
                        return ShopElement(widget.controller.shopControllers[id]);
                      }),
                )
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 120, left: 40, bottom: 40),
              child: Text('Параметры района', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),),
            ),
            Padding(
                padding: EdgeInsets.only(left: 40),
                child: SimpleElevatedCard(
                    width: 430,
                    height: 200,
                    child: Padding(
                        padding: EdgeInsets.all(30),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableText('Количество заведений:', Rcount_objects, Colors.black),
                              TableText('Количество уникальных клиентов: ', Rbuyers_count, Colors.black),
                              TableText('Сумма транзакций: ', Rtransactions_sum , Colors.black,),
                              TableText('Количество транзакций: ', transaction_count, Colors.black),
                            ],
                          ),
                        )
                    )
                )
            ),
          ],
        )
      ],
    );
  }
}

class RightMenuController extends ChangeNotifier {
  List<ShopElementController> _shopControllers = [];

  Map? _response;
  static Map? full;

  set response(Map r) {
    _response = r;
    notifyListeners();
  }

  set shopControllers(List<ShopElementController> s) {
    _shopControllers = s;
    notifyListeners();
  }

  Map get response => _response!;
  List<ShopElementController> get shopControllers => _shopControllers;
}