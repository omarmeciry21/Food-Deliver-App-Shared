import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/providers/location_provider.dart';
import 'package:food_delivery_app/providers/new_order_provider.dart';
import 'package:food_delivery_app/providers/restaurants_provider.dart';
import 'package:food_delivery_app/ui/screens/choose_delivery_address.dart';
import 'package:food_delivery_app/ui/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local/orders_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await await OrdersProvider.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const TextTheme kTextTheme = const TextTheme(
      headline1: TextStyle(color: Colors.black87, fontSize: 32),
      headline2: TextStyle(color: Colors.black87, fontSize: 28),
      headline3: TextStyle(color: Colors.black87, fontSize: 24),
      headline4: TextStyle(color: Colors.black87, fontSize: 20),
      headline5: TextStyle(color: Colors.black87, fontSize: 16),
      headline6: TextStyle(color: Colors.black87, fontSize: 12),
      bodyText1: TextStyle(color: Colors.black87, fontSize: 14),
      bodyText2: TextStyle(color: Colors.amber, fontSize: 14),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppPropertiesProvider()),
        ChangeNotifierProvider(create: (context) => NewOrderProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => RestaurantsProvider()),
      ],
      child: MaterialApp(
        title: 'Food Delivery',
        theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.amber,
            textTheme: kTextTheme,
            fontFamily: GoogleFonts.readexPro().fontFamily),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, animationVal, _) {
              return Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2 - 50) *
                        animationVal,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    // width: 100 * (animationVal * 2),
                    // height: 100 * (animationVal * 2),
                    child: Image.asset(
                        Provider.of<AppPropertiesProvider>(context).logoImg),
                  ),
                ],
              );
            },
            onEnd: () async {
              await Future.delayed(
                Duration(milliseconds: 250),
                () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  Provider.of<AppPropertiesProvider>(context, listen: false)
                      .language = prefs.getString("lang") ?? "en";
                  String session = prefs.getString("session") ?? "";
                  if (session != "") {
                    Navigator.pushReplacement(context, LoginScreenRoute());

                    Navigator.push(context, ChooseDeliveryAddressScreenRoute());
                  } else {
                    Navigator.pushReplacement(context, LoginScreenRoute());
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
