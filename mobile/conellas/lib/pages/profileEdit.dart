import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:conellas/clients/api.dart';
import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/profile.dart';
import 'package:conellas/pages/profileEdit.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/country_selection_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:csc_picker/csc_picker.dart';

import 'navigatorBar.dart';

class ProfileEdit extends StatefulWidget {
  final Dependencies deps;

  ProfileEdit(this.deps, {Key key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  File image;
  Future pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile image = await _picker.pickImage(source: source);
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
  String state;
  String cities;
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  DefaultCountry vacio;
  //var futureMe;
  //var photo = 'http://192.168.0.103:5000//media/uploads/photos/descarga.jpg';

  @override
  void initState() {
    super.initState();
    //Timer.run(() => showWarning(context));
    var futureMe = widget.deps.api.me();
    futureMe.then((data) {
      setState(() {
        country = data.country;
        state = data.state;
        cities = data.city;
      });
    });
    print(country);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
        title: Text('Edit Profile'),
        actions: <Widget>[
          /*
          IconButton(
              color: Colors.white,
              icon: Icon(Icons.settings),
              onPressed: () {}),
           */
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
                  height: size.height * 0.43,
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
                                  backgroundImage: NetworkImage(snapshot.data.photo,
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        size.height * 0.35, size.height * 0.33, 0, 0),
                    height: size.height * 0.07,
                    width: size.width * 0.14,
                    decoration: BoxDecoration(
                      color: Color(0xffF8991C),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        print(this.cityValue);
                        print(this.stateValue);

                        try {
                          if (!_formKey.currentState.validate()) return;
                          _formKey.currentState.save();

                          await widget.deps.api.updateAccount(
                            cityValue == '' ? this.cities : cityValue,
                            stateValue == '' ? this.state : stateValue,
                            //this.phone,
                            //this.image,
                          );
                          showSuccessDialog(context);
                        } catch (e) {
                          print(widget.deps.api.updateAccount(
                            this.city,
                            this.stateValue,
                            //this.phone,
                            /*this.image*/
                          ));
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
      margin: EdgeInsets.fromLTRB(0, size.height * 0.40, 0, 0),
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
      height: double.infinity,
      width: double.maxFinite,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
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
                                    /*initialValue: firstname =
                                        snapshot.data.firstName,*/
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff3B2F8F),
                                          width: 2,
                                        ),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: Color(0xff3B2F8F),
                                      ),
                                      labelText: '${snapshot.data.names}',
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      helperText: 'Names',
                                      helperStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff3B2F8F),
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
                            width: 10,
                          ),
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<Me>(
                              future: futureMe,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String isoCode = snapshot.data.country;
                                  return TextFormField(
                                    /*initialValue: lastname =
                                        snapshot.data.lastName,*/
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff3B2F8F),
                                          width: 2,
                                        ),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: Color(0xff3B2F8F),
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      labelText: isoCode == 'MX'
                                          ? '${snapshot.data.paternal_surname} ${snapshot.data.maternal_surname}'
                                          : '${snapshot.data.paternal_surname}',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      helperText: 'Surnames',
                                      helperStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff3B2F8F),
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
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.12, 0, 0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: FutureBuilder<Me>(
                            future: futureMe,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TextFormField(
                                  enabled: false,
                                  initialValue: username =
                                      snapshot.data.username,
                                  decoration: InputDecoration(
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
                                    const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff3B2F8F),
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff3B2F8F),
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
                          width: 10,
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
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff3B2F8F),
                                        width: 2,
                                      ),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Color(0xff3B2F8F),
                                    ),
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
                                    const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  Container(
                      margin: EdgeInsets.fromLTRB(0, size.height * 0.20, 0, 0),
                      height: 600,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.0,
                          ),

                          ///Adding CSC Picker Widget in app
                          //sleep(Duration(seconds:5));
                          country == null
                              ? CircularProgressIndicator()
                              : CSCPicker(
                            layout: Layout.horizontal,
                            defaultCountry: country == 'MX'
                                ? DefaultCountry.Mexico
                                : country == 'US'
                                ? DefaultCountry.United_States
                                : country == 'CA'
                                ? DefaultCountry.Canada
                                : country == 'IN'
                                ? DefaultCountry.India
                                : vacio,

                            ///Enable disable state dropdown [OPTIONAL PARAMETER]
                            showStates: true,

                            /// Enable disable city drop down [OPTIONAL PARAMETER]
                            showCities: true,

                            ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                            flagState: CountryFlag.ENABLE,

                            ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                            dropdownDecoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 2),
                                )),

                            ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                            disabledDropdownDecoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xff3B2F8F), width: 2),
                                )),

                            ///placeholders for dropdown search field
                            countrySearchPlaceholder: "Country",
                            stateSearchPlaceholder: "State",
                            citySearchPlaceholder: "City",

                            ///labels for dropdown
                            countryDropdownLabel: "*Country",
                            stateDropdownLabel: state,
                            cityDropdownLabel: cities,

                            ///Default Country
                            //defaultCountry: DefaultCountry.India,

                            ///Disable country dropdown (Note: use it with default country)
                            disableCountry: true,

                            ///selected item style [OPTIONAL PARAMETER]
                            selectedItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                            dropdownHeadingStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),

                            ///DropdownDialog Item style [OPTIONAL PARAMETER]
                            dropdownItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///Dialog box radius [OPTIONAL PARAMETER]
                            dropdownDialogRadius: 10.0,

                            ///Search bar radius [OPTIONAL PARAMETER]
                            searchBarRadius: 50.0,

                            ///triggers once country selected in dropdown
                            onCountryChanged: (value) {
                              /*setState(() {
                      ///store value in country variable
                      countryValue = value;
                    });*/
                            },

                            ///triggers once state selected in dropdown
                            onStateChanged: (value) {
                              setState(() {
                                ///store value in state variable
                                stateValue = value;
                              });
                            },

                            ///triggers once city selected in dropdown
                            onCityChanged: (value) {
                              setState(() {
                                ///store value in city variable
                                cityValue = value;
                              });
                            },
                          ),
                        ],
                      )),
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
            title: Text('Select one options'),
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
                    onPressed: () async {
                      print(this.image);

                      try {
                        if (!_formKey.currentState.validate()) return;
                        _formKey.currentState.save();

                        await widget.deps.api.updatePhoto(
                          this.image,
                        );
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            title: 'the image was saved',
                            text:
                            'The image was saved successfully, the page will reload.',
                            confirmBtnColor: Color(0xff3B2F8F),
                            backgroundColor: Color(0xffF8991C),
                            onConfirmBtnTap: () async {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, '/profileEdit');
                            });
                      } catch (e) {
                        print(widget.deps.api.updatePhoto(this.image));
                        showErrorUIMG(context, e);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showSuccessDialog(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      title: 'Saved information',
      text: 'New information has been saved',
      confirmBtnColor: Color(0xff3B2F8F),
      backgroundColor: Color(0xffF8991C),
    );
  }
  void showErrorDialog(BuildContext context, err) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'No information',
      text: 'No new information to update',
      confirmBtnColor: Color(0xff3B2F8F),
      backgroundColor: Color(0xffF8991C),
    );
  }
  void showErrorUIMG(BuildContext context, e) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'No new image',
      text: 'No new image was selected',
      confirmBtnColor: Color(0xff3B2F8F),
      backgroundColor: Color(0xffF8991C),
    );
  }
}
