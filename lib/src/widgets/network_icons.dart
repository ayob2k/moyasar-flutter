import 'package:flutter/material.dart';

/// The widget that shows the Credit Cards icons.
class NetworkIcons extends StatelessWidget {
  final List<String> networks;
  const NetworkIcons({super.key, required this.networks});

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];

    for (var network in networks) {
      icons.add(NetworkIcon(name: 'assets/images/$network.png'));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [...icons, SizedBox(width: 10)],
    );
  }
}

class NetworkIcon extends StatelessWidget {
  const NetworkIcon({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name,
      height: 20,
      width: 35,
      package: 'moyasar',
    );
  }
}
