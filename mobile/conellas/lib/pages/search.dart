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
          this.appBarContainer(),
          this.headerContainer(),
          this.listContainer(),
        ],
      ),
    );
  }

  Widget appBarContainer() {
    return Container(
      child: AppBar(
        title: Text('Search'),
      ),
    );
  }

  Widget headerContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Form(
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search user',
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              height: 48,
            )
          ],
        ),
      ),
    );
  }

  Widget listContainer() {
    return Container();
  }
}
