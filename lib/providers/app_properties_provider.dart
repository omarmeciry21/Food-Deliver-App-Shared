import 'package:flutter/cupertino.dart';

class AppPropertiesProvider extends ChangeNotifier {
  static Map<String, String> ar_strings = {};
  static Map<String, String> en_strings = {
    "cancel": "Cancel",
    "back": "Back",
    "enterMobileNumberTitle": "Enter your mobile number",
    "enterMobileNumberText":
        "Enter your mobile number to create or login you account.",
    "continue": "Continue",
    "verifyNumberTitle": "Verify your number",
    "verifyNumberText": "Enter the 6-digits code sent to ",
    "open": "Open",
    "close": "Close",
    "anErrorOccurred": "An error occurred! Please, try again.",
    "addresses": "Addresses",
    "noSessionFound": "No session key found! Please, login and try again.",
    "newAddress": "New Address",
    "confirmLocation": "Confirm Location",
    "deliveryLocation": "Delivery Location",
    "addressName": "Address Label",
    "requiredField": "This field is required.",
    "addressDetails": "Please, enter more details about delivery address.",
    "OK": "OK",
    "cancel": "cancel",
    "deleteAddressTitle": "Delete Address",
    "deleteAddressContent": "Are you sure you want to delete this address?"
  };
  String _language = "en";

  String get language => _language;

  set language(String value) {
    _language = value;
    notifyListeners();
  }

  late Map<String, String> _strings;

  Map<String, String> get strings => language == "en" ? en_strings : ar_strings;

  set strings(Map<String, String> value) {
    _strings = value;
    notifyListeners();
  }

  final String appName = "Food Delivery";
  String logoImg = "assets/images/food-delivery.png";
}
