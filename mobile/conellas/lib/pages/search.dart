import 'package:flutter/material.dart';

import '../common/deps.dart';

class SearchPage extends StatefulWidget {
  final Dependencies deps;

  SearchPage(this.deps, {Key key}) : super(key: key);

  @override
  _SearchPageState createState() {
    return new _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
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
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget listContainer() {
    return Container();
  }
}
