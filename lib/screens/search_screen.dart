import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {

  static final String id = 'search_screen';

  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Search Screen'),
      ),
    );
  }
}