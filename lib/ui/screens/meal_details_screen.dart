import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/data/local/orders_provider.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart' as no;
import 'package:food_delivery_app/data/models/restaurant_details.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/new_order_provider.dart';
import '../widgets/bottom_new_order_bar.dart';

class MealDetailsScreenRoute extends CupertinoPageRoute {
  MealDetailsScreenRoute({required this.meal, required this.restaurants})
      : super(
            builder: (BuildContext context) =>
                MealDetailsScreen(meal: meal, restaurants: restaurants));
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  final Meals meal;
  final Restaurants restaurants;
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: MealDetailsScreen(meal: meal, restaurants: restaurants));
  }
}

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen(
      {Key? key, required this.meal, required this.restaurants})
      : super(key: key);
  final Meals meal;
  final Restaurants restaurants;

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
              Expanded(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          "assets/images/placeholder.jpg",
                                          height: 175,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
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
                      padding: EdgeInsets.only(
                          right: 16, bottom: 16, left: 16, top: 0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1)
                                    setState(() {
                                      quantity--;
                                    });
                                },
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
                            child: GestureDetector(
                              onTap: () async {
                                no.Meals meal =
                                    no.Meals.fromJson(widget.meal.toJson());
                                meal.quantity = quantity;
                                meal.addsOn = [];
                                print(widget.meal.addOns!
                                    .map((e) => e.toJson())
                                    .toList()
                                    .toString());
                                selectedAddOns.forEach((key, value) {
                                  if (value is Map) {
                                    List<int> v = [];
                                    value.forEach((k1, v1) {
                                      if (v1) {
                                        v.add(int.parse(k1));
                                      }
                                    });
                                    meal.addsOn!.add(no.AddsOn(
                                        id: int.parse(key), elements: v));
                                  } else {
                                    meal.addsOn!.add(no.AddsOn(
                                        id: int.parse(key), elements: [value]));
                                  }
                                });
                                try {
                                  Provider.of<NewOrderProvider>(context,
                                          listen: false)
                                      .addMeal(meal);
                                  await OrdersProvider.instance.update(
                                      Provider.of<NewOrderProvider>(context,
                                              listen: false)
                                          .newOrder!);
                                } catch (e) {
                                  print(e.toString());
                                }
                                Fluttertoast.showToast(
                                    msg: Provider.of<AppPropertiesProvider>(
                                            context,
                                            listen: false)
                                        .strings['mealAddedSuccessfully']
                                        .toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.green.withOpacity(0.75),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 35,
                                margin: EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8, left: 16),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            Provider.of<AppPropertiesProvider>(
                                                    context)
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BottomNewOrderBar(
                afterPopAction: () {
                  setState(() {});
                },
              )
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
