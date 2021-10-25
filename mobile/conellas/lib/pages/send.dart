import 'dart:async';

import 'package:conellas/common/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/deps.dart';
import '../clients/api.dart';
import 'home.dart';

class SendPage extends StatefulWidget {
  final Dependencies deps;

  SendPage(
    this.deps, {
    Account account,
    Key key,
  }) : super(key: key);

  @override
  _SendPageState createState() {
    return new _SendPageState();
  }
}

class _SendPageState extends State<SendPage> {
  final _howMuchCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  Future<void> _futurePayment;
  User _destUser;
  double price;
  String isoCode;
  double balanceDouble;

  Widget _headerContainer() {
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

  Widget _balanceContainer() {
    Size size = MediaQuery.of(context).size;
    var futureMe = widget.deps.api.me();
    var futureCountry = widget.deps.api.price();
    var futureBalance = widget.deps.api.account();
    futureCountry.then((data) {
      price = data.rates.xlm;
      print(price);
    });

    futureMe.then((data) {
      isoCode = data.country;
      print(isoCode);
    });
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, size.height * 0.0, 0, 0),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: double.infinity,
              width: double.maxFinite,
              child: Stack(
                children: <Widget>[
                  Container(
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
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.04, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<Account>(
                          future: futureBalance,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              balanceDouble =
                                  double.parse(snapshot.data.balance);
                              print(balanceDouble);

                              try {
                                switch (isoCode) {
                                  case 'US':
                                    return Row(
                                      children: <Widget>[
                                        Text(
                                          currency.format(balanceDouble * price),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('  '),
                                        Text('USD',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white)),
                                      ],
                                    );
                                  case 'CA':
                                    return Row(
                                      children: <Widget>[
                                        Text(
                                          currency
                                              .format(
                                              balanceDouble * 16.50 * price)
                                              .replaceAll('\$', 'C\$'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('  '),
                                        Text(
                                          'CAD',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                      ],
                                    );
                                  case 'MX':
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          currency.format(this.balanceDouble *
                                              20.0 *
                                              this.price),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('  '),
                                        Text(
                                          'MXN',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                      ],
                                    );
                                  case 'IN':
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          currency
                                              .format(balanceDouble *
                                              74.55 *
                                              price)
                                              .replaceAll('\$', '₹'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('  '),
                                        Text(
                                          'INR',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
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
        ],
      ),
    );
  }

  Widget _fieldContainer() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.12, 0, 0),
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        children: <Widget>[
          Text(
            'Enter the amount',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              controller: _howMuchCtrl,
              onSubmitted: (_) {},
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Color(0xffF8991C),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, size.height * 0.04, 0, 0),
            child: Text(
              'Enter the Description',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
                controller: _descriptionCtrl,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Description (not required)',
                )),
          ),
        ],
      ),
    );
  }

  Widget _detailsContainer() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.50, 0, 0),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      height: double.infinity,
      width: double.maxFinite,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  child: Text(
                    'Recipient information',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height * 0.04, 0, 0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: '${_destUser.firstName}',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              helperText: 'First Name',
                              helperStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ))),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: '${_destUser.lastName}',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              helperText: 'Last Name',
                              helperStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ))),
                        ),
                      ),
                    ],
                  ),
                ),

                // SEGUNDA INFORMACION
                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height * 0.16, 0, 0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: '${_destUser.username}',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              helperText: 'User Name',
                              helperStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ))),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: '${_destUser.phone}',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              helperText: 'Phone#',
                              helperStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendContainer() {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _futurePayment,
      builder: (context, AsyncSnapshot<void> snapshot) {
        var isPaying = snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting;
        return Container(
          margin: EdgeInsets.fromLTRB(0, size.height * 0.40, 0, 0),
          padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
          width: double.infinity,
          height: size.height * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffF8991C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            ),
            child: Text(
              isPaying ? 'Paying ${_destUser.firstName}...' : 'Send',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              if (!isPaying) {
                _send();
              }
            },
          ),
        );
      },
    );
  }

  Widget _msgContainer() {
    return FutureBuilder(
      future: _futurePayment,
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasError) {
          return Container();
        }
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  void _send() {
    var howMuch = double.parse(_howMuchCtrl.text.trim());
    setState(() {
      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.show();
      _futurePayment = widget.deps.api.pay(
        _destUser.publicKey,
        howMuch,
        _descriptionCtrl.text.trim(),
      );
      _futurePayment.then(_done);
    });
  }

  void _savingSend() {
    var howMuch = double.parse(_howMuchCtrl.text.trim());
    setState(() {
      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.show();
      _futurePayment = widget.deps.api.pay(
        _destUser.savingKey,
        howMuch,
        _descriptionCtrl.text.trim(),
      );
      _futurePayment.then(_done);
    });
  }

  void _done(_) {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.dismissHome();
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: Text('That\'s it!', style: TextStyle(color: Colors.black)),
          content: Text('Your payment has completed successfully',
              style: TextStyle(color: Colors.black)),
          actions: [
            Center(
              child: Container(
                width: size.width * 0.50,
                height: size.height * 0.06,
                child: FlatButton(
                  color: Color(0xff3B2F8F),
                  child: Text('Got it'),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  onPressed: () {
                    Navigator.of(context).pop(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage(widget.deps)));
                  },
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
    this._destUser = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
        title: Name(widget.deps),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          this._headerContainer(),
          this._balanceContainer(),
          this._detailsContainer(),
          this._msgContainer(),
          this._sendContainer(),
          this._fieldContainer(),
        ],
      ),
    );
  }
}
