import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final IconData icon;
  const MyDrawerTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      onTap: onTap,
    );
  }
}
