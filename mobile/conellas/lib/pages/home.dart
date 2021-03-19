import 'package:conellas/common/deps.dart';
import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final currency = new NumberFormat.simpleCurrency();

class HomePage extends StatefulWidget {
  final Dependencies deps;

  HomePage(this.deps, {Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
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
    var futureMe = widget.deps.api.me();
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
    var futureBalance = widget.deps.api.account();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 200,
      width: double.maxFinite,
      //Balance
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 150,
              ),
              SizedBox(
                width: 35,
              ),
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
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
                minWidth: 150,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget transactionsContainer() {
    var paymentFuture = widget.deps.api.payments();
    return Container(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: paymentFuture,
            builder: (context, AsyncSnapshot<List<Payment>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = snapshot.data[index];
                    double amountDouble = double.parse(item.amount);

                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.call_made),
                        title: Text('${item.destination.fullName()}'),
                        subtitle: Text('${item.description}'),
                        trailing: Text('${currency.format(amountDouble)}'),
                      ),
                    );
                  },
                );
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
