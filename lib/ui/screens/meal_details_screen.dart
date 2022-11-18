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

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({Key? key, required this.meal}) : super(key: key);
  final Meals meal;

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Map<String, dynamic> selectedAddOns = {};
  final ScrollController controller = ScrollController();
  int quantity = 1;
  @override
  void initState() {
    super.initState();
    (widget.meal.addOns ?? []).forEach((addOn) {
      if (!addOn.single!) {
        selectedAddOns[addOn.id.toString()] = {};
        (addOn.elements ?? []).forEach((element) {
          selectedAddOns[addOn.id.toString()]![element.id.toString()] = false;
        });
      } else {
        selectedAddOns[addOn.id.toString()] =
            addOn.elements!.first.id.toString();
      }
    });
    print("Selected AddOns: " + selectedAddOns.toString());
  }

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: ListView(
                    shrinkWrap: true,
                    controller: controller,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.meal.image != ""
                                ? Hero(
                                    tag: widget.meal.id.toString(),
                                    child: Image.network(
                                      widget.meal.image ?? "",
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
                        widget.meal.name.toString(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      kSmallHeight,
                      Text(
                        widget.meal.description.toString(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                      kSmallHeight,
                      buildAddOns(controller: controller),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(right: 16, bottom: 16, left: 16, top: 0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.black87,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                color: Colors.black87,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: 35,
                        margin: EdgeInsets.only(
                            top: 8, bottom: 8, right: 8, left: 16),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  Provider.of<AppPropertiesProvider>(context)
                                      .strings["add"]
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 2,
                              margin: EdgeInsets.all(8),
                              color: Colors.black26,
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  widget.meal.price.toString() +
                                      " " +
                                      Provider.of<AppPropertiesProvider>(
                                              context)
                                          .strings["sar"]
                                          .toString(),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildAddOns({required ScrollController controller}) {
    return ListView.builder(
      shrinkWrap: true,
      controller: controller,
      itemCount: (widget.meal.addOns ?? []).length,
      itemBuilder: (context, addOnsIndex) {
        AddOns addOns = (widget.meal.addOns ?? [])[addOnsIndex];
        List<Elements> elements =
            (widget.meal.addOns ?? [])[addOnsIndex].elements ?? [];
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
              controller: controller,
              itemBuilder: (context, index) {
                final element = elements[index];
                if (addOns.single!) {
                  print(selectedAddOns[addOns.id.toString()]);
                }
                return addOns!.single ?? false
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: element.id.toString(),
                            onChanged: (newVal) {
                              print("N" + element.id.toString());
                              setState(() {
                                selectedAddOns[addOns.id.toString()] =
                                    element.id.toString();
                              });
                            },
                            groupValue: selectedAddOns[addOns.id.toString()],
                          ),
                          Text(
                            element.name.toString(),
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: selectedAddOns[addOns.id.toString()]
                                [element.id.toString()],
                            onChanged: (newVal) {
                              setState(() {
                                selectedAddOns[addOns.id.toString()]
                                    [element.id.toString()] = newVal;
                              });
                            },
                          ),
                          Text(
                            element.name.toString(),
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      );
              },
            ),
          ],
        );
      },
    );
  }
}
