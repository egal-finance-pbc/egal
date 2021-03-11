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
  bool isSearch = false;

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
        leading: !isSearch
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    this.isSearch = false;
                  });
                },
              ),
        title: !isSearch
            ? Text('Search')
            : TextField(
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Search user here',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  this.isSearch = true;
                });
              }),
        ],
      ),
    );
  }

  Widget listContainer() {
    return Container();
  }
}
