
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_hexagon_map/menu_element.dart';
import 'package:mapbox_hexagon_map/tip_widget.dart';

class LeftMenu extends StatefulWidget{

  LeftMenuController controller;

  LeftMenu(this.controller);

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {

  String _chosenValue1 = 'Продукты питания';
  String _chosenValue2 = 'Продукты питания';

  Map<String, int> tags = {
    'Продукты питания' : 1,
    'Аптеки и фармацевтика' : 0,
    'Одежда, обувь, аксессуары' : 2,
  };

  List<MenuElementController> controllers = [
    MenuElementController(0, 'Количество конкурентов', 100),
    MenuElementController(0, 'Количество уникальных клиентов (мес)', 10),
    MenuElementController(0, 'Средняя выручка (мес)', 20),
    MenuElementController(0, 'Плотность населения', 50),
    MenuElementController(0, 'Количество транзакций (мес)', 90)
  ];

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      widget.controller.opacity = [controllers[0].needState, controllers[1].needState, controllers[2].needState,controllers[3].needState, controllers[4].needState];
      widget.controller.countConcurents = controllers[0].count.toInt();
      widget.controller.countUnic = controllers[1].count.toInt();
      widget.controller.countMoney = controllers[2].count.toInt();
      widget.controller.countTrans = controllers[4].count.toInt();
      widget.controller.plotnost = controllers[3].count.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ListView(
            primary: true,
            children: [
              Container(
                padding: EdgeInsets.only(top: 120, left: 40, bottom: 40),
                child: Text('Параметры анализа', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),),
              ),

              Container(
                padding: EdgeInsets.only(top: 10, left: 60, bottom: 10, right: 80),
                child: TipWidget(text: Text('Пресет', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),), tip: 'Выберите один из пресетов, разработанных нашими аналитиками, или создайте свой')
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 60, bottom: 40, right: 80),
                child: DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenValue1,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'Продукты питания',
                    'Аптеки и фармацевтика',
                    'Одежда, обувь, аксессуары',
                    'Пользовательский'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  hint:Text(
                    "Please choose a langauage",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null)
                        _chosenValue1 = value;
                    });
                  },
                ),
              ),




              Container(
                padding: EdgeInsets.only(top: 80, left: 60, bottom: 10, right: 80),
                child: Text('Конкурентная сфера', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 60, bottom: 40, right: 80),
                child: DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenValue2,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'Продукты питания',
                    'Аптеки и фармацевтика',
                    'Одежда, обувь, аксессуары',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  hint:Text(
                    "Please choose a langauage",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null)
                        _chosenValue2 = value;
                    });
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MenuElement(controller: controllers[0], tip: 'Чем меньше - тем лучше',),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MenuElement(controller: controllers[3], tip: 'По ГИС ЖКХ',),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MenuElement(controller: controllers[1], tip: 'По предоставленным данным',),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MenuElement(controller: controllers[2], tip: '',),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MenuElement(controller: controllers[4], tip: 'По barcode кассовых аппаратов',),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class LeftMenuController extends ChangeNotifier {
  List<double> _opacity = [];
  int? _countConcurents, _countUnic, _countMoney, _countTrans, _plotnost;

  List<double> get opacity {
    notifyListeners();
    return _opacity;
  }
  int get countConcurents {
    notifyListeners();
    return _countConcurents!;
  }
  int get countUnic {
    notifyListeners();
    return _countUnic!;
  }
  int get countMoney {
    notifyListeners();
    return _countMoney!;
  }
  int get countTrans {
    notifyListeners();
    return _countTrans!;
  }

  int get plotnost {
    notifyListeners();
    return _plotnost!;
  }

  set opacity(List<double> o) => _opacity = o;

  set countConcurents(int c) {
    _countConcurents = c;
  }
  set countUnic(int c) {
    _countUnic = c;
  }
  set countMoney(int c) {
    _countMoney = c;
  }
  set countTrans(int c) {
    _countTrans = c;
  }

  set plotnost(int p) => _plotnost = p;
}