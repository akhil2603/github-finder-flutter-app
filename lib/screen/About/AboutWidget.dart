import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'About App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ),
            Container(
              child: Text(
                'App to search github users',
                style: TextStyle(fontSize: 16),
              )
            ),
            Container(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12)
              )
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
      )
    );
  }
}