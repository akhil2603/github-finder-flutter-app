import 'dart:async';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_finder_app/components/UserDetailWidget.dart';
// import 'package:http/http.dart' as http;

class Users {
  final String login;
  final String avatarUrl;

  Users({this.login, this.avatarUrl});
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(login: json['login'], avatarUrl: json['avatar_url']);
  }
}






class UsersWidget extends StatefulWidget {
  final Future<List<dynamic>> users;
  UsersWidget({Key key, this.users}) : super(key: key);

  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<UsersWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 10),
        width: double.infinity,
        child: FutureBuilder<List<dynamic>>(
            future: widget.users,
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
