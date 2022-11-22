import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/network/auth_api.dart';
import 'package:food_delivery_app/ui/widgets/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/app_properties_provider.dart';
import '../constants.dart';

class ConfirmNewAddressScreen extends StatefulWidget {
  ConfirmNewAddressScreen({
    Key? key,
    required this.lat,
    required this.lng,
    required this.name,
    required this.details,
  }) : super(key: key);
  double lat;
  double lng;

  final String name, details;
  @override
  State<ConfirmNewAddressScreen> createState() =>
      _ConfirmNewAddressScreenState();
}

class _ConfirmNewAddressScreenState extends State<ConfirmNewAddressScreen> {
  final addressNameController = TextEditingController();
  final addressDetailsController = TextEditingController();
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
                    .strings["confirmLocation"]
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
  late final Marker selectedAddressMarker;
  late CameraPosition _kGooglePlex;
  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.lat, widget.lng),
      zoom: 17,
    );
    markers.add(Marker(
      markerId: MarkerId("currentLocation"),
      position: LatLng(widget.lat, widget.lng),
    ));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _appBar(context),
              Expanded(
                flex: 2,
                child: Container(
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    markers: Set.of(markers),
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    liteModeEnabled: false,
                    tiltGesturesEnabled: false,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Container(
                        child: TextFormField(
                          controller: addressNameController,
                          validator: (v) => v!.length == 0
                              ? Provider.of<AppPropertiesProvider>(context,
                                      listen: false)
                                  .strings['requiredField']
                                  .toString()
                              : null,
                          decoration: kBorderOutlinedInputDecoration(
                              context: context,
                              hintText:
                                  Provider.of<AppPropertiesProvider>(context)
                                      .strings['addressName']
                                      .toString()),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.name.toString(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.details,
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
                              hintText:
                                  Provider.of<AppPropertiesProvider>(context)
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
                            (states) => Size(
                                MediaQuery.of(context).size.width - 32, 30),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).accentColor),
                        ),
                        onPressed: () async {
                          //TODO
                          if (_formKey.currentState!.validate()) {
                            showLoadingDialog(context);
                            await AuthAPI().addAddress(
                              context: context,
                              addressLabel: addressNameController.text,
                              addressDetails: addressDetailsController.text,
                              lat: widget.lat,
                              lng: widget.lng,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
