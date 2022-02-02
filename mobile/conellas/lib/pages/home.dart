import 'dart:async';

import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/SendCardPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:graphic/graphic.dart';

import 'data.dart';
import 'savingsAccount.dart';

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
  List _cards;
  Map _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
    var futureBalance = widget.deps.api.account();
    var futureBalanceSaving = widget.deps.api.saving();

    Future futureMe = widget.deps.api.me();
    Future futureCountry = widget.deps.api.price();
    const list = ["1", "2"];
    const colors = [
      Colors.white,
      Colors.black,
    ];

    /*futureCountry.then((data) {
      price = data.rates.xlm;
      print(price);
    });*/


    List<Widget> Cards = [];
    for (int i = 0; i < 1; i++) {
      if (i == 0) {
        Cards.add(
          new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          cardSendPage(widget.deps)));
              print("SE IMPRIME");
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(size.height * 0.0,
                        size.height * 0.0, size.height * 0.0, size.height * 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage('assets/Card3.png'),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(size.height * 0.04),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.04, size.height * 0.04, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Money in Wallet',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff3B2F8F),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.04, size.height * 0.08, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FutureBuilder<Account>(
                            future: futureBalance,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                balanceDouble =
                                    double.parse(snapshot.data.balance);
                                print(balanceDouble);

                                try {
                                  return Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          currency.format(this.balanceDouble),
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Color(0xff3B2F8F),
                                            decoration: TextDecoration.none,
                                          ),
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.04, size.height * 0.22, 0, 0),
                    child: Row(
                      children: <Widget>[
                        FutureBuilder<Me>(
                          future: futureMe,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String isoCode = snapshot.data.country;
                              switch (isoCode) {
                                case 'US':
                                case 'CA':
                                case 'IN':
                                  return Text(
                                    '${snapshot.data.names} ${snapshot.data.paternal_surname}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff3B2F8F),
                                      decoration: TextDecoration.none,
                                    ),
                                  );
                                  break;
                                case 'MX':
                                  return Text(
                                    '${snapshot.data.names} ${snapshot.data.paternal_surname} ${snapshot.data.maternal_surname}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff3B2F8F),
                                      decoration: TextDecoration.none,
                                    ),
                                  );
                              }
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        Cards.add(
          new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          savingAccount(widget.deps)));
              print("SE IMPRIME");
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.0,
                        size.height * 0.0,
                        size.height * 0.0,
                        size.height * 0.0),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      image: DecorationImage(
                          image: AssetImage('assets/CardBlack.png'),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(size.height * 0.04),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.04, size.height * 0.04, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Savings account',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.04, size.height * 0.08, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FutureBuilder<Saving>(
                            future: futureBalanceSaving,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                balanceDouble =
                                    double.parse(snapshot.data.balance);
                                print(balanceDouble);
                                try {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          currency.format(this.balanceDouble),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.04, size.height * 0.22, 0, 0),
                    child: Row(
                      children: <Widget>[
                        FutureBuilder<Me>(
                          future: futureMe,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String isoCode = snapshot.data.country;
                              switch (isoCode) {
                                case 'US':
                                case 'CA':
                                case 'IN':
                                  return Text(
                                    '${snapshot.data.names} ${snapshot.data.paternal_surname}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  );
                                  break;
                                case 'MX':
                                  return Text(
                                    '${snapshot.data.names} ${snapshot.data.paternal_surname} ${snapshot.data.maternal_surname}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  );
                              }
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

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
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.10),
                  child: Swiper(
                    itemCount: cars.length,
                    itemWidth: size.height*0.50,
                    scrollDirection: Axis.vertical,
                    layout: SwiperLayout.CUSTOM,
                    customLayoutOption: new CustomLayoutOption(
                        startIndex: 1,
                        stateCount: 2
                    ).addTranslate([
                      new Offset(10.0, size.height*0.06),
                      new Offset(0, 0),
                      new Offset(10, size.height*0.06)
                    ]).addOpacity([
                      0.5,1
                    ]),
                    itemBuilder: (context, index){
                      if(index==0){
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        cardSendPage(widget.deps)));
                            print("SE IMPRIME");
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(size.height * 0.01,
                                      size.height * 0.01,
                                      size.height * 0.01,
                                      size.height * 0.60),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage('assets/Card3.png'),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(size.height * 0.04),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.04, size.height * 0.04, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Money in Wallet',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff3B2F8F),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.04, size.height * 0.08, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: FutureBuilder<Account>(
                                          future: futureBalance,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              balanceDouble =
                                                  double.parse(snapshot.data.balance);
                                              print(balanceDouble);

                                              try {
                                                return Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Text(
                                                        currency.format(this.balanceDouble),
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          color: Color(0xff3B2F8F),
                                                          decoration: TextDecoration.none,
                                                        ),
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
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.04, size.height * 0.22, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      FutureBuilder<Me>(
                                        future: futureMe,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String isoCode = snapshot.data.country;
                                            switch (isoCode) {
                                              case 'US':
                                              case 'CA':
                                              case 'IN':
                                                return Text(
                                                  '${snapshot.data.names} ${snapshot.data.paternal_surname}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff3B2F8F),
                                                    decoration: TextDecoration.none,
                                                  ),
                                                );
                                                break;
                                              case 'MX':
                                                return Text(
                                                  '${snapshot.data.names} ${snapshot.data.paternal_surname} ${snapshot.data.maternal_surname}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff3B2F8F),
                                                    decoration: TextDecoration.none,
                                                  ),
                                                );
                                            }
                                          } else if (snapshot.hasError) {
                                            return Text("${snapshot.error}");
                                          }
                                          // By default, show a loading spinner.
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        savingAccount(widget.deps)));
                            print("SE IMPRIME");
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.01,
                                      size.height * 0.01,
                                      size.height * 0.01,
                                      size.height * 0.60),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    image: DecorationImage(
                                        image: AssetImage('assets/CardBlack.png'),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(size.height * 0.04),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.04, size.height * 0.04, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Savings account',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.04, size.height * 0.08, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: FutureBuilder<Saving>(
                                          future: futureBalanceSaving,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              balanceDouble =
                                                  double.parse(snapshot.data.balance);
                                              print(balanceDouble);
                                              try {
                                                return Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Text(
                                                        currency.format(this.balanceDouble),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          color: Colors.white,
                                                          decoration: TextDecoration.none,
                                                        ),
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
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      size.height * 0.04, size.height * 0.22, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      FutureBuilder<Me>(
                                        future: futureMe,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String isoCode = snapshot.data.country;
                                            switch (isoCode) {
                                              case 'US':
                                              case 'CA':
                                              case 'IN':
                                                return Text(
                                                  '${snapshot.data.names} ${snapshot.data.paternal_surname}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                );
                                                break;
                                              case 'MX':
                                                return Text(
                                                  '${snapshot.data.names} ${snapshot.data.paternal_surname} ${snapshot.data.maternal_surname}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                );
                                            }
                                          } else if (snapshot.hasError) {
                                            return Text("${snapshot.error}");
                                          }
                                          // By default, show a loading spinner.
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
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

    return Container();
  }

  Widget GraficContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: Container(
      margin: EdgeInsets.fromLTRB(0, size.height*0.40, 0, 0),
      child: Column(
        children: <Widget>[
          /*
        Container(
          child: const Text(
            'Rose Chart',
            style: TextStyle(fontSize: 20),
          ),
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
        ),
        Container(
          child: const Text(
            '- With corner radius and shadow elevation.',
          ),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 350,
          height: 300,
          child: Chart(
            data: roseData,
            variables: {
              'name': Variable(
                accessor: (Map map) => map['name'] as String,
              ),
              'value': Variable(
                accessor: (Map map) => map['value'] as num,
                scale: LinearScale(min: 0, marginMax: 0.1),
              ),
            },
            elements: [
              IntervalElement(
                label: LabelAttr(
                    encoder: (tuple) => Label(tuple['name'].toString())),
                shape: ShapeAttr(
                    value: RectShape(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                    )),
                color: ColorAttr(
                    variable: 'name', values: Defaults.colors10),
                elevation: ElevationAttr(value: 5),
              )
            ],
            coord: PolarCoord(startRadius: 0.15),
          ),
        ),

         */
          /*
        Container(
          child: const Text(
            'Stacked Rose Chart',
            style: TextStyle(fontSize: 20),
          ),
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
        ),
        Container(
          child: const Text(
            '- A multiple variabes tooltip anchord top-left.',
          ),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 350,
          height: 300,
          child: Chart(
            data: adjustData,
            variables: {
              'index': Variable(
                accessor: (Map map) => map['index'].toString(),
              ),
              'type': Variable(
                accessor: (Map map) => map['type'] as String,
              ),
              'value': Variable(
                accessor: (Map map) => map['value'] as num,
                scale: LinearScale(min: 0, max: 1800),
              ),
            },
            elements: [
              IntervalElement(
                position:
                Varset('index') * Varset('value') / Varset('type'),
                color: ColorAttr(
                    variable: 'type', values: Defaults.colors10),
                modifiers: [StackModifier()],
              )
            ],
            coord: PolarCoord(),
            axes: [
              Defaults.circularAxis,
              Defaults.radialAxis..label = null,
            ],
            selections: {
              'tap': PointSelection(
                variable: 'index',
              )
            },
            tooltip: TooltipGuide(
              multiTuples: true,
              anchor: (_) => Offset.zero,
              align: Alignment.bottomRight,
            ),
          ),
        )
        ,
         */
          Container(
            child: const Text(
              'Race Chart',
              style: TextStyle(fontSize: 20),
            ),
            padding: const EdgeInsets.fromLTRB(150,150, 20, 5),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100,0,0,0),
            width: 200,
            height: 200,
            child: Chart(
              data: basicData,
              variables: {
                'genre': Variable(
                  accessor: (Map map) => map['genre'] as String,
                ),
                'sold': Variable(
                  accessor: (Map map) => map['sold'] as num,
                  scale: LinearScale(min: 0),
                ),
              },
              elements: [
                IntervalElement(
                  label: LabelAttr(
                      encoder: (tuple) => Label(tuple['sold'].toString())),
                  color: ColorAttr(
                    variable: 'genre',
                    values: Defaults.colors20,
                  ),
                )
              ],
              coord: PolarCoord(transposed: true),

            ),
          ),
        ],
      ),
    ),
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

class cardList{
  final int position;
  cardList(this.position,);
}

List<cardList> cars = [
  cardList(1),
  cardList(2),
];


class FullName extends StatefulWidget {
  final Dependencies deps;

  const FullName(this.deps, {Key key}) : super(key: key);

  @override
  _StateFullName createState() => _StateFullName();
}

class _StateFullName extends State<FullName> {
  @override
  Widget build(BuildContext context) {
    var futureMe = widget.deps.api.me();
    return FutureBuilder<Me>(
      future: futureMe,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String isoCode = snapshot.data.country;
          switch (isoCode) {
            case 'US':
            case 'CA':
            case 'IN':
              return Text(
                '${snapshot.data.names} ${snapshot.data.paternal_surname}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff3B2F8F),
                ),
              );
              break;
            case 'MX':
              return Text(
                '${snapshot.data.names} ${snapshot.data.paternal_surname} ${snapshot.data.maternal_surname}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff3B2F8F),
                ),
              );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}