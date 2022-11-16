import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealDetailsScreenRoute extends CupertinoPageRoute {
  MealDetailsScreenRoute()
      : super(builder: (BuildContext context) => MealDetailsScreen());
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: MealDetailsScreen());
  }
}

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
