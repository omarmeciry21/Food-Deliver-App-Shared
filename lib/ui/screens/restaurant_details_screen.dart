import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/widgets/global_app_bar.dart';

class RestaurantDetailsScreenRoute extends CupertinoPageRoute {
  RestaurantDetailsScreenRoute()
      : super(builder: (BuildContext context) => RestaurantDetailsScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: RestaurantDetailsScreen());
  }
}

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          GlobalAppBar(
            rightActions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
            leftActions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ),
        ],
      )),
    );
  }
}
