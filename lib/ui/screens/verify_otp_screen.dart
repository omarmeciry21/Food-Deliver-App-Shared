import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/data/models/auth/verify_otp.dart';
import 'package:food_delivery_app/data/models/auth/verify_otp_response.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/home_screen.dart';
import 'package:food_delivery_app/ui/widgets/language_custom_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/auth_api.dart';
import '../widgets/dialogs.dart';

class VerifyOTPScreenRoute extends CupertinoPageRoute {
  String phoneNum;
  String phoneCode;
  VerifyOTPScreenRoute({required this.phoneNum, required this.phoneCode})
      : super(
            builder: (BuildContext context) =>
                VerifyOTPScreen(phoneNum: phoneNum, phoneCode: phoneCode));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: VerifyOTPScreen(phoneNum: phoneNum, phoneCode: phoneCode));
  }
}

class VerifyOTPScreen extends StatefulWidget {
  VerifyOTPScreen({Key? key, required this.phoneNum, required this.phoneCode})
      : super(key: key);
  String phoneNum, phoneCode;
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
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
                  Expanded(child: Container()),
                  LanguagesCustomWidget(),
                ],
              ),
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
                    List.generate(widget.phoneNum.length - 2, (index) => "*")
                        .join() +
                    widget.phoneNum.substring(widget.phoneNum.length - 2),
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
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 70,
                    child: TextFormField(
                      controller: pin1Controller,
                      onChanged: (newVal) {
                        if (newVal.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => (v ?? "").length == 0 ? "" : null,
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
                    width: 40,
                    height: 70,
                    child: TextFormField(
                      controller: pin2Controller,
                      onChanged: (newVal) {
                        if (newVal.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => (v ?? "").length == 0 ? "" : null,
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
                    width: 40,
                    height: 70,
                    child: TextFormField(
                      controller: pin3Controller,
                      onChanged: (newVal) {
                        if (newVal.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => (v ?? "").length == 0 ? "" : null,
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
                    width: 40,
                    height: 70,
                    child: TextFormField(
                      controller: pin4Controller,
                      onChanged: (newVal) {
                        if (newVal.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => (v ?? "").length == 0 ? "" : null,
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
                    width: 40,
                    height: 70,
                    child: TextFormField(
                      controller: pin5Controller,
                      onChanged: (newVal) {
                        if (newVal.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => (v ?? "").length == 0 ? "" : null,
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
                    width: 40,
                    height: 70,
                    child: TextFormField(
                      controller: pin6Controller,
                      onChanged: (newVal) {
                        if (newVal.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      validator: (v) => (v ?? "").length == 0 ? "" : null,
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
            ),
            Expanded(child: Container()),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  //TODO: implement phone number
                  if (_formKey.currentState!.validate()) {
                    showLoadingDialog(context);
                    VerifyOTPResponse response =
                        VerifyOTPResponse(status: false);
                    try {
                      response = await AuthAPI().verifyOTP(VerifyOTP(
                          phone: widget.phoneNum,
                          code: widget.phoneCode,
                          otp: pin1Controller.text +
                              pin2Controller.text +
                              pin3Controller.text +
                              pin3Controller.text +
                              pin4Controller.text +
                              pin5Controller.text +
                              pin6Controller.text));
                    } catch (e) {
                      print(e.toString());
                      response.message = e.toString();
                    }
                    await (await SharedPreferences.getInstance())
                        .setString("session", response.user!.session ?? "");
                    Navigator.pop(context);
                    if (response.status ?? false) {
                      Navigator.push(context, HomeScreenRoute());
                    } else {
                      print(response.toJson());
                      showErrorDialog(context,
                          errorMessage: response.message ??
                              Provider.of<AppPropertiesProvider>(context)
                                  .strings["anErrorOccurred"]
                                  .toString());
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                  padding: MaterialStateProperty.all(EdgeInsets.all(8)),
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
