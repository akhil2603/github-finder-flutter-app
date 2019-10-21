import 'package:flutter/material.dart';
import '../screen/Home/HomeWidget.dart';
import '../screen/About/AboutWidget.dart';

class NavigationWidget extends StatelessWidget {
  final List<Tab> myNavTabs = <Tab>[Tab(text: 'Home'), Tab(text: 'About')];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: myNavTabs.length,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: myNavTabs,
              ),
              title: Text('Github Finder App'),
            ),
            body: TabBarView(children: <Widget>[HomeWidget(), AboutWidget()])));
  }
}
