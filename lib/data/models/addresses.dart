class Addresses {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  String? details;
  String? addressLine;

  Addresses(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.details,
      this.addressLine});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    details = json['details'];
    if (json["addressLine"] != null) details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['details'] = this.details;

    if (this.details != null) data['addAddress'] = this.details;
    return data;
  }
}
