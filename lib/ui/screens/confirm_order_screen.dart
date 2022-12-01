import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/data/local/orders_provider.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart' hide Meals;
import 'package:food_delivery_app/data/network/orders_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/providers/new_order_provider.dart';
import 'package:food_delivery_app/ui/widgets/dialogs.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/restaurant_details.dart';
import '../../data/network/location_api.dart';

class ConfirmOrderScreenRoute extends CupertinoPageRoute {
  ConfirmOrderScreenRoute({required this.newOrder, required this.categories})
      : super(
            builder: (BuildContext context) => ConfirmOrderScreen(
                  newOrder: newOrder,
                  categories: categories,
                ));
  NewOrder newOrder;
  final List<Categories> categories;
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: ConfirmOrderScreen(
          newOrder: newOrder,
          categories: categories,
        ));
  }
}

class ConfirmOrderScreen extends StatefulWidget {
  ConfirmOrderScreen(
      {Key? key, required this.newOrder, required this.categories})
      : super(key: key);
  final NewOrder newOrder;
  final List<Categories> categories;

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  int selectedPaymentMethod = 0;

  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    widget.newOrder.deliveryPrice =
        20; //Todo: This line should be removed. It's only a default value.
    List<String> paymentMethods = [
      Provider.of<AppPropertiesProvider>(context)
          .strings['onDelivery']
          .toString(),
      Provider.of<AppPropertiesProvider>(context).strings['card'].toString()
    ];
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                child: AppBar(
                  toolbarHeight: 40,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [],
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['confirmOrder']
                        .toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: [
                      buildOrderDetailsSection(context),
                      buildPaymentMethodSection(context, paymentMethods),
                      buildEstimatedTimeSection(context),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black26,
                      ),
                      buildDeliveryAddressSection(context),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    showLoadingDialog(context);
                    final prefs = await SharedPreferences.getInstance();
                    widget.newOrder.paymentMethod = selectedPaymentMethod +
                        1; //Adding1 because backend count 1 for cash payment and 2 for card payment
                    widget.newOrder.deliveryPrice = 0;
                    widget.newOrder.latitude =
                        (await prefs.getDouble('lat')).toString();
                    widget.newOrder.longitude =
                        (await prefs.getDouble('lng')).toString();
                    widget.newOrder.addressInformation =
                        (await prefs.getString('addressDetails')).toString();
                    try {
                      final response = await OrdersAPI().sendNewOrder(
                          context: context, newOrder: widget.newOrder);
                      if (!response!.status!) {
                        Navigator.pop(context);
                        showErrorDialog(context,
                            errorMessage: response.message.toString());
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: Provider.of<AppPropertiesProvider>(context,
                                    listen: false)
                                .strings['orderSubmittedSuccessfully']
                                .toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green.withOpacity(0.75),
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Provider.of<NewOrderProvider>(context, listen: false)
                            .clearMeals();
                        await OrdersProvider.instance.update(
                            Provider.of<NewOrderProvider>(context,
                                    listen: false)
                                .newOrder!);
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      showErrorDialog(context, errorMessage: e.toString());
                      print(e.toString());
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black87),
                  ),
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['submitOrder']
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView buildOrderDetailsSection(BuildContext context) {
    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            Provider.of<AppPropertiesProvider>(context)
                .strings['orderDetails']
                .toString(),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: (widget.newOrder.meals ?? []).length,
          itemBuilder: (context, index) {
            final Categories mealCategory = widget.categories
                .where((element) =>
                    element.meals!.indexWhere((element) =>
                        element.id == widget.newOrder.meals![index].id) !=
                    -1)
                .toList()
                .first;
            final Meals meal = mealCategory.meals!
                .where(
                    (element) => element.id == widget.newOrder.meals![index].id)
                .toList()
                .first;
            var addOnsNames = (widget.newOrder.meals![index].addsOn!
                .map((addOn) => addOn.elements!
                    .map((e) => meal.addOns!
                        .where((element) {
                          return element.id == addOn.id;
                        })
                        .first
                        .elements!
                        .where((element) => element.id == e)
                        .first
                        .name)
                    .toList()
                    .toList())
                .toList());
            var addOnsNamesAsAString = "";
            addOnsNames.forEach((element) => element.forEach((e) {
                  addOnsNamesAsAString += e.toString() + ' - ';
                }));
            addOnsNamesAsAString = addOnsNamesAsAString.length > 2
                ? addOnsNamesAsAString.substring(
                    0, addOnsNamesAsAString.length - 3)
                : addOnsNamesAsAString;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        Provider.of<AppPropertiesProvider>(context).language ==
                                'en'
                            ? (widget.newOrder.meals![index].quantity
                                    .toString() +
                                'x ')
                            : ('x' +
                                widget.newOrder.meals![index].quantity
                                    .toString() +
                                ' '),
                        style: TextStyle(color: Colors.green),
                      ),
                      Expanded(
                        child: Text(
                          meal.name.toString(),
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ),
                      Text(
                        meal.price.toString() +
                            ' * ' +
                            widget.newOrder.meals![index].quantity.toString() +
                            ' ' +
                            Provider.of<AppPropertiesProvider>(context)
                                .strings['sar']
                                .toString(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      addOnsNamesAsAString,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  Provider.of<AppPropertiesProvider>(context)
                      .strings['deliveryPrice']
                      .toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Text(
                (widget.newOrder.deliveryPrice ?? 0).toStringAsFixed(2) +
                    ' ' +
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['sar']
                        .toString(),
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  Provider.of<AppPropertiesProvider>(context)
                      .strings['total']
                      .toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                (widget.newOrder.totalPrice).toStringAsFixed(2) +
                    ' ' +
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['sar']
                        .toString(),
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildEstimatedTimeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Provider.of<AppPropertiesProvider>(context)
                .strings['deliveryTime']
                .toString(),
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '25 - 40' +
                ' ' +
                Provider.of<AppPropertiesProvider>(context)
                    .strings['min']
                    .toString(),
            style: TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Container buildDeliveryAddressSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Provider.of<AppPropertiesProvider>(context)
                .strings['deliveryAddress']
                .toString(),
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 4,
          ),
          FutureBuilder<String>(future: () async {
            final prefs = await SharedPreferences.getInstance();
            final latlng = LatLng(await prefs.getDouble('lat') ?? 24.3,
                await prefs.getDouble('lng') ?? 46.7);
            GeoData place =
                await LocationAPI.getAddressFromLatLng(context, latlng);
            return place.address.toString();
          }(), builder: (context, snapshot) {
            if (snapshot.hasData)
              return Text(
                snapshot.data.toString(),
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              );
            return Text(
              '...',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            );
          }),
        ],
      ),
    );
  }

  Container buildPaymentMethodSection(
      BuildContext context, List<String> paymentMethods) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              Provider.of<AppPropertiesProvider>(context)
                  .strings['paymentMethod']
                  .toString(),
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black87, width: 1),
            ),
            child: Text(
              paymentMethods[selectedPaymentMethod],
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            height: 25,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Container(
                      height: 50 * paymentMethods.length + 25,
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: paymentMethods.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 50,
                                      child: RadioListTile(
                                        value: index,
                                        onChanged: (newCheck) {
                                          selectedPaymentMethod = index;
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        title: Text(
                                            paymentMethods[index].toString()),
                                        groupValue: selectedPaymentMethod,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings['change']
                    .toString(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
