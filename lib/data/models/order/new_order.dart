import 'dart:convert';

class NewOrder {
  int? restaurantId;
  int? paymentMethod;
  String? latitude;
  String? longitude;
  String? addressInformation;
  double? deliveryPrice;
  List<Meals>? meals;

  NewOrder(
      {this.restaurantId,
      this.paymentMethod,
      this.latitude,
      this.longitude,
      this.addressInformation,
      this.deliveryPrice,
      this.meals});

  NewOrder.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    paymentMethod = json['paymentMethod'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressInformation = json['addressInformation'];
    deliveryPrice = json['deliveryPrice'];
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(new Meals.fromJson(v));
      });
    }
  }
  NewOrder.fromLocalJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    paymentMethod = json['paymentMethod'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressInformation = json['addressInformation'];
    deliveryPrice = json['deliveryPrice'];
    print(json['meals']);
    if (json['meals'] != null && json['meals'] != "null") {
      meals = [];
      (jsonDecode(json['meals']) ?? <Map>[])
          .forEach((e) => meals?.add(Meals.fromJson(e)));
    } else {
      meals = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['paymentMethod'] = this.paymentMethod;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['addressInformation'] = this.addressInformation;
    data['deliveryPrice'] = this.deliveryPrice;

    if (this.meals != null) {
      data['meals'] = this.meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toLocalJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['paymentMethod'] = this.paymentMethod;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['addressInformation'] = this.addressInformation;
    data['deliveryPrice'] = this.deliveryPrice;
    print('|||||||');
    data['meals'] = jsonEncode(this.meals);

    return data;
  }

  double get totalPrice {
    double sum = 0;
    (meals ?? []).forEach((element) {
      sum += element.price! * (element.quantity ?? 0);
    });
    sum += deliveryPrice ?? 0;
    return sum;
  }
}

class Meals {
  int? id;
  double? price;
  int? quantity;
  List<AddsOn>? addsOn;

  Meals({this.id, this.price, this.quantity, this.addsOn});

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
    if (json['addsOn'] != null) {
      addsOn = <AddsOn>[];
      json['addsOn'].forEach((v) {
        addsOn!.add(new AddsOn.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    if (this.addsOn != null) {
      data['addsOn'] = this.addsOn!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddsOn {
  int? id;
  List<int>? elements;

  AddsOn({this.id, this.elements});

  AddsOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elements = json['elements'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['elements'] = this.elements;
    return data;
  }
}
