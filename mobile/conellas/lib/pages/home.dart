import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Future<Me> futureMe;
  var api = API();

  @override
  void initState() {
    super.initState();
    futureMe = api.me();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: FutureBuilder<Me>(
          future: futureMe,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                leading: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.qr_code),
                  iconSize: 35,
                  onPressed: (){
                  },
                ),
                title: Text(
                    snapshot.data.firstName +' '+ snapshot.data.lastName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  snapshot.data.username,
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
      ),
    );
  }
}











