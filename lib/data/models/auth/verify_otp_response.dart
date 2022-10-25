class VerifyOTPResponse {
  bool? status;
  User? user;
  String? message;

  VerifyOTPResponse({this.status, this.user, this.message});

  VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if(this.message!=null)
    data['message'] = this.message;
    return data;
  }
}

class User {
  String? session;

  User({this.session});

  User.fromJson(Map<String, dynamic> json) {
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session'] = this.session;
    return data;
  }
}