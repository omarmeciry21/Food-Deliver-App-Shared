import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/data/models/order/orders_list_response.dart';
import 'package:food_delivery_app/data/network/base_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order/new_order.dart';
import '../models/order/new_order_response.dart';

class OrdersAPI {
  Future<NewOrderResponse> sendNewOrder(
      {required BuildContext context, required NewOrder newOrder}) async {
    String session =
        await (await SharedPreferences.getInstance()).getString("session") ??
            "";
    try {
      await checkInternetConnection();
      if (session == "")
        throw (Provider.of<AppPropertiesProvider>(context)
            .strings["noSessionFound"]
            .toString());
      print(session);
      http.Response response = await BaseAPI.post(
          uri:
              'order/new?s=$session&languageType=${Provider.of<AppPropertiesProvider>(context, listen: false).language}',
          body: jsonEncode(newOrder.toJson()));
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return NewOrderResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } on NoInternetConnectionException catch (e) {
      rethrow;
    } catch (e) {
      print('isINM');
      print(jsonEncode(newOrder.toJson()));
      throw ("Exception in OrdersAPI->sendNewOrder: " + e.toString());
    }
  }

  Future<OrdersListResponse> getOrdersList(BuildContext context) async {
    String session =
        await (await SharedPreferences.getInstance()).getString("session") ??
            "";

    try {
      if (session == "")
        throw (Provider.of<AppPropertiesProvider>(context)
            .strings["noSessionFound"]
            .toString());
      http.Response response = await BaseAPI.get(
          uri:
              'order/list?s=$session&languageType=${Provider.of<AppPropertiesProvider>(context, listen: false).language}');
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return OrdersListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } on NoInternetConnectionException catch (e) {
      rethrow;
    } catch (e) {
      throw ("Exception in OrdersAPI->getOrdersList: " + e.toString());
    }
  }
}
