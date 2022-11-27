import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/orders_screen.dart';
import 'package:food_delivery_app/ui/screens/restaurants_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreenRoute extends CupertinoPageRoute {
  HomeScreenRoute({required this.locationData})
      : super(
            builder: (BuildContext context) =>
                HomeScreen(locationData: locationData));
  final LocationData locationData;
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation, child: HomeScreen(locationData: locationData));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.locationData}) : super(key: key);
  final LocationData locationData;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final screens;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screens = [
      RestaurantsScreen(locationData: widget.locationData),
      OrdersScreen(locationData: widget.locationData),
      Container()
    ];
    _currentIndex =
        Provider.of<AppPropertiesProvider>(context, listen: false).language ==
                "en"
            ? _currentIndex
            : 2 - _currentIndex;
    Provider.of<AppPropertiesProvider>(context, listen: false)
        .addOnLangChanged(() {
      if (_currentIndex == 2)
        _currentIndex = 0;
      else if (_currentIndex == 0) _currentIndex = 2;
    });
  }

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
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(Provider.of<AppPropertiesProvider>(context)
                      .strings["exitAppTitle"]
                      .toString()),
                  content: Text(Provider.of<AppPropertiesProvider>(context)
                      .strings["exitAppText"]
                      .toString()),
                  actions: [
                    TextButton(
                      child: Text(Provider.of<AppPropertiesProvider>(context)
                          .strings["cancel"]
                          .toString()),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text(
                        Provider.of<AppPropertiesProvider>(context)
                            .strings["OK"]
                            .toString(),
                        style: TextStyle(color: Colors.black87),
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                ));
        return false;
      },
      child: Scaffold(
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
          child: (Provider.of<AppPropertiesProvider>(context).language == "en"
              ? screens
              : screens.reversed.toList())[_currentIndex],
        ),
      ),
    );
  }
}
