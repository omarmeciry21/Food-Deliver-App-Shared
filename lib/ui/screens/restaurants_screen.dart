import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/list_of_restaurants.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';
import 'package:food_delivery_app/data/network/location_api.dart';
import 'package:food_delivery_app/data/network/restaurants_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/ui/screens/addresses_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RestaurantsScreenRoute extends CupertinoPageRoute {
  RestaurantsScreenRoute()
      : super(builder: (BuildContext context) => RestaurantsScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: RestaurantsScreen());
  }
}

class RestaurantsScreen extends StatelessWidget {
  RestaurantsScreen({Key? key}) : super(key: key);
  int bannerheightFactor = 0;

  Future<ListOfRestaurants> getUserDetailsAndRestaurants() async {
    LocationData locationData = await LocationAPI.getCurrentLocation()
        .onError((Exception error, stackTrace) => throw (error));
    return await RestaurantAPI.getListOfRestaurants(
        lat: locationData.latitude ?? 24.3,
        lon: locationData.longitude ?? 46.7,
        language: "en");
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.4 < 200
            ? 200
            : MediaQuery.of(context).size.width * 0.4,
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressesScreen()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text("Addresses"),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(scaffoldKey: scaffoldKey),
            Expanded(
              child: FutureBuilder<ListOfRestaurants>(
                  future: getUserDetailsAndRestaurants(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      ListOfRestaurants listOfRestaurants = snapshot.data!;
                      return ListView.builder(
                          itemCount: listOfRestaurants.restaurants != null
                              ? listOfRestaurants.restaurants!.length
                              : 0,
                          // itemCount: 5,
                          itemBuilder: (context, index) {
                            Restaurants restaurant =
                                listOfRestaurants.restaurants![index];
                            return CustomListTile(
                              restaurant: restaurant,
                              // restaurant: Restaurants(
                              //     id: 1,
                              //     name: "El Z3ama",
                              //     description: "serving high-quality d7k",
                              //     latitude: 12.3,
                              //     longitude: 12.3,
                              //     logo: "",
                              //     coverImage: "",
                              //     distance: "12",
                              //     isOpen: true,
                              //     workingHours: "12 -11",
                              //     types: []),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).accentColor,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  CustomAppBar({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey; // Create a key

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isBannerOpen = false;
  List<String> banners = [
    "https://www.bdtask.com/blog/uploads/restaurant-food-combo-offers.jpg",
    "https://cdn.grabon.in/gograbon/images/category/1546252575451.png",
    "https://chandigarhmetro.com/wp-content/uploads/2021/07/HDFC.jpg",
  ];
  int _current = 0;
  var _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
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
            size: 35,
          ),
        ),
      ],
    );

    var leftActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [],
    );
    final fullWidth = MediaQuery.of(context).size.width;
    final List<Widget> imageSliders = banners
        .map((item) => Image.network(
              item,
              fit: BoxFit.fitWidth,
              height: 200,
              width: fullWidth,
            ))
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 75,
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rightActions,
                    leftActions,
                  ],
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context).appName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
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
                    children: banners.asMap().entries.map((entry) {
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
        Container(
          height: 50,
          color: Theme.of(context).primaryColor,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isBannerOpen = !isBannerOpen;
              });
            },
            child: Center(
                child: RotatedBox(
              quarterTurns: isBannerOpen ? 2 : 0,
              child: Image.asset(
                "assets/images/down-arrow.png",
                color: Colors.white,
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
            )),
          ),
        ),
      ],
    );
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile({Key? key, required this.restaurant}) : super(key: key);
  Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.grey.shade300,
          height: 3,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              _buildImage(),
              const SizedBox(width: 20),
              Expanded(child: _buildInfo(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    String types = (restaurant.types ?? [])
        .map((e) => e.name)
        .toList()!
        .join(", ")
        .toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name.toString(),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                types,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Expanded(child: Container()),
              Text(
                restaurant.isOpen!
                    ? Provider.of<AppPropertiesProvider>(context)
                        .strings["open"]!
                    : Provider.of<AppPropertiesProvider>(context)
                        .strings["close"]!,
                style: TextStyle(
                    color: restaurant.isOpen! ? Colors.green : Colors.red,
                    fontSize: 18),
              ),
            ],
          ),
        ),
        Container(
          height: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    restaurant.distance ?? "",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Text(
                restaurant.workingHours.toString(),
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
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
