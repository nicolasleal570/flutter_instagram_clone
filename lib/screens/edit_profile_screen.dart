import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/database_service.dart';

class EditProfileScreen extends StatefulWidget {
  static final String id = 'edit_profile_screen';

  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';

  @override
  void initState() { 
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  void _submit(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Update user in database 

      String _profileImgUrl = '';

      User user = User(
        id: widget.user.id,
        name: _name,
        bio: _bio,
        profileImgUrl: _profileImgUrl
      );

      // Update database
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(
                          'https://img.pngio.com/png-avatar-108-images-in-collection-page-3-png-avatar-300_300.png',
                          scale: 1.0),
                    ),
                    FlatButton(
                      onPressed: () => print('Change profile img'),
                      child: Text(
                        'Change profile image',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        labelText: 'Name',
                      ),
                      validator: (value) => value.trim().length < 1
                          ? 'Please enter a valid name'
                          : null,
                          onSaved: (value) => _name = value,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30.0,
                        ),
                        labelText: 'Biography',
                      ),
                      validator: (value) => value.trim().length > 150
                          ? 'Please enter a bio less than 150 characters'
                          : null,
                          onSaved: (value) => _bio = value,
                    ),
                    Container(height: 40.0, width: 250.0,
                    margin: EdgeInsets.all(30.0),
                    child: FlatButton(
                      onPressed: _submit,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text('Save Profile', style: TextStyle(fontSize: 18.0),),
                    ),),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
