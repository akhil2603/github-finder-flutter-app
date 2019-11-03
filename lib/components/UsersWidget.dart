import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_finder_app/components/UserDetailWidget.dart';
import 'package:http/http.dart' as http;

class Users {
  final String login;
  final String avatarUrl;

  Users({this.login, this.avatarUrl});
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(login: json['login'], avatarUrl: json['avatar_url']);
  }
}


Future<List<Users>> fetchUsers() async {
  final response = await http.get(
      "https://api.github.com/users?client_id='1d3f3660e76e52661e12'&client_secret='a35253f6935091fcfb0956da81e5fbc4ce2bb2ad'");
  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body);
    return responseJson.map((item) => new Users.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load Users');
  }
}

class UsersWidget extends StatefulWidget {
  UsersWidget({Key key}) : super(key: key);

  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<UsersWidget> {
  Future<List<Users>> users;
  @override
  void initState() {
    super.initState();
    users = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 10),
        width: double.infinity,
        child: FutureBuilder<List<Users>>(
            future: users,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Column(children: [
                  Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      height: 30.0,
                      width: 30.0)
                ]);
              List<Users> showUsers = snapshot.data;
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: showUsers
                    .map((item) => Container(
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage("${item.avatarUrl}"),
                                        maxRadius: 40),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10)),
                                Text(item.login,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: RaisedButton(
                                      child: Text('More'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => UserDetailWidget(name: item.login, context: context))
                                        );
                                      },
                                      color: Colors.black,
                                      textColor: Colors.white,
                                    ),
                                    width: 70.0)
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            }));
  }
}
