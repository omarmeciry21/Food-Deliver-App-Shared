class LoginResponse {
  bool? status;
  String? message;

  LoginResponse({this.status, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if(this.message!=null)
      data['message'] = this.message;
    return data;
  }
}