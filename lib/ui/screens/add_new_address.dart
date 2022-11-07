import 'dart:async';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/network/location_api.dart';
import 'package:food_delivery_app/providers/location_provider.dart';
import 'package:food_delivery_app/ui/screens/confirm_new_address_screen.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../data/models/find_place_response_model.dart' as findPlaceResponse;
import '../../providers/app_properties_provider.dart';

class AddNewAddress extends StatefulWidget {
  AddNewAddress({
    Key? key,
    required this.locationData,
  }) : super(key: key);
  final LocationData locationData;

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  late GeoMethods geoMethods;
  late TextEditingController controller;

  Completer<GoogleMapController> _controller = Completer();

  late final Marker selectedAddressMarker;
  late CameraPosition _kGooglePlex;
  late final searchController;

  _appBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
  @override
  void initState() {
    searchController = TextEditingController()
      ..addListener(() {
        if (searchController.text.length == 0)
          Provider.of<LocationProvider>(context, listen: false)
              .searchResultsPlaces = [];
      });
    super.initState();
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.locationData.latitude ?? 24.3,
          widget.locationData.longitude ?? 46.7),
      zoom: 14.4746,
    );
    markers.add(Marker(
      markerId: MarkerId("currentLocation"),
      position: LatLng(widget.locationData.latitude ?? 24.3,
          widget.locationData.longitude ?? 46.7),
    ));
  }

  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                        final latlng = LatLng(
                            widget.locationData.latitude ?? 24.3,
                            widget.locationData.longitude ?? 46.7);
                        GeoData place =
                            await LocationAPI.getAddressFromLatLng(latlng);
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
                            await LocationAPI.getAddressFromLatLng(newLatLng);
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
                                  findPlaceResponse.Candidates searchCandidate =
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
                                          markerId: MarkerId("currentLocation"),
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
                ],
              ),
            ),
          ],
        ),
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
            width: MediaQuery.of(context).size.width,
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
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith(
                      (states) =>
                          Size(MediaQuery.of(context).size.width - 32, 30),
                    ),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmNewAddressScreen(
                                  lat:
                                      searchCandidate!.geometry!.location!.lat!,
                                  lng:
                                      searchCandidate!.geometry!.location!.lng!,
                                  name: searchCandidate.plusCode != null
                                      ? searchCandidate.formattedAddress
                                          .toString()
                                      : searchCandidate.name.toString(),
                                  details: searchCandidate.plusCode != null
                                      ? searchCandidate.plusCode!.compoundCode
                                          .toString()
                                      : searchCandidate.formattedAddress
                                          .toString(),
                                )));
                  },
                  child: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings["confirmLocation"]
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
