import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/local/orders_provider.dart';
import 'package:food_delivery_app/data/models/list_of_restaurants.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart';
import 'package:food_delivery_app/data/models/order/orders_list_response.dart';
import 'package:food_delivery_app/data/network/orders_api.dart';
import 'package:food_delivery_app/ui/screens/new_order_details_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../data/network/restaurants_api.dart';
import '../../providers/app_properties_provider.dart';
import '../widgets/drawer.dart';

class OrdersScreenRoute extends CupertinoPageRoute {
  OrdersScreenRoute({required this.locationData})
      : super(
            builder: (BuildContext context) =>
                OrdersScreen(locationData: locationData));
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  final LocationData locationData;
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation, child: OrdersScreen(locationData: locationData));
  }
}

class OrdersScreen extends StatefulWidget {
  final LocationData locationData;
  OrdersScreen({Key? key, required this.locationData}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Row(
        mainAxisAlignment:
            Provider.of<AppPropertiesProvider>(context).language == "en"
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
        children: [
          buildDrawer(context),
        ],
      ),
      body: Directionality(
        textDirection:
            Provider.of<AppPropertiesProvider>(context).language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  toolbarHeight: 40,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [],
                  leading: IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['orders']
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                child: FutureBuilder<OrdersListResponse>(
                    future: OrdersAPI().getOrdersList(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        List<Orders> orders = snapshot.data!.orders ?? [];
                        return ListView(
                          controller: scrollController,
                          children: [
                            FutureBuilder<List<NewOrder>>(
                                future:
                                    OrdersProvider.instance.getNewOrdersList(),
                                builder: (context, orders) {
                                  if (snapshot.hasData)
                                    return FutureBuilder(
                                        future: RestaurantAPI.getListOfRestaurants(
                                            lat: widget.locationData.latitude ??
                                                24.3,
                                            lon:
                                                widget.locationData.longitude ??
                                                    46.7,
                                            language: Provider.of<
                                                        AppPropertiesProvider>(
                                                    context,
                                                    listen: false)
                                                .language),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData)
                                            return buildCurrentOrders(
                                                context, orders, snapshot);
                                          return Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              margin: EdgeInsets.all(16),
                                              child: CircularProgressIndicator(
                                                color: Colors.amber,
                                              ),
                                            ),
                                          );
                                        });
                                  return Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  );
                                }),
                            buildPastOrders(context, orders),
                          ],
                        );
                      }
                      return Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        ),
                      );
                    }),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Column buildPastOrders(BuildContext context, List<Orders> orders) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings['pastOrders']
                    .toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                height: 1,
              ),
            )
          ],
        ),
        orders.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['makeFirstOrder']
                        .toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                controller: scrollController,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                                orders[index].restaurant!.logo.toString()),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orders[index].restaurant!.name.toString(),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Container()),
                                Text(
                                  orders[index].totalPrice!.toStringAsFixed(2) +
                                      ' ' +
                                      Provider.of<AppPropertiesProvider>(
                                              context)
                                          .strings['sar']
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
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Column buildCurrentOrders(
      BuildContext context,
      AsyncSnapshot<List<NewOrder>> orders,
      AsyncSnapshot<ListOfRestaurants> snapshot) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings['currentOrders']
                    .toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                height: 1,
              ),
            )
          ],
        ),
        orders.data!.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['addFirstMeal']
                        .toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: (orders.data ?? []).length,
                    itemBuilder: (context, index) {
                      final order = orders.data![index];
                      final restaurant = snapshot.data?.restaurants!
                          .where((element) => element.id == order.restaurantId)
                          .toList()
                          .first;
                      return order.totalPrice == 0.0
                          ? Container()
                          : GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    NewOrderDetailsScreenRoute(
                                        newOrder: order));
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: restaurant?.logo != ""
                                          ? Image.network(
                                              restaurant?.logo ?? "",
                                              height: 125,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/images/placeholder.jpg",
                                              height: 125,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurant!.name.toString(),
                                            style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  Provider.of<AppPropertiesProvider>(
                                                          context)
                                                      .strings['total']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                Provider.of<AppPropertiesProvider>(
                                                            context)
                                                        .strings["sar"]
                                                        .toString() +
                                                    " " +
                                                    order.totalPrice.toString(),
                                                style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                    }),
              ),
      ],
    );
  }
}