import 'dart:async';
import 'dart:io';
import 'package:conellas/clients/api.dart';
import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/profile.dart';
import 'package:conellas/pages/profileEdit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  final Dependencies deps;

  ProfileEdit(this.deps, {Key key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  File image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker.pickImage(source: source);
      //final camera = await ImagePicker.pickImage(source: ImageSource.camera);

      if (image == null) return;
      //if (camera == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

      /*final cameraTemporary = File(camera.path);
    setState(() => this.camera = cameraTemporary);*/
    } catch (e) {
      print('Failed to pick image $e');
    }
  }

  final _formKey = GlobalKey<FormState>();

  String firstname;
  String lastname;
  String username;
  String country;
  String city;
  String phone;
  //var photo = 'http://192.168.0.103:5000//media/uploads/photos/descarga.jpg';

  @override
  void initState() {
    super.initState();
    Timer.run(() => showWarning(context));
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
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
    var futureMe = widget.deps.api.me();
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
                    child: FutureBuilder<Me>(
                        future: futureMe,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.photo == null) {
                              return CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/proicon.png'));
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
                        }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      size.height * 0.19, size.height * 0.31, 0, 0),
                  height: size.height * 0.07,
                  width: size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Color(0xffF8991C),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.edit),
                    onPressed: () => _optionsDialogBox(),
                  ),
                ),
                Container(
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
                      onPressed: () async {
                        print(this.firstname);
                        print(this.lastname);
                        print(this.username);
                        print(this.country);
                        print(this.city);
                        print(this.phone);
                        print(this.image);

                        try {
                          if (!_formKey.currentState.validate()) return;
                          _formKey.currentState.save();

                          await widget.deps.api.updateAccount(
                            this.firstname,
                            this.lastname,
                            this.username,
                            this.country,
                            this.city,
                            this.phone,
                            this.image,
                          );
                          showSuccessDialog(context);
                        } catch (e) {
                          print(widget.deps.api.updateAccount(
                              this.firstname,
                              this.lastname,
                              this.username,
                              this.country,
                              this.city,
                              this.phone,
                              this.image));
                          showErrorDialog(context, e);
                        }
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
        key: _formKey,
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
                                    initialValue: firstname =
                                        snapshot.data.firstName,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.edit),
                                      labelText: '${snapshot.data.firstName}',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
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
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onSaved: (value) => firstname = value,
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
                                    initialValue: lastname =
                                        snapshot.data.lastName,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.edit),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: '${snapshot.data.lastName}',
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
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onSaved: (value) => lastname = value,
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
                                  initialValue: username =
                                      snapshot.data.username,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.edit),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onSaved: (value) => username = value,
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
                                  initialValue: country = snapshot.data.country,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.edit),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: '${snapshot.data.country}',
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
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onSaved: (value) => country = value,
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
                                  initialValue: city = snapshot.data.city,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.edit),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: '${snapshot.data.city}',
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
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onSaved: (value) => city = value,
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
                                  initialValue: phone = snapshot.data.phone,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.edit),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onSaved: (value) => phone = value,
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

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () => pickImage(ImageSource.camera),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Divider(
                      height: 20,
                    ),
                  ),
                  GestureDetector(
                    child: new Text('Gallery'),
                    onTap: () => pickImage(ImageSource.gallery),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  FlatButton(
                    color: Color(0xff3B2F8F),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      showImg(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showImg(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var selectorImg = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.only(top: 60),
      titlePadding: const EdgeInsets.all(20),
      title: Text("The image has been uploaded"),
      content: Text("You will see it when you save the changes"),
    );
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return selectorImg;
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var successDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.only(top: 60),
      titlePadding: const EdgeInsets.all(20),
      title: Text("Update Successfully"),
      content: Text("Now, you would see the changes"),
      actions: [
        Center(
          child: Container(
            width: size.width * 0.50,
            height: size.height * 0.06,
            child: FlatButton(
              color: Color(0xff3B2F8F),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Text("OK"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProfileView(widget.deps)));
              },
            ),
          ),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext _) {
        return successDialog;
      },
    );
  }

  void showErrorDialog(BuildContext context, err) {
    Size size = MediaQuery.of(context).size;
    var errorDialog = AlertDialog(
      title: Text('Error'),
      content: Text('Error'),
      actions: [
        Center(
          child: Container(
            width: size.width * 0.50,
            height: size.height * 0.06,
            child: FlatButton(
              color: Color(0xff3B2F8F),
              child: Text("Try again"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext _) {
        return errorDialog;
      },
    );
  }
}

void showWarning(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.only(top: 60),
      titlePadding: const EdgeInsets.all(20),
      title: Text('Warning'),
      content: Text('Always update your photo, every time you save a change.'),
      actions: [
        Center(
          child: Container(
            width: size.width * 0.50,
            height: size.height * 0.06,
            child: FlatButton(
              color: Color(0xff3B2F8F),
              child: Text("OK"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
      ],
    ),
  );
}
