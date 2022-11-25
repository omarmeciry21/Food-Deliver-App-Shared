class OrdersListResponse {
  bool? status;
  String? message;
  List<Orders>? orders;

  OrdersListResponse({this.status, this.message, this.orders});

  OrdersListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? orderNumber;
  Restaurant? restaurant;
  int? totalPrice;
  int? status;
  String? statusDescription;

  Orders(
      {this.id,
      this.orderNumber,
      this.restaurant,
      this.totalPrice,
      this.status,
      this.statusDescription});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    totalPrice = json['total_price'];
    status = json['status'];
    statusDescription = json['status_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['status_description'] = this.statusDescription;
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
