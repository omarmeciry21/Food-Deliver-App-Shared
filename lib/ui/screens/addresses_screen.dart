import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/addresses.dart';
import 'package:food_delivery_app/data/network/auth_api.dart';
import 'package:food_delivery_app/data/network/location_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:food_delivery_app/providers/location_provider.dart';
import 'package:food_delivery_app/ui/widgets/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'add_new_address.dart';

class AddressesScreen extends StatefulWidget {
  AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  _appBar(BuildContext context) {
    final list = [
      IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
              Provider.of<AppPropertiesProvider>(context).language == "en"
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded)),
      IconButton(
          onPressed: () => setState(() {}), icon: Icon(Icons.refresh_rounded))
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                Provider.of<AppPropertiesProvider>(context).language == "en"
                    ? list
                    : list.reversed.toList(),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                Provider.of<AppPropertiesProvider>(context)
                    .strings["addresses"]
                    .toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Addresses>> getAddresses() async {
    List<Addresses> addresses =
        (await AuthAPI().getUserDetails(context)).addresses ?? [];
    for (int i = 0; i < addresses.length; i++) {
      addresses[i].addressLine = (await LocationAPI.getAddressFromLatLng(
              LatLng(addresses[i].latitude!, addresses[i].longitude!)))
          .address;
    }
    return addresses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showLoadingDialog(context);
          LocationData locationData = await LocationAPI.getCurrentLocation();
          Navigator.pop(context);
          Provider.of<LocationProvider>(context, listen: false)
              .searchResultsPlaces = [];
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddNewAddress(locationData: locationData)));
          setState(() {});
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder<List<Addresses>>(
                future: getAddresses(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Addresses> addressList = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: addressList.length,
                      itemBuilder: (context, index) {
                        final Addresses address = addressList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              address.name.toString(),
                            ),
                            subtitle: Text(
                              address.addressLine.toString(),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        Provider.of<AppPropertiesProvider>(
                                                context)
                                            .strings["deleteAddressTitle"]
                                            .toString()),
                                    content: Text(
                                        Provider.of<AppPropertiesProvider>(
                                                context)
                                            .strings["deleteAddressContent"]
                                            .toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          Provider.of<AppPropertiesProvider>(
                                                  context)
                                              .strings["cancel"]
                                              .toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          showLoadingDialog(context);
                                          try {
                                            await AuthAPI().deleteAddress(
                                                context: context,
                                                id: address.id.toString());
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          } catch (e) {
                                            print(e.toString());
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            showErrorDialog(context,
                                                errorMessage: e.toString());
                                          }
                                          setState(() {});
                                        },
                                        child: Text(
                                          Provider.of<AppPropertiesProvider>(
                                                  context)
                                              .strings["OK"]
                                              .toString(),
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete_forever_rounded),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).accentColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
