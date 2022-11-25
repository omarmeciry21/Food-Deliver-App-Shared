import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart';

class NewOrderProvider extends ChangeNotifier {
  NewOrder? _newOrder;

  NewOrder? get newOrder => _newOrder;

  set newOrder(NewOrder? value) {
    _newOrder = value;
    notifyListeners();
  }

  addMeal(Meals meal) {
    _newOrder!.meals!.add(meal);
    notifyListeners();
  }
}
