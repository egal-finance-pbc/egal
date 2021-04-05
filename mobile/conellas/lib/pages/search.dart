import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Container(
      child: AppBar(
        title: Text('Who should we pay?'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
    );
  }

  Widget _fieldContainer() {
    return Container(
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
    var err = APIError();
    const padding = EdgeInsets.fromLTRB(20, 15, 20, 0);
    return FutureBuilder(
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
            child: err.content(),
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
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/send', arguments: item);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          this._headerContainer(),
          this._fieldContainer(),
          this._resultsContainer(),
        ],
      ),
    );
  }
}
