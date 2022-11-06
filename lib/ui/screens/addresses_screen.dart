import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/models/user_details.dart';
import 'package:food_delivery_app/data/network/auth_api.dart';
import 'package:food_delivery_app/providers/app_properties_provider.dart';
import 'package:provider/provider.dart';

class AddressesScreen extends StatelessWidget {
  AddressesScreen({Key? key}) : super(key: key);

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
                ),
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder<UserDetails>(
                future: AuthAPI().getUserDetails(context),
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
                  if (snapshot.hasData) {}
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
