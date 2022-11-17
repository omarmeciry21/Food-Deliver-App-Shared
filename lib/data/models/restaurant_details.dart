class RestaurantDetailsResponse {
  bool? status;
  Details? details;
  List<Categories>? categories;

  RestaurantDetailsResponse({this.status, this.details, this.categories});

  RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
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

  Details(
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

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
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

class Types {
  int? id;
  String? name;

  Types({this.id, this.name});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  List<Meals>? meals;

  Categories({this.id, this.name, this.meals});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
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
    data['name'] = this.name;
    if (this.meals != null) {
      data['meals'] = this.meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meals {
  int? id;
  String? name;
  String? description;
  double? price;
  String? image;
  List<AddOns>? addOns;

  Meals(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.image,
      this.addOns});

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = double.parse(json['price'].toString());
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
    data['image'] = this.image;
    if (this.addOns != null) {
      data['addOns'] = this.addOns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  bool? single;
  List<Elements>? elements;

  AddOns({this.id, this.name, this.single, this.elements});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    single = json['single'];
    if (json['elements'] != null) {
      elements = <Elements>[];
      json['elements'].forEach((v) {
        elements!.add(new Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['single'] = this.single;
    if (this.elements != null) {
      data['elements'] = this.elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  int? id;
  String? name;

  Elements({this.id, this.name});

  Elements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
