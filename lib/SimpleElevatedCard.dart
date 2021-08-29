import 'package:flutter/material.dart';

class SimpleElevatedCard extends StatelessWidget {

  Widget? child;
  BoxShadow boxShadow;
  BorderRadius borderRadius;
  Color color;
  double width, height;

  SimpleElevatedCard({
    this.child,
    this.boxShadow = const BoxShadow(
        spreadRadius: -10,
        blurRadius: 15,
        color: Color(0x43343434)
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(25)),
    this.color = const Color(0xFFFFFFFF),
    this.width = double.infinity,
    this.height = double.infinity
  });


  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            boxShadow: [
              boxShadow
            ]
        ),
        child: Center(
          child: child,
        ),
    );
  }
}