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
    "close": "Close"
  };

  Map<String, String> _strings = en_strings;

  Map<String, String> get strings => _strings;

  set strings(Map<String, String> value) {
    _strings = value;
    notifyListeners();
  }

  final String appName = "Food Delivery";
  String logoImg = "assets/images/food-delivery.png";
}
