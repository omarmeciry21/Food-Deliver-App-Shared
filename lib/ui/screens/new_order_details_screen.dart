import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/data/local/orders_provider.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart' as no;
import 'package:food_delivery_app/data/models/restaurant_details.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:provider/provider.dart';

import '../../data/network/restaurants_api.dart';
import '../../providers/new_order_provider.dart';
import 'confirm_order_screen.dart';

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
                                      child: FadeInImage(
                                        image:
                                            NetworkImage(meal.image.toString()),
                                        placeholder: AssetImage(
                                            'assets/images/placeholder.jpg'),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
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
                                  Container(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              (widget.newOrder.meals![index]
                                                              .price! *
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
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (widget.newOrder.meals!.length >
                                                1)
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(Provider.of<
                                                              AppPropertiesProvider>(
                                                          context)
                                                      .strings[
                                                          'deleteMealTitle']
                                                      .toString()),
                                                  content: Text(Provider.of<
                                                              AppPropertiesProvider>(
                                                          context)
                                                      .strings['deleteMealText']
                                                      .toString()),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text(
                                                        Provider.of<AppPropertiesProvider>(
                                                                context)
                                                            .strings['cancel']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        widget.newOrder.meals!
                                                            .removeAt(widget
                                                                .newOrder.meals!
                                                                .indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        meal.id));
                                                        await OrdersProvider
                                                            .instance
                                                            .update(widget
                                                                .newOrder);
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                        Provider.of<AppPropertiesProvider>(
                                                                context)
                                                            .strings['OK']
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            else
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(Provider.of<
                                                              AppPropertiesProvider>(
                                                          context)
                                                      .strings[
                                                          'deleteOrderTitle']
                                                      .toString()),
                                                  content: Text(Provider.of<
                                                              AppPropertiesProvider>(
                                                          context)
                                                      .strings[
                                                          'deleteOrderText']
                                                      .toString()),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text(
                                                        Provider.of<AppPropertiesProvider>(
                                                                context)
                                                            .strings['cancel']
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await OrdersProvider
                                                            .instance
                                                            .delete(widget
                                                                .newOrder
                                                                .restaurantId!);
                                                        Provider.of<NewOrderProvider>(
                                                                context,
                                                                listen: false)
                                                            .clearMeals();
                                                        Navigator.pop(context);
                                                        Fluttertoast.showToast(
                                                            msg: Provider.of<
                                                                        AppPropertiesProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .strings[
                                                                    'orderDeletedSuccessfully']
                                                                .toString(),
                                                            toastLength:
                                                                Toast
                                                                    .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.green
                                                                    .withOpacity(
                                                                        0.75),
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        Provider.of<AppPropertiesProvider>(
                                                                context)
                                                            .strings['OK']
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                          },
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
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
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  ConfirmOrderScreenRoute(
                                      newOrder: widget.newOrder,
                                      categories:
                                          snapshot.data!.categories ?? []));
                            },
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
