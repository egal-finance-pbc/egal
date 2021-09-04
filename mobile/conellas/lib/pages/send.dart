import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Widget _headerContainer() {
    return Container(
      child: AppBar(
        title: Text('How much?'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Widget _fieldContainer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
        child: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.send,
          controller: _howMuchCtrl,
          onSubmitted: (_) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            fontSize: 80,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _detailsContainer() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: '@${_destUser.username} (${_destUser.fullName()})',
            ),
          ),
          TextField(
              controller: _descriptionCtrl,
              decoration: InputDecoration(
                labelText: 'Description (not required)',
              )),
        ],
      ),
    ));
  }

  Widget _sendContainer() {
    return FutureBuilder(
      future: _futurePayment,
      builder: (context, AsyncSnapshot<void> snapshot) {
        var isPaying = snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting;
        return Container(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
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
      _futurePayment = widget.deps.api.pay(
        _destUser.publicKey,
        howMuch,
        _descriptionCtrl.text.trim(),
      );
      _futurePayment.then(_done);
    });
  }

  void _done(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        return AlertDialog(
          title: Text('That\'s it!', style: TextStyle(color: Colors.white)),
          content: Text('Your payment has completed successfully', style: TextStyle(color: Colors.white)),
          actions: [
            FlatButton(
              child: Text('Got it', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage(widget.deps)));
                },
              color: Color(0xff3b2f8f),
            ),
          ],
          backgroundColor: Color(0xffF8991C),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments
    this._destUser = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          this._headerContainer(),
          this._fieldContainer(),
          this._detailsContainer(),
          this._sendContainer(),
          this._msgContainer(),
        ],
      ),
    );
  }
}
