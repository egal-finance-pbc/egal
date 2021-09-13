import 'package:conellas/clients/api.dart';
import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/profile.dart';
import 'package:conellas/pages/profileEdit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class profileEdit extends StatefulWidget {
  final Dependencies deps;

  const profileEdit(this.deps, {Key key}) : super(key: key);

  @override
  _profileEditState createState() => _profileEditState();
}

class _profileEditState extends State<profileEdit> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(IconData(0xe57f, fontFamily: 'MaterialIcons')))
        ],
      ),
      body: Stack(
        children: <Widget>[
          backgroudProfile(context),
          profileForm(context),
        ],
      ),
    );
  }

  Widget backgroudProfile(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: size.height * 0.50,
                  //height: 320,
                  decoration: BoxDecoration(
                      color: Color(0xff3B2F8F),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      )),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.05, 0, 0),
                    height: size.height * 0.30,
                    width: size.height * 0.30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Color(0xffF8991C),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Icon(
                        Icons.face,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.29, size.height * 0.40, 0, 0),
                    height: size.height * 0.07,
                    width: size.height * 0.07,
                    decoration: BoxDecoration(
                      color: Color(0xffF8991C),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.save),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    profileView(widget.deps)));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileForm(BuildContext context) {
    var futureMe = widget.deps.api.me();
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.47, 0, 0),
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
      height: double.infinity,
      width: double.maxFinite,
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.0, 0, 0),
                    child: Container(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<Me>(
                              future: futureMe,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.edit),
                                        labelText: '${snapshot.data.username}',
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2,
                                            ))),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                // By default, show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<Me>(
                              future: futureMe,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextFormField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.edit),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        labelText: '${snapshot.data.username}',
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
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2,
                                            ))),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                // By default, show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // primer ROW


                  //Segundo ROW
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.10, 0, 0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: FutureBuilder<Me>(
                            future: futureMe,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.edit),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      labelText: '${snapshot.data.username}',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      helperText: 'Username',
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
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          flex: 1,
                          child: FutureBuilder<Me>(
                            future: futureMe,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.edit),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      labelText: '${snapshot.data.username}',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      helperText: 'Country',
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
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),


                  //Tercer ROW
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.20, 0, 0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: FutureBuilder<Me>(
                            future: futureMe,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.edit),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      labelText: '${snapshot.data.username}',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      helperText: 'City',
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
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          flex: 1,
                          child: FutureBuilder<Me>(
                            future: futureMe,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.edit),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      labelText: '${snapshot.data.phone}',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      helperText: 'Phone #',
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
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
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
      ),
    );
  }
}