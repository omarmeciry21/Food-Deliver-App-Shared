import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/app_properties_provider.dart';
import 'language_custom_widget.dart';

Directionality buildDrawer(BuildContext context) {
  return Directionality(
    textDirection: Provider.of<AppPropertiesProvider>(context).language == "en"
        ? TextDirection.ltr
        : TextDirection.rtl,
    child: Drawer(
      width: MediaQuery.of(context).size.width * 0.4 < 200
          ? 200
          : MediaQuery.of(context).size.width * 0.4,
      child: ListView(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => AddressesScreen()));
          //   },
          //   child: ListTile(
          //     leading: Icon(
          //       Icons.location_on,
          //       color: Theme.of(context).primaryColor,
          //     ),
          //     title: Text(Provider.of<AppPropertiesProvider>(context)
          //         .strings["addresses"]
          //         .toString()),
          //   ),
          // ),
          GestureDetector(
            onTap: () async {
              await (await SharedPreferences.getInstance()).remove("session");
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["logout"]
                    .toString(),
              ),
            ),
          ),
          LanguagesCustomWidget()
        ],
      ),
    ),
  );
}
