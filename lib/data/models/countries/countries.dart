class Countries {
  int? id;
  String? countryCode;
  String? name;
  String? flag;

  Countries({this.id, this.countryCode, this.name, this.flag});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    name = json['name'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_code'] = this.countryCode;
    data['name'] = this.name;
    data['flag'] = this.flag;
    return data;
  }
}
