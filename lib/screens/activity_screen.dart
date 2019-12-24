import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {

  static final String id = 'activity_screen';

  ActivityScreen({Key key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Activity Screen'),
      ),
    );
  }
}