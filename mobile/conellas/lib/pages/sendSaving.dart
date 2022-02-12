import 'dart:async';
import 'dart:math';

import 'package:conellas/common/dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/deps.dart';
import '../clients/api.dart';
import 'home.dart';

class SendSaving extends StatefulWidget {
  final Dependencies deps;

  SendSaving(
    this.deps, {
    Account account,
    Key key,
  }) : super(key: key);

  @override
  _SendSavingState createState() {
    return new _SendSavingState();
  }
}

class _SendSavingState extends State<SendSaving> {
  final _howMuchCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  Future<void> _futurePayment;
  User _destUser;
  double price;
  String isoCode;
  double balanceDouble;
  String savingKey;
  String firstName;

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
    /*futureCountry.then((data) {
      price = data.rates.xlm;
      print(price);
    });*/

    futureMe.then((data) {
      isoCode = data.country;
      savingKey = data.savingKey;
      firstName = data.names;
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
              isPaying ? 'Paying ${firstName}...' : 'Send',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              if (!isPaying) {
                _savingSend();
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

  /*
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

   */

  void _savingSend() {
    var howMuch = double.parse(_howMuchCtrl.text.trim());
    setState(() {
      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.show();
      _futurePayment = widget.deps.api.pay(
        savingKey,
        howMuch,
        _descriptionCtrl.text.trim(),
      );
      _futurePayment.then(_done);
    });
  }

  void _done(_) {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.dismissHome();
    var howMuch = double.parse(_howMuchCtrl.text.trim());
    Size size = MediaQuery.of(context).size;
    var op1 = 1 + .05 / 1;
    var cadAno = pow(op1, 1);
    var cadAno5 = pow(op1, 5);
    var cadAno10 = pow(op1, 10);


    var op = howMuch * cadAno;
    var op5 = howMuch * cadAno5;
    var op10 = howMuch * cadAno10;

    var IntCompuesto = op.toStringAsFixed(2);
    var IntCompuesto5 = op5.toStringAsFixed(2);
    var IntCompuesto10 = op10.toStringAsFixed(2);

    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'That\'s it!',
        text: 'The amount ' +
            '\$ ' +
            '$howMuch ' +
            'has been successfully saved. This table will show an anticipation of what the money saved will be in 10 years.',
        confirmBtnText: 'Go it',
        confirmBtnColor: Color(0xff3B2F8F),
        widget: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Year',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'interest',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Total',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('1')),
                DataCell(Text('5%')),
                DataCell(Container(
                    width: size.width*0.30, //SET width
                    child: Text('\$ ' + IntCompuesto)))
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text('5%')),
                DataCell(Text('\$ ' + IntCompuesto5)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('10')),
                DataCell(Text('5%')),
                DataCell(Text('\$ ' + IntCompuesto10)),
              ],
            ),
          ],
        ),
        onConfirmBtnTap: () async {
          Navigator.popUntil(context, ModalRoute.withName('/navigatorBar'));
        });
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
        title: Text('Saving account'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          this._headerContainer(),
          this._balanceContainer(),
          this._msgContainer(),
          this._sendContainer(),
          this._fieldContainer(),
        ],
      ),
    );
  }
}
