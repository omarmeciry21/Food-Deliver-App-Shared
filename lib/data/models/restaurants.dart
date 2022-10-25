import 'package:food_delivery_app/data/models/types.dart';

class Restaurants {
  int? id;
  String? name;
  String? description;
  double? latitude;
  double? longitude;
  String? logo;
  String? coverImage;
  String? distance;
  bool? isOpen;
  String? workingHours;
  List<Types>? types;

  Restaurants(
      {this.id,
        this.name,
        this.description,
        this.latitude,
        this.longitude,
        this.logo,
        this.coverImage,
        this.distance,
        this.isOpen,
        this.workingHours,
        this.types});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
    coverImage = json['cover_image'];
    distance = json['distance'];
    isOpen = json['isOpen'];
    workingHours = json['workingHours'];
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(new Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['logo'] = this.logo;
    data['cover_image'] = this.coverImage;
    data['distance'] = this.distance;
    data['isOpen'] = this.isOpen;
    data['workingHours'] = this.workingHours;
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}