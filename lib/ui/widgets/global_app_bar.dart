import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_properties_provider.dart';

class GlobalAppBar extends StatelessWidget {
  const GlobalAppBar({
    Key? key,
    required this.rightActions,
    required this.leftActions,
  }) : super(key: key);

  final Widget rightActions;
  final Widget leftActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  Provider.of<AppPropertiesProvider>(context).language == "en"
                      ? [rightActions, leftActions]
                      : [leftActions, rightActions],
            ),
          ),
          Center(
            child: Container(
              child: Text(
                Provider.of<AppPropertiesProvider>(context).appName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
