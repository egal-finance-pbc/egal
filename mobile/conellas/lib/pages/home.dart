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
      body: Stack(
        children: <Widget>[
          headerContainer(context),
          balanceContainer(context),
          transactionsContainer(context),
        ],
      ),
    );
  }

  Widget headerContainer(BuildContext context) {
    var futureMe = widget.deps.api.me();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    return Container(
      color: Color(0xffF8991C),
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: FutureBuilder<Me>(
        future: futureMe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              leading: IconButton(
                color: Color(0xff3b2f8f),
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

  Widget balanceContainer(BuildContext context) {
    var futureBalance = widget.deps.api.account();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 35),
      height: 400,
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
              color: Color(0xff3b2f8f),
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
                        color: Color(0xff3b2f8f),
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
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff3b2f8f),
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 150,
                color: Color(0xff3b2f8f),
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
                      color: Color(0xff3b2f8f),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff3b2f8f),
                      ),
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff3b2f8f),
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 150,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget transactionsContainer(BuildContext context) {
    var paymentFuture = widget.deps.api.payments();
    var futureMe = widget.deps.api.me();
    return Container(
      margin: const EdgeInsets.only(top: 250),
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      height: double.infinity,
      width: double.maxFinite,
      child: FutureBuilder(
        future: futureMe,
        builder: (context, snapshot) {
          var me = snapshot.data;
          return FutureBuilder(
            future: paymentFuture,
            builder: (context, AsyncSnapshot<List<Payment>> snapshot) {
              if (snapshot.hasData && me.username != "") {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data[index];
                    final amount = currency.format(double.parse(item.amount));

                    var color = Colors.red;
                    var iconArrow = Icons.call_made_rounded;
                    var action = '-';
                    var sender = item.destination.fullName();
                    var backcolor = Color.fromRGBO(255, 153, 0, 0.20);

                    if (me.username == item.destination.username) {
                      color = Colors.green;
                      iconArrow = Icons.call_received_rounded;
                      action = '+';
                      sender = item.source.fullName();

                    }

                    return ListTile(
                      leading: Icon(iconArrow, color: Color(0xff3b2f8f)),
                      title: Text(sender),
                      subtitle: Text('${item.description}'),
                      trailing: Text(
                        '$action $amount',
                        style: TextStyle(color: color),
                      ),
                      tileColor: backcolor,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 12);
                  },
                );
              }
              return CircularProgressIndicator();
            },
          );
        },
      ),
    );
  }
}
