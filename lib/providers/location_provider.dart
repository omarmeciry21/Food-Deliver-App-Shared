import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/data/models/find_place_response_model.dart';
import 'package:food_delivery_app/data/network/location_api.dart';

class LocationProvider extends ChangeNotifier {
  late Candidates _selectedAddress;
  List<Candidates> _searchResultsPlaces = [];

  List<Candidates> get searchResultsPlaces => _searchResultsPlaces;

  set searchResultsPlaces(List<Candidates> value) {
    _searchResultsPlaces = value;
    notifyListeners();
  }

  Candidates get selectedAddress => _selectedAddress;

  set selectedAddress(Candidates value) {
    _selectedAddress = value;
    notifyListeners();
  }

  Future searchForAddress(String query) async {
    if (query.length == 0) searchResultsPlaces = [];
    final FindPlaceResponse response = await LocationAPI.searchForPlace(query);
    if (response.status!.toUpperCase() == "OK") {
      searchResultsPlaces = response.candidates ?? [];
    }
  }
}
