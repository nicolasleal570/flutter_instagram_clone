import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/utilities/constans.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = 'profile_screen';

  final String uid;
  final String currentUserId;

  ProfileScreen({this.uid, this.currentUserId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();

    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId, userId: widget.uid);

    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowersCount = await DatabaseService.numFollowers(widget.uid);

    print('Followers $userFollowersCount');

    setState(() {
      followerCount = userFollowersCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.uid);

    print('Following $userFollowingCount');

    setState(() {
      followingCount = userFollowingCount;
    });
  }

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
                                      followerCount.toString(),
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
                                      followingCount.toString(),
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
                            _displayButton(user),
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

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
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
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              color: Colors.blue,
            ),
          )
        : Container(
            width: 200.0,
            child: FlatButton(
              onPressed: _followOrUnfollow,
              child: Text(
                isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                    fontSize: 18.0,
                    color: isFollowing ? Colors.black : Colors.white),
              ),
              color: isFollowing ? Colors.grey[200] : Colors.blue,
            ),
          );
  }

  _followOrUnfollow() {
    if (isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  void _unfollowUser() {
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.uid);

    setState(() {
      isFollowing = false;
      followerCount--;
    });
  }

  void _followUser() {
    DatabaseService.followUser(
        currentUserId: widget.currentUserId, userId: widget.uid);

    setState(() {
      isFollowing = true;
      followerCount++;
    });
  }
}
