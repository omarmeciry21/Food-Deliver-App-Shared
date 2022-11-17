import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/restaurant_details.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:provider/provider.dart';

class MealDetailsScreenRoute extends CupertinoPageRoute {
  MealDetailsScreenRoute({required this.meal})
      : super(builder: (BuildContext context) => MealDetailsScreen(meal: meal));
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  final Meals meal;
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: MealDetailsScreen(
          meal: meal,
        ));
  }
}

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({Key? key, required this.meal}) : super(key: key);
  final Meals meal;
  @override
  Widget build(BuildContext context) {
    var kSmallHeight = SizedBox(
      height: 8,
    );
    return Scaffold(
      body: Directionality(
        textDirection:
            Provider.of<AppPropertiesProvider>(context).language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade300,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.black87,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: meal.image != ""
                                ? Hero(
                                    tag: meal.id.toString(),
                                    child: Image.network(
                                      meal.image ?? "",
                                      height: 175,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    "assets/images/placeholder.jpg",
                                    height: 175,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ],
                      ),
                      kSmallHeight,
                      Text(
                        meal.name.toString(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      kSmallHeight,
                      Text(
                        meal.description.toString(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                      kSmallHeight,
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (meal.addOns ?? []).length,
                        itemBuilder: (context, addOnsIndex) {
                          AddOns addOns = (meal.addOns ?? [])[addOnsIndex];
                          List<Elements> elements =
                              (meal.addOns ?? [])[addOnsIndex].elements ?? [];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      addOns.name.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(2)),
                                  )),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: elements.length,
                                itemBuilder: (context, index) {
                                  final element = elements[index];
                                  return addOns!.single ?? false
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Radio(
                                              value: true,
                                              onChanged: (newVal) {},
                                              groupValue: true,
                                            ),
                                            Text(
                                              element.name.toString(),
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              value: true,
                                              onChanged: (newVal) {},
                                            ),
                                            Text(
                                              element.name.toString(),
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
