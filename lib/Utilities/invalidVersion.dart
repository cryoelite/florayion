import 'package:flutter/material.dart';

class InvalidVer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Card(
          elevation: 8,
          child: Center(
            child: Text("Your app version is now unsupported, Please Update."),
          ),
        ),
      ),
    );
  }
}
