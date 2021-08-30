import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_find_place/model/place.dart';
import 'package:google_map_find_place/model/place_search.dart';
import 'package:google_map_find_place/services/geolocator_services.dart';
import 'package:google_map_find_place/services/places_service.dart';

class ApplicationBlock extends ChangeNotifier {
  final getLocatorService = GeolocatorService();
  final placesService = PlacesService();

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  StreamController<Place> selectedLocation = StreamController<Place>();

  ApplicationBlock() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await GeolocatorService().getCurrentLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await placesService.getPlace(placeId));
    searchResults = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
}
