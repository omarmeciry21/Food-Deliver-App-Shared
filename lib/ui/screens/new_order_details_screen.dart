import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart' as no;
import 'package:food_delivery_app/data/models/restaurant_details.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:provider/provider.dart';

import '../../data/network/restaurants_api.dart';

class NewOrderDetailsScreenRoute extends CupertinoPageRoute {
  NewOrderDetailsScreenRoute({required this.newOrder})
      : super(
            builder: (BuildContext context) =>
                NewOrderDetailsScreen(newOrder: newOrder));
  no.NewOrder newOrder;
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation, child: NewOrderDetailsScreen(newOrder: newOrder));
  }
}

class NewOrderDetailsScreen extends StatefulWidget {
  NewOrderDetailsScreen({Key? key, required this.newOrder}) : super(key: key);
  no.NewOrder newOrder;
  @override
  State<NewOrderDetailsScreen> createState() => _NewOrderDetailsScreenState();
}

class _NewOrderDetailsScreenState extends State<NewOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<RestaurantDetailsResponse>(
              future: RestaurantAPI.getRestaurantDetails(
                  restaurantId: widget.newOrder.restaurantId!,
                  language:
                      Provider.of<AppPropertiesProvider>(context).language),
              builder: (context, snapshot) {
                if (snapshot.hasError) {}
                if (snapshot.hasData) {
                  return Column(children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: AppBar(
                        toolbarHeight: 40,
                        centerTitle: true,
                        leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back)),
                        title: Text(
                          Provider.of<AppPropertiesProvider>(context)
                                  .strings['order']
                                  .toString() +
                              " : " +
                              snapshot.data!.details!.name.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: (widget.newOrder.meals ?? []).length,
                          itemBuilder: (context, index) {
                            final Categories mealCategory = snapshot
                                .data!.categories!
                                .where((element) =>
                                    element.meals!.indexWhere((element) =>
                                        element.id ==
                                        widget.newOrder.meals![index].id) !=
                                    -1)
                                .toList()
                                .first;
                            final Meals meal = mealCategory.meals!
                                .where((element) =>
                                    element.id ==
                                    widget.newOrder.meals![index].id)
                                .toList()
                                .first;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child:
                                          Image.network(meal.image.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            meal.name.toString(),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: Container()),
                                          Text(
                                            widget.newOrder.meals![index].price
                                                    .toString() +
                                                ' ' +
                                                Provider.of<AppPropertiesProvider>(
                                                        context)
                                                    .strings['sar']
                                                    .toString() +
                                                " * " +
                                                widget.newOrder.meals![index]
                                                    .quantity
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        (widget.newOrder.meals![index].price! *
                                                    widget
                                                        .newOrder
                                                        .meals![index]
                                                        .quantity!)
                                                .toStringAsFixed(2) +
                                            " " +
                                            Provider.of<AppPropertiesProvider>(
                                                    context)
                                                .strings['sar']
                                                .toString(),
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Provider.of<AppPropertiesProvider>(context)
                                    .strings['total']
                                    .toString(),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                widget.newOrder.totalPrice.toStringAsFixed(2) +
                                    ' ' +
                                    Provider.of<AppPropertiesProvider>(context)
                                        .strings['sar']
                                        .toString(),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).accentColor),
                            ),
                            child: Text(
                              Provider.of<AppPropertiesProvider>(context)
                                  .strings['confirmOrder']
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ]);
                }
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
