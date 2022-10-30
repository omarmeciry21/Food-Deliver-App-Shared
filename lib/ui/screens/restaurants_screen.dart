import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/list_of_restaurants.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';
import 'package:food_delivery_app/data/network/restaurants_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
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
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: FutureBuilder<ListOfRestaurants>(
                  future: RestaurantAPI.getListOfRestaurants(24.3, 46.7, "en"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {}
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

  _buildAppBar(BuildContext context) {
    var rightActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
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
    return Container(
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
          height: 130,
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
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name.toString(),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 20,
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
                  fontSize: 18,
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
                    fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    restaurant.distance ?? "",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Text(
                restaurant.workingHours.toString(),
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16,
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
      height: 100,
      width: 100,
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
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
