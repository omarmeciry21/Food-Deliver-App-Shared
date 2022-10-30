import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

class VerifyOTPScreenRoute extends CupertinoPageRoute {
  String last2DigitFromMobileNumber;
  VerifyOTPScreenRoute(this.last2DigitFromMobileNumber)
      : super(
            builder: (BuildContext context) => VerifyOTPScreen(
                last2DigitFromMobileNumber: last2DigitFromMobileNumber));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: VerifyOTPScreen(
            last2DigitFromMobileNumber: last2DigitFromMobileNumber));
  }
}

class VerifyOTPScreen extends StatefulWidget {
  VerifyOTPScreen({Key? key, required this.last2DigitFromMobileNumber})
      : super(key: key);
  String last2DigitFromMobileNumber;
  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String selectedCode = "+966";
  final pin1Controller = TextEditingController();
  final pin2Controller = TextEditingController();
  final pin3Controller = TextEditingController();
  final pin4Controller = TextEditingController();
  final pin5Controller = TextEditingController();
  final pin6Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).accentColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings["back"]
                        .toString(),
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["verifyNumberTitle"]
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
                        .strings["verifyNumberText"]
                        .toString() +
                    "\n" +
                    "*********" +
                    widget.last2DigitFromMobileNumber,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  height: 70,
                  child: TextFormField(
                    controller: pin1Controller,
                    onChanged: (newVal) {
                      if (newVal.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin1) {},
                    decoration: InputDecoration(
                        hintText: "X",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26))),
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  height: 70,
                  child: TextFormField(
                    controller: pin2Controller,
                    onChanged: (newVal) {
                      if (newVal.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin1) {},
                    decoration: InputDecoration(
                        hintText: "X",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26))),
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  height: 70,
                  child: TextFormField(
                    controller: pin3Controller,
                    onChanged: (newVal) {
                      if (newVal.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin1) {},
                    decoration: InputDecoration(
                        hintText: "X",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26))),
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  height: 70,
                  child: TextFormField(
                    controller: pin4Controller,
                    onChanged: (newVal) {
                      if (newVal.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin1) {},
                    decoration: InputDecoration(
                        hintText: "X",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26))),
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  height: 70,
                  child: TextFormField(
                    controller: pin5Controller,
                    onChanged: (newVal) {
                      if (newVal.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin1) {},
                    decoration: InputDecoration(
                        hintText: "X",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26))),
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 60,
                  height: 70,
                  child: TextFormField(
                    controller: pin6Controller,
                    onChanged: (newVal) {
                      if (newVal.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin1) {},
                    decoration: InputDecoration(
                        hintText: "X",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26))),
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                  Navigator.push(context, HomeScreenRoute());
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
