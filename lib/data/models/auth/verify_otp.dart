class VerifyOTP {
  String? code;
  String? phone;
  String? otp;

  VerifyOTP({this.code, this.phone, this.otp});

  VerifyOTP.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    phone = json['phone'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    return data;
  }
}