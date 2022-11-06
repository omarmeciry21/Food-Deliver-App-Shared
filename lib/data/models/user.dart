class User {
  String? countryCode;
  String? phoneNumber;
  String? secondCountryCode;
  String? secondPhoneNumber;
  String? name;
  String? email;
  int? preferredLanguage;
  String? firebaseToken;

  User(
      {this.countryCode,
      this.phoneNumber,
      this.secondCountryCode,
      this.secondPhoneNumber,
      this.name,
      this.email,
      this.preferredLanguage,
      this.firebaseToken});

  User.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    secondCountryCode = json['second_country_code'];
    secondPhoneNumber = json['second_phone_number'];
    name = json['name'];
    email = json['email'];
    preferredLanguage = json['preferred_language'];
    firebaseToken = json['firebaseToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['second_country_code'] = this.secondCountryCode;
    data['second_phone_number'] = this.secondPhoneNumber;
    data['name'] = this.name;
    data['email'] = this.email;
    data['preferred_language'] = this.preferredLanguage;
    data['firebaseToken'] = this.firebaseToken;
    return data;
  }
}
