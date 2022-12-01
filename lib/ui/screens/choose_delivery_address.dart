import 'dart:async';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/network/base_api.dart';
import 'package:food_delivery_app/data/network/location_api.dart';
import 'package:food_delivery_app/providers/location_provider.dart';
import 'package:food_delivery_app/ui/constants.dart';
import 'package:food_delivery_app/ui/screens/home_screen.dart';
import 'package:food_delivery_app/ui/widgets/language_custom_widget.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/find_place_response_model.dart' as findPlaceResponse;
import '../../providers/app_properties_provider.dart';

class ChooseDeliveryAddressScreenRoute extends CupertinoPageRoute {
  ChooseDeliveryAddressScreenRoute()
      : super(builder: (BuildContext context) => ChooseDeliveryAddressScreen());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation, child: ChooseDeliveryAddressScreen());
  }
}

class ChooseDeliveryAddressScreen extends StatefulWidget {
  ChooseDeliveryAddressScreen({Key? key}) : super(key: key);
  @override
  State<ChooseDeliveryAddressScreen> createState() =>
      _ChooseDeliveryAddressScreenState();
}

class _ChooseDeliveryAddressScreenState
    extends State<ChooseDeliveryAddressScreen> {
  late GeoMethods geoMethods;
  late TextEditingController controller;
  Completer<GoogleMapController> _controller = Completer();

  late final Marker selectedAddressMarker;
  late CameraPosition _kGooglePlex;
  late TextEditingController searchController;
  late TextEditingController addressDetailsController = TextEditingController();
  bool isInitialized = false;
  late LocationData tmpLocationData;
  _appBar(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["newAddress"]
                    .toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> markers = [];

  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController()
      ..addListener(() {
        if (searchController.text.length == 0)
          Provider.of<LocationProvider>(context, listen: false)
              .searchResultsPlaces = [];
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: SafeArea(
        child: FutureBuilder<LocationData>(future: () async {
          if (isInitialized) return tmpLocationData;
          LocationData locationData = await LocationAPI.getCurrentLocation()
              .onError((Exception error, stackTrace) => throw (error));
          _kGooglePlex = CameraPosition(
            target: LatLng(
                locationData.latitude ?? 24.3, locationData.longitude ?? 46.7),
            zoom: 14.4746,
          );
          markers.add(Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(
                locationData.latitude ?? 24.3, locationData.longitude ?? 46.7),
          ));
          tmpLocationData = locationData;
          isInitialized = true;
          return locationData;
        }(), builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Stack(
              children: [
                Center(
                  child: TextButton(
                      onPressed: () {
                        isInitialized = false;
                        setState(() {});
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.error is NoInternetConnectionException
                                ? Provider.of<AppPropertiesProvider>(context)
                                    .strings["noInternet"]
                                    .toString()
                                : "An error occurred! Please, try again.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            Provider.of<AppPropertiesProvider>(context)
                                .strings["clickToTryAgain"]
                                .toString(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: Provider.of<AppPropertiesProvider>(context)
                                  .language ==
                              "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: LanguagesCustomWidget(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          if (snapshot.hasData) {
            return Column(
              children: [
                // _appBar(context),
                Expanded(
                  child: Stack(children: [
                    Container(
                      child: GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) async {
                          _controller.complete(controller);
                          final latlng = LatLng(snapshot.data!.latitude ?? 24.3,
                              snapshot.data!.longitude ?? 46.7);
                          GeoData place =
                              await LocationAPI.getAddressFromLatLng(
                                  context, latlng);
                          print(place.address.toString());
                          showAddressDetails(
                            context,
                            findPlaceResponse.Candidates(
                                geometry: findPlaceResponse.Geometry(
                                  location: findPlaceResponse.Location(
                                      lat: latlng.latitude,
                                      lng: latlng.longitude),
                                ),
                                name: place.city,
                                formattedAddress: place.address.toString()),
                          );
                        },
                        markers: Set.of(markers),
                        onTap: (newLatLng) async {
                          markers.add(Marker(
                              markerId: MarkerId("currentLocation"),
                              position: newLatLng));
                          markers.removeAt(0);
                          GeoData place =
                              await LocationAPI.getAddressFromLatLng(
                                  context, newLatLng);
                          print(place.address.toString());
                          showAddressDetails(
                            context,
                            findPlaceResponse.Candidates(
                                geometry: findPlaceResponse.Geometry(
                                  location: findPlaceResponse.Location(
                                      lat: newLatLng.latitude,
                                      lng: newLatLng.longitude),
                                ),
                                name: place.city,
                                formattedAddress: place.address.toString()),
                          );
                          addressDetailsController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 35,
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter delivery address..."),
                                  onChanged: (q) async {
                                    if (q.length == 0)
                                      Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .searchResultsPlaces = [];
                                    else
                                      Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .searchForAddress(q);
                                  },
                                ),
                              ),
                              searchController.text.length == 0
                                  ? Container()
                                  : IconButton(
                                      onPressed: () {
                                        searchController.text = '';
                                        Provider.of<LocationProvider>(context,
                                                listen: false)
                                            .searchResultsPlaces = [];
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Provider.of<LocationProvider>(context)
                                    .searchResultsPlaces
                                    .length ==
                                0
                            ? Container()
                            : Container(
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width - 35,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      Provider.of<LocationProvider>(context)
                                          .searchResultsPlaces
                                          .length,
                                  itemBuilder: (context, index) {
                                    findPlaceResponse.Candidates
                                        searchCandidate =
                                        Provider.of<LocationProvider>(context)
                                            .searchResultsPlaces[index];
                                    return ListTile(
                                      title:
                                          Text(searchCandidate.name.toString()),
                                      subtitle:
                                          Text(searchCandidate.name.toString()),
                                      onTap: () async {
                                        // Provider.of<LocationProvider>(context,
                                        //         listen: false)
                                        //     .selectedAddress = searchCandidate;
                                        LatLng newPos = LatLng(
                                            searchCandidate!
                                                    .geometry!.location!.lat ??
                                                24.3,
                                            searchCandidate!
                                                    .geometry!.location!.lng ??
                                                46.7);
                                        markers = [];
                                        markers.add(Marker(
                                            markerId:
                                                MarkerId("currentLocation"),
                                            position: newPos));
                                        final GoogleMapController controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          target: newPos,
                                          zoom: 14.4746,
                                        )));
                                        setState(() {});
                                        showAddressDetails(
                                            context, searchCandidate);
                                      },
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ]),
                ),
              ],
            );
          }
          return Center(
              child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ));
        }),
      ),
    );
  }

  void showAddressDetails(
      BuildContext context, findPlaceResponse.Candidates searchCandidate) {
    scaffoldState.currentState!.showBottomSheet(
      (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  Provider.of<AppPropertiesProvider>(context)
                      .strings["deliveryLocation"]
                      .toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  searchCandidate.plusCode != null
                      ? searchCandidate.formattedAddress.toString()
                      : searchCandidate.name.toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  searchCandidate.plusCode != null
                      ? searchCandidate.plusCode!.compoundCode.toString()
                      : searchCandidate.formattedAddress.toString(),
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: TextFormField(
                    controller: addressDetailsController,
                    validator: (v) => v!.length == 0
                        ? Provider.of<AppPropertiesProvider>(context,
                                listen: false)
                            .strings['requiredField']
                            .toString()
                        : null,
                    decoration: kBorderOutlinedInputDecoration(
                        context: context,
                        hintText: Provider.of<AppPropertiesProvider>(context)
                            .strings['addressDetails']
                            .toString()),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith(
                      (states) =>
                          Size(MediaQuery.of(context).size.width - 32, 30),
                    ),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).accentColor),
                  ),
                  onPressed: () async {
                    (await SharedPreferences.getInstance())
                      ..setDouble(
                          "lat", searchCandidate!.geometry!.location!.lat!)
                      ..setDouble(
                          "lng", searchCandidate!.geometry!.location!.lng!)
                      ..setString(
                          "addressDetails", addressDetailsController.text);
                    Navigator.pushReplacement(
                        context,
                        HomeScreenRoute(
                            locationData: LocationData.fromMap({
                          "latitude": searchCandidate!.geometry!.location!.lat!,
                          "longitude":
                              searchCandidate!.geometry!.location!.lng!,
                        })));
                  },
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings["confirmDeliveryAddress"]
                        .toString(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
    );
  }
}
