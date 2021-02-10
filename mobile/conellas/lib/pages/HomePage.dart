import 'package:flutter/material.dart';
import 'Data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {

  final List<String>listof=["Maria","Alicia","Jose","Mario","Juan","Pepe","Ramirez"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
/*
      appBar: new AppBar(
        title: new Text("List View Builder"),
        backgroundColor: Colors.deepOrange,
      ),

 */

      body: new ListView.builder(
        reverse: true,
        itemBuilder: (context,int index)=>Data(this.listof[index]),
        itemCount: this.listof.length,

      ),


    );
  }
}