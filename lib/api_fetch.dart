import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

import 'maps.dart';

class ApiFetch extends StatefulWidget {
  @override
  _ApiFetchState createState() => _ApiFetchState();
}

class _ApiFetchState extends State<ApiFetch> {
  final String apiUrl = "https://github-trending-api.now.sh/";

  List _myList = List();

  @override
  void initState() {
    this.fetchUsers();
    super.initState();
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    setState(() {
      _myList = json.decode(result.body);
    });
    return json.decode(result.body);
  }

  String _name(dynamic element) {
    return element['name'];
  }

  String _description(dynamic element) {
    return element['description'];
  }

  String _language(dynamic element) {
    return "Language: " + element["language"].toString();
  }

  void shareData(String name, String description, String language) {
    Share.share(
        'Name: ${name} \n Description: ${description} \n Language: ${language}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
          child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _myList == null ? 0 : _myList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _myList[index];

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  direction: Axis.horizontal,
                  actionExtentRatio: 0.25,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Maps())),
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(item['avatar'])),
                      title: Text(_name(item), style: GoogleFonts.raleway(fontSize: 25.0)),
                      subtitle: Text(_description(item), style: GoogleFonts.inconsolata(fontSize: 15.0),),
                      trailing: Text(_language(item)),
                    ),
                  ),
                  secondaryActions: [
                    IconSlideAction(
                      caption: "Delete",
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        setState(() {
                          _myList.removeAt(index);
                        });
                      },
                    ),
                    IconSlideAction(
                      caption: "Share",
                      color: Colors.blue,
                      icon: Icons.share,
                      onTap: () => shareData(
                          _name(item), _description(item), _language(item)),
                    ),
                  ],
                );
              })),
    );
  }
}
