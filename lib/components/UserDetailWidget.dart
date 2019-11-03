import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class User {
  final String login;
  final String avatarUrl;
  final String url;
  final int publicRepos;
  final int publicGists;
  final int followers;
  final int following;
  final String company;
  final String name;
  final String blog;
  final String location;
  final String email;
  final bool hireable;
  final String bio;

  User(
      {this.login,
      this.avatarUrl,
      this.url,
      this.publicRepos,
      this.publicGists,
      this.followers,
      this.following,
      this.company,
      this.name,
      this.blog,
      this.location,
      this.email,
      this.hireable,
      this.bio});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        login: json['login'],
        avatarUrl: json['avatar_url'],
        url: json['url'],
        publicRepos: json['public_repos'],
        publicGists: json['public_gists'],
        followers: json['followers'],
        following: json['following'],
        company: json['company'],
        name: json['name'],
        blog: json['blog'],
        location: json['location'],
        hireable: json['hireable'],
        bio: json['bio']);
  }
}

Future<Map<String, dynamic>> fetchUser(name) async {
  final response = await http.get(
      "https://api.github.com/users/$name?client_id='1d3f3660e76e52661e12'&client_secret='a35253f6935091fcfb0956da81e5fbc4ce2bb2ad'");
  if (response.statusCode == 200) {
    Map<String, dynamic> responseJson = json.decode(response.body);
    return responseJson;
    // return json.decode(response.body).map((item) => new User.fromJson(item)).toList();
  } else {
    throw ('Failed to load user');
  }
}

class UserDetailWidget extends StatefulWidget {
  final name;
  final BuildContext context;
  UserDetailWidget({Key key, @required this.name, this.context})
      : super(key: key);

  @override
  UserState createState() => UserState();
}

class UserState extends State<UserDetailWidget> {
  Future<Map<String, dynamic>> user;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    user = fetchUser(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${widget.name}'s Details")),
        body: Container(
            child: FutureBuilder<Map<String, dynamic>>(
                future: user,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Center(
                        child: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                            height: 30.0,
                            width: 30.0),
                      )
                    ]);
                  Map<String, dynamic> showUser = snapshot.data;
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Card(
                          child: Container(
                              width: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: CircleAvatar(
                                              maxRadius: 50,
                                              backgroundImage: NetworkImage(
                                                  showUser['avatar_url']))),
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(showUser['name'])),
                                      Container(
                                        child: showUser['hireable'] != null &&
                                                showUser['hireable'] == true
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('hireable:'),
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('hireable:'),
                                                  Icon(Icons.clear,
                                                      color: Colors.red)
                                                ],
                                              ),
                                      )
                                    ],
                                  ),
                                  RaisedButton(
                                    child: Text('View Github Profile'),
                                    color: Colors.black,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      Navigator.push(
                                          widget.context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WillPopScope(
                                                    onWillPop: () async {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserDetailWidget(
                                                                      name: showUser[
                                                                          'login'],
                                                                      context:
                                                                          context)));
                                                      return false;
                                                    },
                                                    child: Scaffold(
                                                        appBar: AppBar(
                                                            title: Text(
                                                                'Github Profile')),
                                                        body: WebView(
                                                            initialUrl:
                                                                showUser[
                                                                    'html_url'],
                                                            javascriptMode:
                                                                JavascriptMode
                                                                    .unrestricted,
                                                            onWebViewCreated:
                                                                (WebViewController
                                                                    webViewController) {
                                                              _controller.complete(
                                                                  webViewController);
                                                            })),
                                                  )));
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            width: 150.0,
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child:
                                                FloatingActionButton.extended(
                                              label: Text(
                                                  "Following: ${showUser['following']}"),
                                              backgroundColor: Colors.white60,
                                              foregroundColor: Colors.black,
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            width: 150.0,
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child:
                                                FloatingActionButton.extended(
                                              label: Text(
                                                  "Public Gists: ${showUser['public_gists']}"),
                                              backgroundColor: Colors.black,
                                              foregroundColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            width: 150.0,
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child:
                                                FloatingActionButton.extended(
                                              label: Text(
                                                  "Followers: ${showUser['followers']}"),
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            width: 150.0,
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child:
                                                FloatingActionButton.extended(
                                              label: Text(
                                                  "Public Repos: ${showUser['public_repos']}"),
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )))
                    ],
                  );
                })));
  }
}
