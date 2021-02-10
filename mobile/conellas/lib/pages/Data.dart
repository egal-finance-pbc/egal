import 'package:flutter/material.dart';

class Data extends StatelessWidget {

  final String name;

  Data(this.name);

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(10.0),
      child: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[

            new Container(
              padding: EdgeInsets.all(10.0),
              child: new CircleAvatar(
                child: new Text(name[0]),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),

            ),

            new Text(name,style: TextStyle(
                fontSize: 21.0,
                color: Colors.blue
            ),
            )



          ],
        ),


      ),

    );
  }
}

/*
class List extends StatefulWidget {
  @override
  _List createState() => new _List();
}


//List Test
//Convert to card
class _List extends State<List>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildListView(),
    );

  }
  ListView _buildListView(){
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (_, index){
          return ListTile(
            title: Text('User #$index'),
            subtitle: Text(r"$ ""-1,000.00"),
            focusColor: Colors.red,
          );

        }
    );
  }
}






//List to test
/*
class list{
  String titleMov;
  String Time;
  String Money;
  Color color;
  String img;


  list(this.titleMov,this.Time,this.Money,this.color);

  static List<list> Lists(){
    return [list("Movimiento 1","12:30 pm", r"$ ""1,000.00", Colors.black),
      list("Movimiento 1","12:30 pm", r"$ ""1,000.00", Colors.black),
      list("Movimiento 2","12:30 pm", r"$ ""1,000.00", Colors.black),
      list("Movimiento 3","12:30 pm", r"$ ""1,000.00", Colors.black),
      list("Movimiento 4","12:30 pm", r"$ ""1,000.00", Colors.black),
      list("Movimiento 5","12:30 pm", r"$ ""1,000.00", Colors.black)
    ];
  }

}

 */

 */
