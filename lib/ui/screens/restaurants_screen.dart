import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/data/local/orders_provider.dart';
import 'package:food_delivery_app/data/models/list_of_restaurants.dart';
import 'package:food_delivery_app/data/models/order/new_order.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';
import 'package:food_delivery_app/data/network/restaurants_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/providers/new_order_provider.dart';
import 'package:food_delivery_app/providers/restaurants_provider.dart';
import 'package:food_delivery_app/ui/screens/restaurant_details_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_restaurant_list_tile.dart';
import '../widgets/drawer.dart';
import '../widgets/global_app_bar.dart';

class RestaurantsScreenRoute extends CupertinoPageRoute {
  RestaurantsScreenRoute({required this.locationData})
      : super(
            builder: (BuildContext context) =>
                RestaurantsScreen(locationData: locationData));
  LocationData locationData;
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: RestaurantsScreen(locationData: locationData));
  }
}

class RestaurantsScreen extends StatefulWidget {
  RestaurantsScreen({Key? key, required this.locationData}) : super(key: key);
  LocationData locationData;
  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  int bannerheightFactor = 0;
  final ScrollController scrollController = ScrollController();

  Future<ListOfRestaurants> getUserDetailsAndRestaurants(
      BuildContext context) async {
    // LocationData locationData = await LocationAPI.getCurrentLocation()
    //     .onError((Exception error, stackTrace) => throw (error));

    LocationData locationData = widget.locationData;
    Provider.of<RestaurantsProvider>(context, listen: false).listOfRestaurants =
        await RestaurantAPI.getListOfRestaurants(
            lat: locationData.latitude ?? 24.3,
            lon: locationData.longitude ?? 46.7,
            language: Provider.of<AppPropertiesProvider>(context, listen: false)
                .language);
    print(Provider.of<RestaurantsProvider>(context, listen: false)
        .listOfRestaurants!
        .toJson()["banners"]);

    return Provider.of<RestaurantsProvider>(context, listen: false)
        .listOfRestaurants!;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  // Create a key
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Row(
          children: [
            buildDrawer(context),
          ],
        ),
        body: SafeArea(
          child: FutureBuilder<ListOfRestaurants>(
              future: getUserDetailsAndRestaurants(context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  List<Restaurants> listOfRestaurants =
                      Provider.of<RestaurantsProvider>(context)
                              .displayedRestaurants ??
                          [];
                  return ListView(
                    controller: scrollController,
                    children: [
                      CustomAppBar(
                          scaffoldKey: scaffoldKey,
                          banners: (snapshot.data!.banners ?? [])
                              .map((e) => e.image.toString())
                              .toList(),
                          refreshFunc: () {
                            setState(() {});
                          }),
                      Consumer<RestaurantsProvider>(builder:
                          (BuildContext context, RestaurantsProvider value,
                              Widget? child) {
                        final List<Restaurants> restaurants =
                            value.restaurantSearchKeyword == ""
                                ? listOfRestaurants ?? []
                                : (listOfRestaurants ?? [])
                                    .where((element) => element.name
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.restaurantSearchKeyword
                                            .toLowerCase()))
                                    .toList();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildSearchRestaurantsTextField(
                                  context, value),
                            ),
                            ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: restaurants != null
                                    ? restaurants!.length
                                    : 0,
                                // itemCount: 5,
                                itemBuilder: (context, index) {
                                  Restaurants restaurant = restaurants![index];
                                  return GestureDetector(
                                    onTap: () async {
                                      try {
                                        Provider.of<NewOrderProvider>(context,
                                                    listen: false)
                                                .newOrder =
                                            await OrdersProvider.instance
                                                .getNewOrder(restaurant.id!);
                                      } catch (e) {
                                        Provider.of<NewOrderProvider>(context,
                                                listen: false)
                                            .newOrder = NewOrder(
                                          restaurantId: restaurant.id,
                                          latitude: (await SharedPreferences
                                                  .getInstance())
                                              .getDouble('lat')!
                                              .toStringAsFixed(2),
                                          longitude: (await SharedPreferences
                                                  .getInstance())
                                              .getDouble('lng')!
                                              .toStringAsFixed(2),
                                          meals: [],
                                        );
                                        await OrdersProvider.instance.insert(
                                            Provider.of<NewOrderProvider>(
                                                    context,
                                                    listen: false)
                                                .newOrder!);
                                      }
                                      Navigator.push(
                                        context,
                                        RestaurantDetailsScreenRoute(
                                          restaurant: restaurant,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          CustomRestaurantListTile(
                                            restaurant: restaurant,
                                          ),
                                          restaurants.length <= 1
                                              ? Container()
                                              : Container(
                                                  color: Colors.grey.shade300,
                                                  height: 3,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        );
                      }),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget buildSearchRestaurantsTextField(
          BuildContext context, RestaurantsProvider provider) =>
      Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: TextFormField(
            onChanged: (val) {
              provider.updateRestaurantSearchKeyWord(val);
            },
            decoration: InputDecoration(
              hintText: Provider.of<AppPropertiesProvider>(context)
                  .strings["searchMealText"]
                  .toString(),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      );
}

class CustomAppBar extends StatefulWidget {
  CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    required this.refreshFunc,
    required this.banners,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey; // Create a key
  final List<String> banners;
  final void Function() refreshFunc;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isBannerOpen = false;
  int _current = 0;
  var _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final listOfRestaurants =
        Provider.of<RestaurantsProvider>(context).listOfRestaurants;
    var rightActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            widget.scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );

    var leftActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // GestureDetector(
        //   onTap: () => widget.refreshFunc(),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: const Icon(
        //       Icons.refresh_rounded,
        //       color: Colors.white,
        //       size: 20,
        //     ),
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: listOfRestaurants == null
                          ? Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).accentColor,
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (listOfRestaurants.types ?? []).length,
                                  itemBuilder: (context, index) {
                                    bool isSelected = Provider.of<
                                            RestaurantsProvider>(context)
                                        .selectedTypes
                                        .where((element) =>
                                            element.id ==
                                            listOfRestaurants.types![index].id)
                                        .toList()
                                        .isNotEmpty;
                                    return Container(
                                      height: 50,
                                      child: CheckboxListTile(
                                        value: isSelected,
                                        onChanged: (newCheck) {
                                          if (newCheck ?? true)
                                            Provider.of<RestaurantsProvider>(
                                                    context,
                                                    listen: false)
                                                .addType(listOfRestaurants
                                                    .types![index]);
                                          else {
                                            print("Pressed  ");
                                            Provider.of<RestaurantsProvider>(
                                                    context,
                                                    listen: false)
                                                .removeType(listOfRestaurants
                                                    .types![index]);
                                          }
                                        },
                                        title: Text(listOfRestaurants!
                                            .types![index]!.name
                                            .toString()),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).accentColor),
                                    ),
                                    child: Text(
                                      Provider.of<AppPropertiesProvider>(
                                              context)
                                          .strings["filter"]
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.filter_list_alt,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
    final fullWidth = MediaQuery.of(context).size.width;
    final List<Widget> imageSliders = widget.banners
        .map((item) => Image.network(
              item,
              fit: BoxFit.fitWidth,
              height: 200,
              width: fullWidth,
            ))
        .toList();
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlobalAppBar(
            rightActions:
                Provider.of<AppPropertiesProvider>(context).language == "en"
                    ? rightActions
                    : leftActions,
            leftActions:
                Provider.of<AppPropertiesProvider>(context).language == "en"
                    ? leftActions
                    : rightActions,
            title: Provider.of<AppPropertiesProvider>(context).appName,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 150.0 * (isBannerOpen ? 1 : 0),
            color: Theme.of(context).primaryColor,
            width: fullWidth,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: fullWidth,
                  child: CarouselSlider(
                    items: imageSliders,
                    carouselController: _controller,
                    options: CarouselOptions(
                        height: fullWidth / 2,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.banners.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Colors.white).withOpacity(
                                    _current == entry.key ? 1 : 0.6)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isBannerOpen = !isBannerOpen;
              });
            },
            child: Container(
              height: 30,
              color: Theme.of(context).primaryColor,
              child: Center(
                  child: RotatedBox(
                quarterTurns: isBannerOpen ? 2 : 0,
                child: Image.asset(
                  "assets/images/down-arrow.png",
                  color: Colors.white,
                  width: 15,
                  height: 15,
                  fit: BoxFit.cover,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
