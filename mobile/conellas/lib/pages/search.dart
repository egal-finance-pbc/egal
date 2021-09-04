import 'package:conellas/pages/send.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/deps.dart';
import '../clients/api.dart';

class SearchPage extends StatefulWidget {
  final Dependencies deps;

  SearchPage(this.deps, {Key key}) : super(key: key);

  @override
  _SearchPageState createState() {
    return new _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final _inputCtrl = TextEditingController();
  Future<List<User>> _usersFuture;

  void _search() async {
    setState(() {
      _usersFuture = widget.deps.api.search(
        _inputCtrl.text.trim(),
      );
    });
  }

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

  Widget _fieldContainer() {
    Size size = MediaQuery.of(context).size;

  return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.0, 0, 0),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
        child: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          controller: _inputCtrl,
          onSubmitted: (_) {
            _search();
          },
        ),
      ),
    );
  }

  Widget _resultsContainer() {
    Size size = MediaQuery.of(context).size;
    const padding = EdgeInsets.fromLTRB(20, 15, 20, 0);
    return Container(
      margin: EdgeInsets.fromLTRB(0, size.height * 0.08, 0, 0),
      child: FutureBuilder(
        future: _usersFuture,
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            // Search operation has not started yet
            return Padding(
              padding: padding,
              child: Text('Type at least 3 letters and press enter'),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            // Search operation is waiting or active
            return Padding(
              padding: padding,
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: padding,
              child: Text('${snapshot.error}'),
            );
          }
          if (snapshot.data.isEmpty) {
            return Padding(
              padding: padding,
              child: Text('No users found'),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            separatorBuilder: (_, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              final item = snapshot.data[index];
              return TextButton(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Text(
                          '${item.fullName()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,

                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          '@${item.username}',
                          style: TextStyle(
                            color: Color(0xffF8991C),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SendPage(widget.deps),settings:  RouteSettings(arguments: item)));
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar:  AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
        title: Name(widget.deps),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(IconData(0xe57f, fontFamily: 'MaterialIcons')))
        ],
      ),
      body: Stack(
        children: [
          this._headerContainer(),
          this._fieldContainer(),
          this._resultsContainer(),
        ],
      ),
    );
  }
}
class Name extends StatefulWidget {
  final Dependencies deps;

  const Name(this.deps, {Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Name> {
  @override
  Widget build(BuildContext context) {
    var futureMe = widget.deps.api.me();
    return FutureBuilder<Me>(
      future: futureMe,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('${snapshot.data.username}');
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
