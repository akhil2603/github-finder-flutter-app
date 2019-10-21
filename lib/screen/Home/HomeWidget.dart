import 'package:flutter/material.dart';
import 'package:github_finder_app/components/UsersWidget.dart';
import '../../components/UsersWidget.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top:150.0),
                child: SingleChildScrollView(
                    child: Column(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[UsersWidget()],
                )
              ],
            ))),
            Positioned(
                child: Column(
              children: <Widget>[
                Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search Users',
                          border: OutlineInputBorder()),
                    ),
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 10)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: RaisedButton(
                            child: Text('Search'),
                            textColor: Colors.white,
                            color: Colors.black,
                            onPressed: () {
                              /* */
                            },
                          ),
                          margin: EdgeInsets.only(left: 15, right: 5)),
                    ),
                    Expanded(
                        child: Container(
                            child: RaisedButton(
                              child: Text('Clear'),
                              onPressed: () {
                                /* */
                              },
                            ),
                            margin: EdgeInsets.only(left: 10, right: 15)))
                  ],
                )
              ],
            ))
          ],
        )));
  }
}
