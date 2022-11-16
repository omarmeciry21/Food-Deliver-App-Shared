import 'package:flutter/material.dart';

InputDecoration kBorderOutlinedInputDecoration(
        {required BuildContext context, required String hintText}) =>
    InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
