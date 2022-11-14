import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/app_properties_provider.dart';

class LanguagesCustomWidget extends StatelessWidget {
  const LanguagesCustomWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              Provider.of<AppPropertiesProvider>(context, listen: false)
                  .language = "en";
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("lang", "en");
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  color: Provider.of<AppPropertiesProvider>(context)
                              .language
                              .toLowerCase() ==
                          "en"
                      ? Theme.of(context).primaryColor
                      : Colors.transparent),
              padding: EdgeInsets.all(4),
              child: Text(
                "EN",
                style: TextStyle(
                    color: Provider.of<AppPropertiesProvider>(context,
                                    listen: false)
                                .language
                                .toLowerCase() ==
                            "en"
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () async {
              Provider.of<AppPropertiesProvider>(context, listen: false)
                  .language = "ar";

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("lang", "ar");
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  color: Provider.of<AppPropertiesProvider>(context)
                              .language
                              .toLowerCase() ==
                          "ar"
                      ? Theme.of(context).primaryColor
                      : Colors.transparent),
              padding: EdgeInsets.all(4),
              child: Text(
                "AR",
                style: TextStyle(
                    color: Provider.of<AppPropertiesProvider>(context)
                                .language
                                .toLowerCase() ==
                            "ar"
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
