import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/restaurants.dart';
import '../../providers/app_properties_provider.dart';

class CustomRestaurantListTile extends StatelessWidget {
  CustomRestaurantListTile({Key? key, required this.restaurant})
      : super(key: key);
  Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            FittedBox(child: _buildImage()),
            const SizedBox(width: 20),
            Expanded(child: _buildInfo(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    String types = (restaurant.types ?? [])
        .map((e) => e.name)
        .toList()!
        .join(", ")
        .toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                restaurant.name.toString(),
                style: TextStyle(
                  color: Colors.black87.withAlpha(200),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                restaurant.distance == null || restaurant.distance == ""
                    ? Container()
                    : Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                SizedBox(
                    // width: 5,
                    ),
                Text(
                  restaurant.distance ?? "",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Text(
              types,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                restaurant.isOpen!
                    ? Provider.of<AppPropertiesProvider>(context)
                        .strings["open"]!
                    : Provider.of<AppPropertiesProvider>(context)
                        .strings["close"]!,
                style: TextStyle(
                    color: restaurant.isOpen! ? Colors.green : Colors.red,
                    fontSize: 14),
              ),
            ),
            Text(
              restaurant.workingHours.toString(),
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  Container _buildImage() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
          image: NetworkImage(
            restaurant.logo!,
          ),
          placeholder: AssetImage(
            "assets/images/food-delivery.png",
          ),
          imageErrorBuilder: (context, _, error) => Image(
            image: AssetImage(
              "assets/images/food-delivery.png",
            ),
          ),
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
