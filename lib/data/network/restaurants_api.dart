import 'dart:convert';

import 'package:food_delivery_app/data/models/list_of_restaurants.dart';
import 'package:food_delivery_app/data/network/base_api.dart';
import 'package:http/http.dart' as http;

class RestaurantAPI {
  static Future<ListOfRestaurants> getListOfRestaurants(
      double lat, double lon, String language) async {
    try {
      http.Response response = await BaseAPI.get(
          uri: 'restaurant/list?languageType=$language&lat=$lat&lon=$lon');
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return ListOfRestaurants.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in RestaurantAPI->getListOfRestaurants: " +
          e.toString());
    }
  }
}
