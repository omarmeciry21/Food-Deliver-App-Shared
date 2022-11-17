import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';
import 'package:food_delivery_app/ui/screens/meal_details_screen.dart';
import 'package:food_delivery_app/ui/widgets/custom_restaurant_list_tile.dart';
import 'package:food_delivery_app/ui/widgets/global_app_bar.dart';
import 'package:provider/provider.dart';

import '../../data/models/meals.dart';
import '../../providers/app_properties_provider.dart';

class RestaurantDetailsScreenRoute extends CupertinoPageRoute {
  RestaurantDetailsScreenRoute({required this.restaurant})
      : super(
            builder: (BuildContext context) =>
                RestaurantDetailsScreen(restaurant: restaurant));
  final Restaurants restaurant;
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation,
        child: RestaurantDetailsScreen(restaurant: restaurant));
  }
}

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({Key? key, required this.restaurant})
      : super(key: key);
  final Restaurants restaurant;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late final ScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    var rightActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Provider.of<AppPropertiesProvider>(context).language == "en"
                ? Icons.arrow_back_rounded
                : Icons.arrow_forward_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
    var leftActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ))
      ],
    );
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          GlobalAppBar(
            rightActions: rightActions,
            leftActions: leftActions,
            title: Provider.of<AppPropertiesProvider>(context)
                .strings["menu"]
                .toString(),
          ),
          Directionality(
            textDirection:
                Provider.of<AppPropertiesProvider>(context).language == "en"
                    ? TextDirection.ltr
                    : TextDirection.rtl,
            child: Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8),
                color: Colors.grey.shade200,
                child: ListView(
                  controller: controller,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: CustomRestaurantListTile(
                          restaurant: widget.restaurant),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    buildSearchMealsTextField(context),
                    SizedBox(
                      height: 8,
                    ),
                    buildMeals(meals: [
                      Meals(
                          image:
                              "https://media.istockphoto.com/id/1188412964/photo/hamburger-with-cheese-and-french-fries.jpg?s=612x612&w=0&k=20&c=lmJ0qUjC3FtCrWOGU0hWvqBgXcKZ1imiXKOMuHRfFH8=",
                          name: "Meal 1",
                          price: "28"),
                      Meals(
                          image:
                              "https://media.istockphoto.com/id/1188412964/photo/hamburger-with-cheese-and-french-fries.jpg?s=612x612&w=0&k=20&c=lmJ0qUjC3FtCrWOGU0hWvqBgXcKZ1imiXKOMuHRfFH8=",
                          name: "Meal 1",
                          price: "28"),
                      Meals(
                          image:
                              "https://media.istockphoto.com/id/1188412964/photo/hamburger-with-cheese-and-french-fries.jpg?s=612x612&w=0&k=20&c=lmJ0qUjC3FtCrWOGU0hWvqBgXcKZ1imiXKOMuHRfFH8=",
                          name: "Meal 1",
                          price: "28"),
                      Meals(
                          image:
                              "https://media.istockphoto.com/id/1188412964/photo/hamburger-with-cheese-and-french-fries.jpg?s=612x612&w=0&k=20&c=lmJ0qUjC3FtCrWOGU0hWvqBgXcKZ1imiXKOMuHRfFH8=",
                          name: "Meal 1",
                          price: "28"),
                      Meals(
                          image:
                              "https://media.istockphoto.com/id/1188412964/photo/hamburger-with-cheese-and-french-fries.jpg?s=612x612&w=0&k=20&c=lmJ0qUjC3FtCrWOGU0hWvqBgXcKZ1imiXKOMuHRfFH8=",
                          name: "Meal 1",
                          price: "28"),
                    ], controller: controller),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget buildMeals(
          {required List<Meals> meals, required ScrollController controller}) =>
      ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return CustomMealListTile(meal: meal);
        },
      );

  Widget buildSearchMealsTextField(BuildContext context) => Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: TextFormField(
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

class CustomMealListTile extends StatelessWidget {
  const CustomMealListTile({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meals meal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MealDetailsScreenRoute()),
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
              child: Image.network(
                meal.image,
                height: 125,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.name,
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Text(
                    "SAR " + meal.price,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
