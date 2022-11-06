import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/data/models/auth/login.dart';
import 'package:food_delivery_app/data/models/auth/login_response.dart';
import 'package:food_delivery_app/data/models/auth/verify_otp.dart';
import 'package:food_delivery_app/data/models/auth/verify_otp_response.dart';
import 'package:food_delivery_app/data/models/countries/countries_response.dart';
import 'package:food_delivery_app/data/models/user_details.dart';
import 'package:food_delivery_app/data/network/base_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthAPI {
  Future<LoginResponse> login(Login loginObj) async {
    try {
      print(loginObj.toJson());
      http.Response response = await BaseAPI.post(
        uri: 'auth/login?languageType=en',
        body: loginObj.toJson(),
      );
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in AUTHAPI->login: " + e.toString());
    }
  }

  Future<VerifyOTPResponse> verifyOTP(VerifyOTP verifyOTP) async {
    try {
      http.Response response = await BaseAPI.post(
          uri: 'auth/verifyOtp?languageType=en', body: verifyOTP.toJson());
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return VerifyOTPResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in AUTHAPI->verifyOTP: " + e.toString());
    }
  }

  Future<CountriesResponse> getCountries() async {
    try {
      http.Response response =
          await BaseAPI.get(uri: 'general?languageType=en');
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return CountriesResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in AUTHAPI->verifyOTP: " + e.toString());
    }
  }

  Future<UserDetails> getUserDetails(BuildContext context) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    String session = await prefs.getString("session") ?? "";
    try {
      if (session == "")
        throw (Provider.of<AppPropertiesProvider>(context)
            .strings["noSessionFound"]
            .toString());
      http.Response response =
          await BaseAPI.get(uri: 'user/info?languageType=ar&s=$session');
      if (response.statusCode <= 299 && response.statusCode >= 200) {
        return UserDetails.fromJson(jsonDecode(response.body));
      } else {
        throw ("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in AUTHAPI->verifyOTP: " + e.toString());
    }
  }
}
