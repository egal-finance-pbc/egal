import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome home'),
      ),
      body: FutureBuilder(
        future: FlutterSession().get('token'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Text('Loading token...');
          }
          if (!snapshot.hasData) {
            return Text('Token not found');
          }
          return Text(snapshot.data);
        },
      ),
    );
  }
}
