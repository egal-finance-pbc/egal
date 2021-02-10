import 'package:conellas/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:conellas/pages/Data.dart';

class BalancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       //Title
      appBar: AppBar(
          title: Text('ConEllas',
          style: TextStyle(
              color: Colors.white,
              fontSize: 30
          ),
          ),
      ),

      //Balance
      body: Padding(
      padding: EdgeInsets.all(10),
        child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Saldo',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 35
                  ),
                ),
             ),


              //MONEY
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  r"$ ""1,000.00",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 45
                  ),
                ),
              ),


        //BUTTONS
        Container(
          padding: EdgeInsets.fromLTRB(0,30,0,0),
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            RaisedButton(
              padding: EdgeInsets.fromLTRB(60, 16, 60, 16),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("Enviar"),
              onPressed: (){
                Navigator.of(context)
                    .push(
                    MaterialPageRoute(
                        builder: (context)=> Home()
                    )
                );
              },
            ),
            SizedBox(width: 35),
            RaisedButton(
              padding: EdgeInsets.fromLTRB(50, 16, 50, 16),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("Depositar"),
              onPressed:(){},
            ),
          ],
        ),
      ),



        //CARD
        Container(
          child: Scaffold(
            body: Home(),
          ),
            padding: EdgeInsets.fromLTRB(10,10,10,0),
            height: 550,
            width: double.maxFinite,
            ),





/*
       // DUPLICATES OF CARD (NOT LISTED)
        // BUT CAN BE USED
      Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        height: 80,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            r"$ "'User1',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25
                                            ),
                                          ),
                                    )
                                    ) ],
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height: 80,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    r"$ "'User1',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 25
                                                    ),
                                                  ),
                                                )
                                            ) ],
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height: 80,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    r"$ "'User1',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 25
                                                    ),
                                                  ),
                                                )
                                            ) ],
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height: 80,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    r"$ "'User1',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 25
                                                    ),
                                                  ),
                                                )
                                            ) ],
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height: 80,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    r"$ "'User1',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 25
                                                    ),
                                                  ),
                                                )
                                            ) ],
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height: 80,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    r"$ "'User1',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 25
                                                    ),
                                                  ),
                                                )
                                            ) ],
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),


 */
            ]),
      ),
    );

  }
}