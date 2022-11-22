import 'package:flutter/cupertino.dart';

class AppPropertiesProvider extends ChangeNotifier {
  static Map<String, String> ar_strings = {
    "cancel": "إلغاء",
    "back": "الرجوع",
    "filter": "تصفية",
    "logout": "تسجيل الخروج",
    "home": "الرئيسية",
    "orders": "الطلبات",
    "others": "أخرى",
    "enterMobileNumberTitle": "أدخل رقم هاتفك",
    "enterMobileNumberText": "ادخل رقم التواصل الخاص بك على تطبيق الواتس اب.",
    "continue": "إستمرار",
    "verifyNumberTitle": "التحقق من رقمك",
    "verifyNumberText": "أدخل الكود الذي تم إرساله إلى رقم ",
    "open": "مفتوح",
    "close": "مغلق",
    "anErrorOccurred": "حدث خطأ! برجاء إعادة المحاولة",
    "addresses": "العناوين",
    "noSessionFound": "برجاء إعادة تسجيل الدخول",
    "newAddress": "عنوان جديد",
    "confirmLocation": "تأكيد المكان",
    "deliveryLocation": "مكان التوصيل",
    "addressName": "اسم العنوان",
    "requiredField": "برجاء إدخال هذه البيانات.",
    "addressDetails": "مثال: رقم البناية, رقم الفيلا, رقم الشقة",
    "OK": "حسناً",
    "cancel": "إلغاء",
    "add": "إضافة",
    "menu": "القائمة",
    "deleteAddressTitle": "حذف العنوان",
    "deleteAddressContent": "هل أنت متأكد من حذف هذا العنوان؟",
    "searchMealText": "علامَّ تبحث؟",
    "sar": "ر.س.",
    "exitAppTitle": "الخروج من التطبيق",
    "exitAppText": "هل أنت متأكد أنك تريد إغلاق التطبيق؟",
    "confirmDeliveryAddress": "تأكيد العنوان",
    "clickToTryAgain": "اضغط هنا لإعادة المحاولة",
    "noInternet":
        "لا يوجد إتصال بالإنترنت! برجاء التحقق من اتصال الهاتف بالإنترنت وإعادة المحاولة."
  };
  static Map<String, String> en_strings = {
    "cancel": "Cancel",
    "filter": "Filter",
    "sar": "SAR",
    "logout": "Log Out",
    "back": "Back",
    "home": "Home",
    "orders": "Orders",
    "others": "Others",
    "enterMobileNumberTitle": "Enter your mobile number",
    "enterMobileNumberText": "Enter your what's app phone number.",
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
    "addressDetails": "Ex: Building / Appartment / Villa number.",
    "OK": "OK",
    "add": "Add",
    "cancel": "cancel",
    "menu": "Menu",
    "deleteAddressTitle": "Delete Address",
    "deleteAddressContent": "Are you sure you want to delete this address?",
    "searchMealText": "What are you looking for?",
    "exitAppTitle": "Exit App",
    "exitAppText": "Are you sure you want to close the app?",
    "confirmDeliveryAddress": "Confirm Delivery Address",
    "clickToTryAgain": "Click here to try again...",
    "noInternet":
        "No internet connection! Please, check your internet connectivity and try again."
  };
  String _language = "en";

  String get language => _language;

  set language(String value) {
    _language = value;
    _onLangChangedList.forEach((element) {
      element();
    });
    notifyListeners();
  }

  late Map<String, String> _strings;

  Map<String, String> get strings => language == "ar" ? ar_strings : en_strings;

  set strings(Map<String, String> value) {
    _strings = value;
    notifyListeners();
  }

  final String appName = "Food Delivery";
  String logoImg = "assets/images/food-delivery.png";

  List<Function> _onLangChangedList = [];
  void addOnLangChanged(void Function() function) {
    _onLangChangedList.add(function);
  }
}
