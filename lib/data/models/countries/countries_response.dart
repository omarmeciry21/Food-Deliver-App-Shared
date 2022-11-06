import 'countries.dart';

class CountriesResponse {
  bool? status;
  List<Countries>? countries;

  CountriesResponse({this.status, this.countries});

  CountriesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
