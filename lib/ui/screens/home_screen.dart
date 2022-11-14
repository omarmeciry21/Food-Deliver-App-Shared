import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/restaurants_screen.dart';
import 'package:provider/provider.dart';

class HomeScreenRoute extends CupertinoPageRoute {
  HomeScreenRoute() : super(builder: (BuildContext context) => HomeScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final itemsList = [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home_rounded,
            size: 20,
          ),
          label: Provider.of<AppPropertiesProvider>(context)
              .strings["home"]
              .toString()),
      BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/orders-icon.png",
            height: 20,
            color: _currentIndex == 1
                ? Theme.of(context).primaryColor
                : Colors.black54,
          ),
          label: Provider.of<AppPropertiesProvider>(context)
              .strings["orders"]
              .toString()),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          label: Provider.of<AppPropertiesProvider>(context)
              .strings["others"]
              .toString()),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: Provider.of<AppPropertiesProvider>(context).language == "en"
              ? itemsList
              : itemsList.reversed.toList()),
      body: SafeArea(
        child: [RestaurantsScreen(), Container(), Container()][_currentIndex],
      ),
    );
  }
}
