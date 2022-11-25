class OrdersDetailsResponse {
  bool? status;
  String? message;
  Order? order;

  OrdersDetailsResponse({this.status, this.message, this.order});

  OrdersDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? id;
  String? orderNumber;
  int? totalPrice;
  int? orderPrice;
  int? deliveryPrice;
  int? paymentMethod;
  String? paymentMethodDescription;
  int? status;
  String? statusDescription;
  Null? deliveredAt;
  Restaurant? restaurant;
  Address? address;
  List<Meals>? meals;

  Order(
      {this.id,
      this.orderNumber,
      this.totalPrice,
      this.orderPrice,
      this.deliveryPrice,
      this.paymentMethod,
      this.paymentMethodDescription,
      this.status,
      this.statusDescription,
      this.deliveredAt,
      this.restaurant,
      this.address,
      this.meals});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    totalPrice = json['total_price'];
    orderPrice = json['order_price'];
    deliveryPrice = json['delivery_price'];
    paymentMethod = json['payment_method'];
    paymentMethodDescription = json['payment_method_description'];
    status = json['status'];
    statusDescription = json['status_description'];
    deliveredAt = json['delivered_at'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(new Meals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['total_price'] = this.totalPrice;
    data['order_price'] = this.orderPrice;
    data['delivery_price'] = this.deliveryPrice;
    data['payment_method'] = this.paymentMethod;
    data['payment_method_description'] = this.paymentMethodDescription;
    data['status'] = this.status;
    data['status_description'] = this.statusDescription;
    data['delivered_at'] = this.deliveredAt;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.meals != null) {
      data['meals'] = this.meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  int? id;
  String? name;
  String? logo;

  Restaurant({this.id, this.name, this.logo});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    return data;
  }
}

class Address {
  double? latitude;
  double? longitude;
  String? addressInformation;

  Address({this.latitude, this.longitude, this.addressInformation});

  Address.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressInformation = json['address_information'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address_information'] = this.addressInformation;
    return data;
  }
}

class Meals {
  int? id;
  String? name;
  String? description;
  double? price;
  int? quantity;
  String? image;
  List<AddOns>? addOns;

  Meals(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.quantity,
      this.image,
      this.addOns});

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
    if (json['addOns'] != null) {
      addOns = <AddOns>[];
      json['addOns'].forEach((v) {
        addOns!.add(new AddOns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    if (this.addOns != null) {
      data['addOns'] = this.addOns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddOns {
  String? name;

  AddOns({this.name});

  AddOns.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
