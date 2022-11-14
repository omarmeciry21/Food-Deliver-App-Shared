import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/data/models/list_of_restaurants.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';

import '../data/models/types.dart';

class RestaurantsProvider extends ChangeNotifier {
  ListOfRestaurants? _listOfRestaurants;

  ListOfRestaurants? get listOfRestaurants => _listOfRestaurants;

  set listOfRestaurants(ListOfRestaurants? value) {
    _listOfRestaurants = value;
    notifyListeners();
  }

  List<Restaurants>? get displayedRestaurants {
    if (selectedTypes.isEmpty) return listOfRestaurants!.restaurants ?? [];
    return listOfRestaurants?.restaurants?.where((element) {
      print(element.toJson());

      return element.types!.length == 0
          ? false
          : selectedTypes
              .where((element2) => element2.id == element.types!.first.id)
              .toList()
              .isNotEmpty;
    }).toList();
  }

  List<Types> _selectedTypes = [];

  List<Types> get selectedTypes => _selectedTypes;

  set selectedTypes(List<Types> value) {
    _selectedTypes = value;
    notifyListeners();
  }

  addType(Types t) {
    selectedTypes.add(t);
    notifyListeners();
  }

  removeType(Types t) {
    selectedTypes.removeWhere((element) => element.id == t.id);
    notifyListeners();
  }
}
