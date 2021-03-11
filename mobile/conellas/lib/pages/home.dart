import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final currency = new NumberFormat.simpleCurrency();

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: FutureBuilder<Me>(
        future: futureMe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              leading: IconButton(
                color: Colors.white,
                icon: Icon(Icons.qr_code_rounded),
                iconSize: 35,
                onPressed: () {},
              ),
              title: Text(
                '${snapshot.data.firstName} ${snapshot.data.lastName}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                '@${snapshot.data.username}',
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
    var futureBalance = api.account();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 200,
      width: double.maxFinite,
      //Balance
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Available Money',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<Account>(
                future: futureBalance,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // TODO: use tryParse as recommended and handle error.
                    double balanceDouble = double.parse(snapshot.data.balance);
                    return Text(
                      currency.format(balanceDouble),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),

          //Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 250,
              ),
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 30,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget transactionsContainer() {
    return Container();
  }
}
