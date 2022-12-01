import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/new_order_provider.dart';
import '../screens/new_order_details_screen.dart';

class BottomNewOrderBar extends StatelessWidget {
  BottomNewOrderBar({Key? key, required this.afterPopAction}) : super(key: key);
  Function afterPopAction;
  @override
  Widget build(BuildContext context) {
    return Provider.of<NewOrderProvider>(context).newOrder!.totalPrice <= 0
        ? Container()
        : Directionality(
            textDirection:
                Provider.of<AppPropertiesProvider>(context).language == "en"
                    ? TextDirection.ltr
                    : TextDirection.rtl,
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    NewOrderDetailsScreenRoute(
                        newOrder: Provider.of<NewOrderProvider>(context,
                                listen: false)
                            .newOrder!));
                afterPopAction();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Provider.of<AppPropertiesProvider>(context)
                          .strings['viewCart']
                          .toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      Provider.of<NewOrderProvider>(context)
                              .newOrder!
                              .totalPrice
                              .toStringAsFixed(2) +
                          ' ' +
                          Provider.of<AppPropertiesProvider>(context)
                              .strings['sar']
                              .toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
