import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_hexagon_map/SimpleElevatedCard.dart';
import 'package:mapbox_hexagon_map/left_menu.dart';
import 'package:mapbox_hexagon_map/right_menu.dart';
import 'package:mapbox_hexagon_map/shop_element.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:http/http.dart' as http;

import 'consts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  LatLng hex_corner(LatLng center, double size, double i, Point baseVector) {
    double angle_deg = 60 * i   + 30;
    double angle_rad = pi / 180 * angle_deg;
    //LOOOK
    return LatLng(center.latitude + size*baseVector.y * cos(angle_rad), center.longitude + size*baseVector.x * sin(angle_rad));
  }
  List<LatLng> hexagon(LatLng center, double size, Point baseVector) {
    return [
      hex_corner(center, size, 0, baseVector),
      hex_corner(center, size, 1, baseVector),
      hex_corner(center, size, 2, baseVector),
      hex_corner(center, size, 3, baseVector),
      hex_corner(center, size, 4, baseVector),
      hex_corner(center, size, 5, baseVector),
    ];
  }

  LatLng square_corner(LatLng center, double size, double i, Point baseVector) {
    double angle_deg = 90 * i   + 45;
    double angle_rad = pi / 180 * angle_deg;
    //LOOOK
    return LatLng(center.latitude + size*baseVector.y * cos(angle_rad), center.longitude + size*baseVector.x * sin(angle_rad));
  }
  List<LatLng> square(LatLng center, double size, Point baseVector) {
    LatLng a = square_corner(center, size, 2, baseVector);
    LatLng b = square_corner(center, size, 4, baseVector);

    //http.get(Uri.parse('http://178.21.11.177:9999/get_full_statistic?tag=1&point_1_lat=${a.latitude}&point_1_lon=${a.longitude}&point_2_lat=${b.latitude}&point_2_lon=${b.longitude}')).then((value) => print(value.body));
    return [
      square_corner(center, size, 0, baseVector),
      square_corner(center, size, 1, baseVector),
      square_corner(center, size, 2, baseVector),
      square_corner(center, size, 3, baseVector),
      square_corner(center, size, 4, baseVector),
    ];
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 1000*12742 * asin(sqrt(a));
  }


  List<FillOptions> generateMap(LatLng center, int radius, double square_radius, Point baseVector) {
    List<FillOptions> list = [];

    for (int y = -radius; y <= radius; y++) {
      for (int x = -radius; x <= radius; x++) {
        list.add(
          FillOptions(
            geometry: [square(
                LatLng(
                    center.latitude+square_radius*2*x/baseVector.x*1.0605,
                    center.longitude+square_radius*2*y/baseVector.y*1.0605),
                square_radius, baseVector)],
            fillOpacity: 0.2+Random().nextInt(30)/100,
            fillColor: '#3cb371',
            fillOutlineColor: '#3cb371'),
        );
      }
    }
    return list;
  }
  Future<List<FillOptions>> generateMapHard(LatLng center, int xc, int yc, double square_radius, Point baseVector) async {
    List<FillOptions> list = [];

    for (int y = -yc; y <= yc; y++) {
      for (int x = -xc; x <= xc; x++) {

        List<LatLng> map = square(
            LatLng(
                center.latitude+square_radius*2*x/baseVector.x*1.0605,
                center.longitude+square_radius*2*y/baseVector.y*1.0605),
            square_radius, baseVector);

        List<double> opacity = lController.opacity;

        print('!!!!');
        print({
          'tag':'1',
          'point_1_lat': map[2].latitude.toString(),
          'point_1_lon': map[2].longitude.toString(),
          'point_2_lat': map[4].latitude.toString(),
          'point_2_lon': map[4].longitude.toString(),
          'p1': opacity[0].toString(),
          'p2': lController.countConcurents.toString(),
          'p3': opacity[1].toString(),
          'p4': lController.countUnic.toString(),
          'p5': opacity[2].toString(),
          'p6': lController.countMoney.toString(),
          'p7': opacity[3].toString(),
          'p8': lController.plotnost.toString(),
          'p9': opacity[4].toString(),
          'p10': lController.countTrans.toString()
        });
        /////ASK!!!!!
        String resp = (await http.get(
            Uri.parse('http://178.21.11.177:9999/get_square_index'),
            headers: {
              'tag':'1',
              'point_1_lat': map[2].latitude.toString(),
              'point_1_lon': map[2].longitude.toString(),
              'point_2_lat': map[4].latitude.toString(),
              'point_2_lon': map[4].longitude.toString(),
              'p1': opacity[0].toString(),
              'p2': lController.countConcurents.toString(),
              'p3': opacity[1].toString(),
              'p4': lController.countUnic.toString(),
              'p5': opacity[2].toString(),
              'p6': lController.countMoney.toString(),
              'p7': opacity[3].toString(),
              'p8': lController.plotnost.toString(),
              'p9': opacity[4].toString(),
              'p10': lController.countTrans.toString()
            },
        )).body;

        print(resp);

        String fC = '';

        if (resp == '"green"') {
          fC = '#3cb371';
        } else if (resp == '"yellow"') {
          fC = '#c7b446';
        } else if (resp == '"red"') {
          fC = '#ff0000';
        }

        list.add(
          FillOptions(
              geometry: [map],
              fillOpacity:  0.2,
              fillColor: fC,
              fillOutlineColor: fC),
        );
      }
    }
    return list;
  }

  MapboxMapController? controller;

  double currentPos_x = 46.9541;
  double currentPos_y = 142.736;
  int id = 0;

  Point baseVector = Point(1.5, 1);
  double meter = 0.00000911;

  List<ShopElementController> shopControllers = [];

  void initState() {
    super.initState();


  }

  void onMapCreated(MapboxMapController controller) {
    this.controller = controller;
  }


  void onLoaded() async {

    //double size = 0.0005;
    //double width = size * 2 * baseVector.x;
    //double height = sqrt(3)/2 * size * 2 * baseVector.y;

    //double vert = width * 3/4;
    //double horiz = height;
    //int s = 13;
    
    //controller!.addFills(generateMap(LatLng(currentPos_x, currentPos_y), 1, meter*300, baseVector));

    controller!.onFillTapped.add((Fill fill) {

      controller!.clearCircles();
      setState(() {
        if (fill != user_fill && !isOpenLeft) {
          isOpenRight = true;

          //ASK!!!!
          http.get(
              Uri.parse('http://178.21.11.177:9999/get_full_statistic?tag=1&point_1_lat='
                  '${fill.options.geometry![0][2].latitude - (fill.options.geometry![0][4].latitude - fill.options.geometry![0][2].latitude)/4}'
                  '&point_1_lon='
                  '${fill.options.geometry![0][2].longitude - (fill.options.geometry![0][4].longitude - fill.options.geometry![0][2].longitude)/4}'
                  '&point_2_lat='
                  '${fill.options.geometry![0][4].latitude + (fill.options.geometry![0][4].latitude - fill.options.geometry![0][2].latitude)/4}'
                  '&point_2_lon='
                  '${fill.options.geometry![0][4].longitude  + (fill.options.geometry![0][4].longitude - fill.options.geometry![0][2].longitude)/4}')).then(
                  (value) => setState(
                          () {
                            print(utf8.decode(value.body.runes.toList()));
                            text = utf8.decode(value.body.runes.toList());
                            rController.response = json.decode(text);

                            controller!.addCircle(
                                CircleOptions(
                                  geometry: LatLng(
                                      fill.options.geometry![0][2].latitude + (fill.options.geometry![0][4].latitude - fill.options.geometry![0][2].latitude)/2,
                                      fill.options.geometry![0][2].longitude + (fill.options.geometry![0][4].longitude - fill.options.geometry![0][2].longitude)/2),
                                  circleRadius: 50,
                                  circleOpacity: 0.1,
                                  circleColor: '#df56eb',
                                )
                            );

                            shopControllers.clear();

                            for (Map m in rController.response['objects_in_square']) {
                              controller!.addCircle(
                                  CircleOptions(
                                    geometry: LatLng(m['Latitude'], m['Longitude']),
                                    circleRadius: 8,
                                    circleOpacity: 0.8,
                                    circleColor: '#3f77e7',
                                  )
                              );
                              shopControllers.add(ShopElementController(m['Name']));
                            }

                            rController.shopControllers = shopControllers;

                          })
          );
        }
      });
    });

  }

  onMapClick(Point point, LatLng latlng) async {
    if (isOpenLeft) {
      if (coordsOfFill.length == 1) {
        coordsOfFill.add(latlng);
        coordsOfFill.add(coordsOfFill.first);

        if (user_fill != null) {
          controller!.removeFill(user_fill!);
        }

        user_fill = await controller!.addFill(
            FillOptions(
                geometry: [[
                  LatLng(coordsOfFill[0].latitude, coordsOfFill[0].longitude),
                  LatLng(coordsOfFill[0].latitude, coordsOfFill[1].longitude),
                  LatLng(coordsOfFill[1].latitude, coordsOfFill[1].longitude),
                  LatLng(coordsOfFill[1].latitude, coordsOfFill[0].longitude),
                  LatLng(coordsOfFill[0].latitude, coordsOfFill[0].longitude),
                ]],
                fillOpacity: 0.3,
                fillColor: '#3cb371',
                fillOutlineColor: '#3cb371')
        ).then((big) {
          http.get(
              Uri.parse('http://178.21.11.177:9999/get_full_statistic?tag=1&point_1_lat='
                  '${coordsOfFill[0].latitude < coordsOfFill[1].latitude? coordsOfFill[0].latitude : coordsOfFill[1].latitude}'
                  '&point_1_lon='
                  '${coordsOfFill[0].longitude < coordsOfFill[1].longitude? coordsOfFill[0].longitude : coordsOfFill[1].longitude}'
                  '&point_2_lat='
                  '${coordsOfFill[0].latitude > coordsOfFill[1].latitude? coordsOfFill[0].latitude : coordsOfFill[1].latitude}'
                  '&point_2_lon='
                  '${coordsOfFill[0].longitude > coordsOfFill[1].longitude? coordsOfFill[0].longitude : coordsOfFill[1].longitude}')).then((value) {
                    RightMenuController.full = json.decode(
                        utf8.decode(
                            value.body.runes.toList())
                    );
                  });
          generateMapHard(
              LatLng((coordsOfFill[0].latitude + coordsOfFill[1].latitude)/2, (coordsOfFill[0].longitude + coordsOfFill[1].longitude)/2),
              ((coordsOfFill[0].latitude - coordsOfFill[1].latitude).abs()/meter/4/300*baseVector.x).round(),
              ((coordsOfFill[0].longitude - coordsOfFill[1].longitude).abs()/meter/4/300*baseVector.y).round(),
              meter*300,
              baseVector).then((value) {
                controller!.addFills(value);
                coordsOfFill.clear();
                controller!.removeFill(big);
              });
        });

        controller!.clearCircles();
      }
      else {
        coordsOfFill.add(latlng);

        controller!.clearFills();
        controller!.addCircle(
            CircleOptions(
              geometry: latlng,
              circleRadius: 5,
              circleOpacity: 1,
              circleColor: '#3cb371',
            )
        );
      }
    }
  }

  String text = '';

  bool isOpenLeft = false;
  bool isOpenRight = false;

  List<LatLng> coordsOfFill = [];
  Fill? user_fill;

  RightMenuController rController = RightMenuController();
  LeftMenuController lController = LeftMenuController();

  @override
  Widget build(BuildContext context) {

    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: screen_width,
              height: screen_height,
              alignment: Alignment.center,
              child: MapboxMap(
                accessToken: Consts.map_access_token,
                styleString: Consts.map_styleString,
                initialCameraPosition: CameraPosition(
                  zoom: 12.0,
                  target: LatLng(currentPos_x,currentPos_y),
                ),
                onMapCreated: onMapCreated,
                onStyleLoadedCallback: onLoaded,
                onMapClick: onMapClick
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: PointerInterceptor(
                  child: Padding(
                    padding: EdgeInsets.only(left: 80, top: 40),
                    child: SimpleElevatedCard(
                        width: 400,
                        height: 50,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                            hintText: "Поиск",
                          )),
                        )
                    ),
                  ),
                )
            ),


            Align(
                alignment: Alignment.centerLeft,
                child: PointerInterceptor(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isOpenLeft? 750:30,
                    height: screen_height,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: SvgPicture.asset('assets/Vector.svg', width: 15, height: 15),
                            onPressed: () {
                              setState(() {
                                isOpenLeft = !isOpenLeft;
                                isOpenRight = false;

                                controller!.clearCircles();
                                coordsOfFill.clear();

                                if (!isOpenLeft) {
                                  if (user_fill != null) {
                                    controller!.removeFill(user_fill!);
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: isOpenLeft? 700:0,
                            height: screen_height,
                            child:  ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
                              child: SingleChildScrollView(
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                    width: 700,
                                    color: Colors.white,
                                    height: double.infinity,
                                    child: Center(
                                        child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: LeftMenu(lController)
                                        )
                                    )
                                ),
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PointerInterceptor(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: isOpenRight? 1000:30,
                  height: screen_height,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: isOpenRight? 1000:0,
                          height: screen_height,
                          color: Colors.white,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
                            child:SingleChildScrollView(
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: RightMenu(rController),
                            )
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: TextButton(
                            child: SvgPicture.asset('assets/close.svg', width: 30, height: 30),
                            onPressed: () {
                              setState(() {
                                isOpenRight = false;
                              });
                            },
                          ),
                        )
                      )
                    ],
                  ),
                ),
              )
            ),
          ],
        )
      ),
    );
  }
}
