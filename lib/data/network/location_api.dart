import 'dart:convert';

import 'package:food_delivery_app/data/models/find_place_response_model.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as ll;

class LocationAPI {
  static const String apiKey = "AIzaSyB8Vz20OFhDQEI23HElHFSIGHmUai1xTlc";
  static Future<ll.LocationData> getCurrentLocation() async {
    ll.Location location = new ll.Location();

    bool _serviceEnabled;
    ll.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw ("Location services needed! Please, try again.");
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == ll.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != ll.PermissionStatus.granted) {
        throw ("Location permission needed! Please, try again.");
      }
    }

    return await location.getLocation();
  }

  static Future<FindPlaceResponse> searchForPlace(String query) async {
    try {
      final http.Response response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cbusiness_status%2Cformatted_address%2Cgeometry%2Cicon%2Cicon_mask_base_uri%2Cicon_background_color%2Cname%2Cphoto%2Cplace_id%2Cplus_code%2Ctype&input=$query&inputtype=textquery&key=$apiKey"));

      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return FindPlaceResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in LocationAPI->searchForPlace: " + e.toString());
    }
  }

  static Future<GeoData> getAddressFromLatLng(LatLng position) async {
    try {
      return await Geocoder2.getDataFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
          googleMapApiKey: apiKey);
      // assert(placemarks.length > 0, "No placemarks found!");
      // return placemarks[0];
    } catch (e) {
      throw ("Exception in LocationAPI->getAddressFromLatLng: " + e.toString());
    }
  }
}
