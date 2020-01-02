import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/utilities/constans.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = 'profile_screen';

  final String uid;

  ProfileScreen({this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Instagram',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Billabong', fontSize: 35.0)),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: usersRef.document(widget.uid).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            User user = User.fromDoc(snapshot.data);

            return ListView(
              children: <Widget>[
                // Profile Header
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: user.profileImgUrl.isEmpty
                              ? AssetImage('assets/images/avatar.png')
                              : CachedNetworkImageProvider(user.profileImgUrl,
                                  scale: 1.0)),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '12',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '345',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '369',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 200.0,
                              child: FlatButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EditProfileScreen(
                                              user: user,
                                            ))),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${user.name}',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      Container(
                          child: Text(
                        '${user.email}',
                        style: TextStyle(fontSize: 15.0),
                      )),
                      SizedBox(height: 5.0),
                      Container(
                          height: 80.0,
                          child: Text(
                            '${user.bio}',
                            style: TextStyle(fontSize: 15.0),
                          )),
                      Divider()
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
