import 'package:google_map_find_place/model/location.dart';

class Geometry {
  final Location location;
  Geometry({this.location});

  factory Geometry.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Geometry(location: Location.fromJson(parsedJson['location']));
  }
}
