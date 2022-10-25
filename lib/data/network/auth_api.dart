import 'dart:convert';

import 'package:food_delivery_app/data/models/auth/login.dart';
import 'package:food_delivery_app/data/models/auth/verify_otp.dart';
import 'package:food_delivery_app/data/models/auth/verify_otp_response.dart';
import 'package:food_delivery_app/data/network/base_api.dart';
import 'package:food_delivery_app/data/models/auth/login_response.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  Future<LoginResponse> login(Login loginObj) async {
    try {
      http.Response response =
          await BaseAPI.post(uri: 'auth/login?languageType=en', body: loginObj.toString());
      if(response.statusCode<=299&&response.statusCode>=200){
        return LoginResponse.fromJson(jsonDecode(response.body));
      }else{
        throw("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in AUTHAPI->login: " + e.toString());
    }
  }
  Future<VerifyOTPResponse> verifyOTP(VerifyOTP verifyOTP) async {
    try {
      http.Response response =
          await BaseAPI.post(uri: 'auth/verifyOtp?languageType=en', body: verifyOTP.toJson());
      if(response.statusCode<=299&&response.statusCode>=200){
        return VerifyOTPResponse.fromJson(jsonDecode(response.body));
      }else{
        throw("${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw ("Exception in AUTHAPI->verifyOTP: " + e.toString());
    }
  }
}
