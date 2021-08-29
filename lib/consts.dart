import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Consts {
  static const String map_access_token = "pk.eyJ1IjoicGl0dXNhbm9uaW1vdXMiLCJhIjoiY2twcHk5M2VtMDZvZjJ2bzEzMHNhNDM1diJ9.8BLcJknh8FvUVLJRZbHJDQ";
  static const String map_styleString = "mapbox://styles/pitusanonimous/ckpq0eydh0tk318mr0dcw773k";

  static const String geocoder_locale = 'rus';

  static const TextStyle button_text_style = TextStyle(color: Colors.white, fontSize: 18);

  static final MaterialStateProperty<OutlinedBorder> button_shape = MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )
  );
}