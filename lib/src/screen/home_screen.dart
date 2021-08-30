import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_find_place/block/application_block.dart';
import 'package:google_map_find_place/model/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;

  @override
  void dispose() {
    final applicationBlock =
        Provider.of<ApplicationBlock>(context, listen: false);
    applicationBlock.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final applicationBlock =
        Provider.of<ApplicationBlock>(context, listen: false);

    locationSubscription =
        applicationBlock.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBlock = Provider.of<ApplicationBlock>(context);
    return Scaffold(
      body: (applicationBlock.currentLocation == null)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Location',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      applicationBlock.searchPlaces(value);
                    },
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 300.0,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              applicationBlock.currentLocation.latitude,
                              applicationBlock.currentLocation.longitude),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                        },
                      ),
                    ),
                    if (applicationBlock.searchResults != null &&
                        applicationBlock.searchResults.length != 0)
                      Container(
                        height: 300.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                            .6,
                          ),
                          backgroundBlendMode: BlendMode.darken,
                        ),
                      ),
                    if (applicationBlock.searchResults != null &&
                        applicationBlock.searchResults.length != 0)
                      Container(
                        height: 300.0,
                        child: ListView.builder(
                            itemCount: applicationBlock.searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  applicationBlock
                                      .searchResults[index].description,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  applicationBlock.setSelectedLocation(
                                      applicationBlock
                                          .searchResults[index].placeId);
                                },
                              );
                            }),
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              place.geometry.location.lat,
              place.geometry.location.lng,
            ),
            zoom: 14.0),
      ),
    );
  }
}
// #  provider: ^4.3.3
// #  geolacator: ^6.2.1
// #  http: ^0.12.2
// #  google_maps_flutter: ^1.2.0
