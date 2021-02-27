import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
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
          this.balanceContainer(),
          this.transactionsContainer(),
        ],
      ),
    );
  }

  Widget headerContainer() {
    var futureMe = api.me();
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: FutureBuilder<Me>(
        future: futureMe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              leading: IconButton(
                color: Colors.white,
                icon: Icon(Icons.qr_code),
                iconSize: 35,
                onPressed: () {},
              ),
              title: Text(
                snapshot.data.firstName + ' ' + snapshot.data.lastName,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                snapshot.data.username,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget balanceContainer() {
    return Container();
  }

  Widget transactionsContainer() {
    return Container();
  }
}
