import 'dart:math';

import 'package:mapbox_gl/mapbox_gl.dart';

class OnMapDrawer {

  final List<_LinkableFill> _linkableFills = [];

  final MapboxMapController _mapboxMapController;

  OnMapDrawer(this._mapboxMapController);

  void updateMap(List<FillData> objects) async {

    List<_LinkableFill> removeSet = [];

    bool isContains = false;

    for (_LinkableFill linkableFill in _linkableFills) {

      for (FillData fillData in objects) {
        if (linkableFill.object == fillData) {
          linkableFill.object.id = fillData.id;
          isContains = true;
          break;
        }
      }
      if (!isContains)
        removeSet.add(linkableFill);
    }

    for (_LinkableFill parklotFill in removeSet) {
      //always has fill because of last for
      _mapboxMapController.removeFill(parklotFill.fill!);
      _linkableFills.remove(parklotFill);
    }


    for (FillData p in objects) {
      _LinkableFill linkableFill = _LinkableFill.fromObject(p);
      if (!_linkableFills.contains(linkableFill)) {

        linkableFill.fill = await _mapboxMapController.addFill(FillOptions(
          geometry: [p.geometry],
          fillColor: p.fillColor,
          fillOutlineColor: p.fillOutlineColor,
          fillOpacity: 0.3,
        ));

        _linkableFills.add(linkableFill);
      }
    }
  }

  bool contains(Fill fill) {
    for (_LinkableFill link in _linkableFills) {
      if (link.fill!.id == fill.id) {
        return true;
      }
    }
    return false;
  }

  int getByFill(Fill fill) {
    for (_LinkableFill link in _linkableFills) {
      if (link.fill!.id == fill.id) {
        return link.object.id;
      }
    }

    return -1;
  }
}

//Uses to compare with existing objects in redrawing process
class _LinkableFill {
  final FillData object;
  Fill? fill;

  _LinkableFill.fromObject(FillData this.object) {}

  @override
  bool operator ==(Object other) {
    if (other is _LinkableFill) {
      return object == other.object;
    } else {
      return false;
    }
  }
}

class FillData {
  int id;
  final List<LatLng> geometry;
  final String fillColor, fillOutlineColor;
  final double fillOpacity;

  FillData({
    required this.id,
    required this.geometry,
    required this.fillColor,
    required this.fillOpacity,
    required this.fillOutlineColor});

  bool operator ==(Object other) {
    if (other is FillData) {
      return id == other.id;
    } else {
      return false;
    }
  }
}