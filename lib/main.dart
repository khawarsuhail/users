import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Map _data;
List _users;
void main() async {
  _data = await getAllUser();
  _users = _data['users'];
  runApp(new MaterialApp(
    title: 'Users',
    home: new User(),
  ));
}

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Users'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: new Center(
          child: new ListView.builder(
            itemCount: _users.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              final index = position;

              var name = _users[index]['name'];
              var userid = _users[index]['userid'];
              return new ListTile(
                title: new Text(
                  "$name",
                  style: new TextStyle(
                      fontSize: 14.5,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: new Text(
                  "Tap for User Details",
                  style: new TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.green,
                  child: new Text(
                    "$userid",
                    style: new TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () {
                  _showDetail(context, userid.toString());
                },
              );
            },
          ),
        ));
  }
}

void _showDetail(BuildContext context, String userid) async {
  String apiUrl =
      "https://z.trakntell.com/tnt/servlet/tntAPIGetUserDetails?$userid";
  http.Response response = await http.get(apiUrl);

  Map detail = json.decode(response.body);

  showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              new Container(
                  alignment: Alignment.center,
                  color: const Color(0xFF1BC0C5),
                  child: new Text(
                    "USER DETAILS!",
                    style: TextStyle(color: Colors.white),
                  )),
              new Image.network(detail['pic_1']),
              new Image.network(detail['pic_2']),
              new Image.network(detail['pic_3']),
              new Image.network(detail['pic_4']),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: Colors.white),
                ),
                color: const Color(0xFF1BC0C5),
              )
            ],
          ),
        );
      });
}

Future<Map> getAllUser() async {
  String apiUrl = "https://z.trakntell.com/tnt/servlet/tntAPIGetUsers";
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
