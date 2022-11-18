import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/restaurant_details.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';
import 'package:food_delivery_app/data/network/restaurants_api.dart';
import 'package:food_delivery_app/providers/restaurants_provider.dart';
import 'package:food_delivery_app/ui/screens/meal_details_screen.dart';
import 'package:food_delivery_app/ui/widgets/custom_restaurant_list_tile.dart';
import 'package:food_delivery_app/ui/widgets/global_app_bar.dart';
import 'package:provider/provider.dart';

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
          Expanded(
            child: FutureBuilder<RestaurantDetailsResponse>(
                future: RestaurantAPI.getRestaurantDetails(
                    restaurantId: widget.restaurant.id!,
                    language:
                        Provider.of<AppPropertiesProvider>(context).language),
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
                    print(snapshot.data?.toJson());
                    return Directionality(
                      textDirection: Provider.of<AppPropertiesProvider>(context)
                                  .language ==
                              "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
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
                            MealsBuilder(
                                categories: snapshot.data!.categories ?? [],
                                controller: controller)
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                            child: Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator())),
                      ),
                    ],
                  );
                }),
          )
        ],
      )),
    );
  }
}

class MealsBuilder extends StatefulWidget {
  MealsBuilder({Key? key, required this.categories, required this.controller})
      : super(key: key);
  List<Categories> categories;
  final ScrollController controller;
  @override
  State<MealsBuilder> createState() => _MealsBuilderState();
}

class _MealsBuilderState extends State<MealsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (_, provider, __) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildSearchMealsTextField(context, provider),
          SizedBox(
            height: 8,
          ),
          buildMeals(
              categories: widget.categories,
              controller: widget.controller,
              provider: provider),
        ],
      ),
    );
  }

  Widget buildMeals(
          {required List<Categories> categories,
          required ScrollController controller,
          required RestaurantsProvider provider}) =>
      ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final meals = provider.mealsSearchKeyword == ""
              ? category.meals ?? []
              : (category.meals ?? [])
                  .where((element) => element.name
                      .toString()
                      .toLowerCase()
                      .contains(provider.mealsSearchKeyword.toLowerCase()))
                  .toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2)),
                  )),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      category.name.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2)),
                  )),
                ],
              ),
              ListView.builder(
                controller: controller,
                shrinkWrap: true,
                itemCount: (meals).length,
                itemBuilder: (context, index) {
                  final meal = meals![index];
                  return CustomMealListTile(meal: meal);
                },
              ),
            ],
          );
        },
      );

  Widget buildSearchMealsTextField(
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
              setState(() {
                provider.updateMealSearchKeyWord(val);
              });
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

class CustomMealListTile extends StatelessWidget {
  const CustomMealListTile({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meals meal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MealDetailsScreenRoute(meal: meal)),
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
              child: meal.image != ""
                  ? Hero(
                      tag: meal.id.toString(),
                      child: Image.network(
                        meal.image ?? "",
                        height: 125,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      "assets/images/placeholder.jpg",
                      height: 125,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.name.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Text(
                    Provider.of<AppPropertiesProvider>(context)
                            .strings["sar"]
                            .toString() +
                        " " +
                        meal.price.toString(),
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
