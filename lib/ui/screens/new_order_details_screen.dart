import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewOrderDetailsScreenRoute extends CupertinoPageRoute {
  NewOrderDetailsScreenRoute({required this.restaurantId})
      : super(
            builder: (BuildContext context) =>
                NewOrderDetailsScreen(restaurantId: restaurantId));
  int restaurantId;
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: NewOrderDetailsScreen(restaurantId: restaurantId));
  }
}

class NewOrderDetailsScreen extends StatefulWidget {
  NewOrderDetailsScreen({Key? key, required this.restaurantId})
      : super(key: key);
  int restaurantId;
  @override
  State<NewOrderDetailsScreen> createState() => _NewOrderDetailsScreenState();
}

class _NewOrderDetailsScreenState extends State<NewOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
