import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/auth/login.dart';
import 'package:food_delivery_app/data/models/auth/login_response.dart';
import 'package:food_delivery_app/data/models/countries/countries.dart';
import 'package:food_delivery_app/data/network/auth_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/verify_otp_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/dialogs.dart';
import '../widgets/language_custom_widget.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                LanguagesCustomWidget(),
              ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 60,
                  child: FutureBuilder(
                      future: AuthAPI().getCountries(),
                      builder: (context, snapshot) {
                        List<Countries> countries = [];
                        if (snapshot.hasData) {
                          countries = [];
                          (snapshot.data!.countries ?? []).forEach((element1) {
                            if (countries
                                .where((element2) =>
                                    element1.countryCode ==
                                    element2.countryCode)
                                .toList()
                                .isEmpty) {
                              countries.add(element1);
                            }
                          });
                          selectedCode = countries!.length == 0
                              ? selectedCode
                              : countries!.first!.countryCode!;
                        }
                        return DropdownButton<String>(
                          value: selectedCode,
                          items: countries.length == 0
                              ? [
                                  DropdownMenuItem(
                                    value: selectedCode,
                                    child: Text(
                                      selectedCode.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  )
                                ]
                              : countries.map((Countries item) {
                                  return DropdownMenuItem(
                                    value: item.countryCode.toString(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 20,
                                            width: 20,
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  "assets/images/placeholder.jpg"),
                                              image: NetworkImage(item.flag!),
                                            )),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            item.countryCode.toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCode = newValue.toString();
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 15,
                          ),
                          underline: SizedBox(),
                        );
                      }),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 200,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: phoneNumberController,
                        validator: (val) {
                          final RegExp regExp = RegExp(r"\d{6,11}");
                          return regExp.hasMatch(phoneNumberController.text)
                              ? null
                              : "Invalid phone number !";
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black26)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red)),
                            hintText: "XXXXXXXXX"),
                      ),
                    ),
                  ),
                ),
              ],
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
                    LoginResponse response = LoginResponse(status: false);
                    try {
                      response = await AuthAPI().login(Login(
                          code: selectedCode,
                          phone: phoneNumberController.text));
                    } catch (e) {
                      print(e.toString());
                      response.message = e.toString();
                    }
                    Navigator.pop(context);
                    if (response.status ?? false) {
                      Navigator.push(
                        context,
                        VerifyOTPScreenRoute(
                            phoneCode: selectedCode,
                            phoneNum: phoneNumberController.text),
                      );
                    } else {
                      print(response.toJson());
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
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
