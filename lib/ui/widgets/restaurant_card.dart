import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/restaurants.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    final kShadows = <Shadow>[
      Shadow(
        offset: Offset(3.0, 3.0),
        blurRadius: 3.0,
        color: Colors.black54,
      ),
      Shadow(
        offset: Offset(3.0, 3.0),
        blurRadius: 8.0,
        color: Colors.black54,
      ),
    ];
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 225,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: NetworkImage(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png"),
                    image: NetworkImage(restaurant.coverImage.toString()),
                    fit: BoxFit.cover,
                    height: 225,
                    width: double.infinity,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(75)),
                        padding: EdgeInsets.all(20),
                        child: Image.network(
                          restaurant.logo.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                restaurant.name.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: kShadows),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                restaurant.description.toString() +
                                    " - " +
                                    restaurant.distance.toString() +
                                    " km",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Theme.of(context).accentColor,
                                      shadows: kShadows,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required Image image,
    required String name,
  })  : _image = image,
        _name = name,
        super(key: key);

  final String _name;
  final Image _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 100,
            height: 100,
            child: _image,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          _name,
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Theme.of(context).primaryColor, fontSize: 16),
        ),
      ],
    );
  }
}
