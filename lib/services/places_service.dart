import 'package:flutter/material.dart';
import 'package:google_map_find_place/model/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:google_map_find_place/model/place_search.dart';

class PlacesService {
  final key = 'AIzaSyAykbt-7WYnyT7qLoK9gt-cmXKkW4LZ5S0';

  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['predictions'] as List;
    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
//'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
// https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4
// // &key=AIzaSyAykbt-7WYnyT7qLoK9gt-cmXKkW4LZ5S0
