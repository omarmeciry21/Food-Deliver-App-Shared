class VerifyOTPResponse {
  bool? status;
  UserSession? user;
  String? message;

  VerifyOTPResponse({this.status, this.user, this.message});

  VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new UserSession.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.message != null) data['message'] = this.message;
    return data;
  }
}

class UserSession {
  String? session;

  UserSession({this.session});

  UserSession.fromJson(Map<String, dynamic> json) {
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session'] = this.session;
    return data;
  }
}
