import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/verify_otp_screen.dart';
import 'package:provider/provider.dart';

class LoginScreenRoute extends CupertinoPageRoute {
  LoginScreenRoute()
      : super(builder: (BuildContext context) => new LoginScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedCode = "+966";
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["cancel"]
                    .toString(),
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["enterMobileNumberTitle"]
                    .toString(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["enterMobileNumberText"]
                    .toString(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: DropdownButton<String>(
                    value: selectedCode,
                    items: ["+966", "+20"].map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCode = newValue.toString();
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    underline: SizedBox(),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 200,
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black26)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          hintText: "XXXXXXXXX"),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  //TODO: implement phone number
                  Navigator.push(
                    context,
                    VerifyOTPScreenRoute(
                      phoneNumberController.text
                          .substring(phoneNumberController.text.length - 2),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                  padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                ),
                child: Text(
                  Provider.of<AppPropertiesProvider>(context)
                      .strings["continue"]
                      .toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
