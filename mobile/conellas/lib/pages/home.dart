import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/QRscan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';
import 'package:conellas/pages/search.dart';
import 'package:intl/intl.dart';

final currency = new NumberFormat.simpleCurrency();

class HomePage extends StatefulWidget {
  final Dependencies deps;

  const HomePage(this.deps, {Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double price;
  String isoCode;
  double balanceDouble;

  @override
  Widget build(BuildContext context) {
    var futureMe = widget.deps.api.me();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
        title: Name(widget.deps),
        leading: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, size.height * 0.0001),
            margin: EdgeInsets.fromLTRB(0, size.height * 0.01, 0, 0),
            child: FutureBuilder<Me>(
                future: futureMe,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.photo == null) {
                      return CircleAvatar(
                          backgroundImage: AssetImage('assets/proicon.png'));
                    } else {
                      return CircleAvatar(
                          backgroundImage: NetworkImage(
                        'http://10.0.2.2:5000' + snapshot.data.photo,
                      ));
                    }
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                })),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          headerContainer(context),
          balanceContainer(context),
          GraficContainer(context),
          transactionsContainer(context),
        ],
      ),
    );
  }

  Widget headerContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    return Container(
      height: size.height * 0.53,
      //height: 320,
      decoration: BoxDecoration(
          color: Color(0xff3B2F8F),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          )),
    );
  }

  Widget balanceContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var futureCountry = widget.deps.api.price();
    var futureBalance = widget.deps.api.account();
    var futureMe = widget.deps.api.me();

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      //Balance
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height * 0.04, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Available Money',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height * 0.08, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<CountryBalance>(
                        future: futureCountry,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            for (var i = 0;
                                i < snapshot.data.data.length;
                                i++) {
                              price = snapshot.data.data[i].price;
                              print(price);
                            }
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return Text('');
                        },
                      ),
                      FutureBuilder<Me>(
                          future: futureMe,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              isoCode = snapshot.data.country;
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Text('');
                          }),
                      FutureBuilder<Account>(
                        future: futureBalance,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            price != null
                                ? balanceDouble =
                                    double.parse(snapshot.data.balance)
                                : print('Maldita sea');
                            try {
                              switch (isoCode) {
                                case 'US':
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        currency
                                            .format(balanceDouble * price * 20),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(' '),
                                      Text(
                                        'US',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                case 'CA':
                                  return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          currency
                                              .format(
                                                  balanceDouble * price * 16)
                                              .replaceAll('\$', 'C\$'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(' '),
                                        Text(
                                          'CA',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]);
                                case 'MX':
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        currency
                                            .format(balanceDouble * price * 20),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(' '),
                                      Text(
                                        'MXN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                case 'IN':
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        currency
                                            .format(
                                                balanceDouble * price * 74.55)
                                            .replaceAll('\$', '₹'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(' '),
                                      Text(
                                        'IN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                              }
                            } catch (e) {
                              print(e);
                            }
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height * 0.18, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.05,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchPage(widget.deps)));
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          color: Color(0xffF8991C),
                        ),
                      ),
                      Container(
                        height: size.height * 0.05,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => QRViewExample()));
                          },
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
                            borderRadius: BorderRadius.circular(80),
                          ),
                          color: Color(0xffF8991C),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height * 0.30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.05,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchPage(widget.deps)));
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.savings_rounded,
                                size: 28,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'savings account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          color: Color(0xffF8991C),
                        ),
                      ),
                    ],
                  ),
                ),
                //Buttons
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionsContainer(BuildContext context) {
    var paymentFuture = widget.deps.api.payments();
    var futureMe = widget.deps.api.me();
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.50, 0, 0),
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
      height: double.infinity,
      width: double.maxFinite,
      child: FutureBuilder(
        future: futureMe,
        builder: (context, snapshot) {
          var me = snapshot.data;
          return FutureBuilder(
            future: paymentFuture,
            builder: (context, AsyncSnapshot<List<Payment>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data[index];
                    final amount = currency.format(double.parse(item.amount));

                    var color = Colors.red;
                    var iconArrow = Icons.call_made_rounded;
                    var action = '-';
                    var sender = item.destination.username;
                    var backcolor = Color.fromRGBO(255, 153, 0, 0.20);
                    var descrip = item.description;
                    var dates = item.date;
                    DateTime now = new DateTime.now();
                    var dateNow = new DateTime(now.year, now.month, now.day);

                    if (me.username == item.destination.username) {
                      color = Colors.green;
                      iconArrow = Icons.call_received_rounded;
                      action = '+';
                      sender = item.source.username;
                    }

                    if (item.description == null) {
                      descrip = ' ';
                    }

                    return Column(
                      children: <Widget>[
                        Card(
                          color: Color(0xffF8991C),
                          elevation: 0,
                          child: ListTile(
                            leading: Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child: Text(dates),
                            ),
                            title: Text(
                              sender,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(descrip),
                            trailing: Text(
                              '$action $amount',
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold),
                            ),
                            tileColor: backcolor,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.white,
                      thickness: 1,
                    );
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

  Widget GraficContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.25, 0, size.height * 0.35),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(),
    );
  }
}

class Name extends StatefulWidget {
  final Dependencies deps;

  const Name(this.deps, {Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Name> {
  @override
  Widget build(BuildContext context) {
    var futureMe = widget.deps.api.me();
    return FutureBuilder<Me>(
      future: futureMe,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('${snapshot.data.username}');
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
