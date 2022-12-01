import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/widgets/language_custom_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/app_properties_provider.dart';
import '../widgets/drawer.dart';

class OthersScreen extends StatelessWidget {
  OthersScreen({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          Provider.of<AppPropertiesProvider>(context).language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Row(
          children: [
            buildDrawer(context),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 40,
                child: AppBar(
                  toolbarHeight: 40,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [],
                  leading: IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    Provider.of<AppPropertiesProvider>(context)
                        .strings['others']
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(
                        Provider.of<AppPropertiesProvider>(context)
                            .strings['language']
                            .toString(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      trailing: Container(
                        width: 100,
                        child: LanguagesCustomWidget(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
