import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/sendSaving.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';
import 'package:conellas/pages/search.dart';
import 'package:intl/intl.dart';

final currency = new NumberFormat.simpleCurrency();

class savingAccount extends StatefulWidget {
  final Dependencies deps;

  const savingAccount(this.deps, {Key key}) : super(key: key);

  @override
  _savingAccountState createState() {
    return new _savingAccountState();
  }
}

class _savingAccountState extends State<savingAccount> {
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
        title: Text('Saving account'),
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
    var futureBalance = widget.deps.api.saving();
    var futureMe = widget.deps.api.me();
    /*futureCountry.then((data) {
      price = data.rates.xlm;
      print(price);
    });*/

    futureMe.then((data) {
      isoCode = data.country;
      print(isoCode);
    });

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
                        'Money in savings account',
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
                      FutureBuilder<Saving>(
                        future: futureBalance,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            balanceDouble = double.parse(snapshot.data.balance);
                            print(balanceDouble);
                            try {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    currency.format(this.balanceDouble),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 45,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            } catch (e) {
                              print(e);
                            }
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
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
                                        SendSaving(widget.deps)));
                          },
                          child: Text(
                            'Deposit',
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
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Withdraw',
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

                    if (me?.username == item.destination.username) {
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
