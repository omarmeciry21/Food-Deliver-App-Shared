import 'package:flutter/material.dart';

Future<dynamic> showLoadingDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ]),
          ));
}

Future<dynamic> showErrorDialog(BuildContext context,
    {required String errorMessage}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  height: 125,
                  width: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50,
                      ),
                      Text(
                        errorMessage,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ]),
          ));
}
