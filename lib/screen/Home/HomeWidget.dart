import 'package:flutter/material.dart';
import 'package:github_finder_app/components/UsersWidget.dart';
import '../../components/UsersWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class HomeWidget extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeWidget> {
  final searchInputController = TextEditingController();
  bool filtered = false;
  String searchedText = '';
  Future<List<dynamic>> users;
  Widget renderUserWidget() {
  switch(filtered) {
    case true:
    users = searchedUsers(searchedText);
    break;
    case false:
    users = fetchUsers();
    break;
    default:
    return UsersWidget(users: users);
  }
  return UsersWidget(users: users);   
}
  @override
  void initState() {
    super.initState();
  }
   
  @override
  void dispose() {
    searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 150.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: <Widget>[ renderUserWidget()],
                    )
                  ],
                ))),
            Positioned(
                child: Column(
              children: <Widget>[
                Container(
                    child: TextField(
                      controller: searchInputController,
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
                              setState((){
                                filtered = true;
                                searchedText = searchInputController.text;
                              });
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                          margin: EdgeInsets.only(left: 15, right: 5)),
                    ),
                    Expanded(
                        child: Container(
                            child: RaisedButton(
                              child: Text('Clear'),
                              onPressed: () {
                                setState(() {
                                  searchInputController.clear();
                                 filtered = false; 
                                 searchedText = '';
                                });
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


Future<List<dynamic>> fetchUsers() async {
  final response = await http.get(
      "https://api.github.com/users?client_id='1d3f3660e76e52661e12'&client_secret='a35253f6935091fcfb0956da81e5fbc4ce2bb2ad'");
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body);
    return responseJson.map((item) => new Users.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load Users');
  }
}

Future<List<dynamic>> searchedUsers(text) async {
  final response = await http.get("https://api.github.com/search/users?q=$text&client_id='1d3f3660e76e52661e12'&client_secret='a35253f6935091fcfb0956da81e5fbc4ce2bb2ad'");
  if(response.statusCode == 200) {
    List responseJson = json.decode(response.body)['items'];
     return responseJson.map((item)=> new Users.fromJson(item)).toList();
  } else {
    throw Exception('Failed to Search User');
  }

}

