import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_email);
      print(_password);

      // User login
      AuthService.loginUser(_email, _password);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Instagram',
                  style: TextStyle(fontSize: 50.0, fontFamily: 'Billabong')),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) => !value.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (value) => _email = value,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) => value.length < 6
                            ? 'The password must be at least 6 characters'
                            : null,
                        onSaved: (value) => _password = value,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submitForm,
                        color: Colors.blue,
                        padding: EdgeInsets.all(10.0),
                        child: Text('Login',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, SignUpScreen.id),
                        color: Colors.blue,
                        padding: EdgeInsets.all(10.0),
                        child: Text('Go To Sign Up',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.0)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
