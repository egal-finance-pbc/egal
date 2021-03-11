import 'package:conellas/clients/api.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() {
    return new _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  API api;

  @override
  void initState() {
    super.initState();
    this.api = API();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          this.headerContainer(),
          this.listContainer(),
        ],
      ),
    );
  }

  Widget headerContainer() {
    return Container(
      child: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
    );
  }

  Widget listContainer() {
    return Container();
  }
}
