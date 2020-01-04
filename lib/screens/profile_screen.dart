import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/utilities/constans.dart';
import 'package:instagram_clone/widgets/post_card.dart';
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
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  User _profileUser;

  @override
  void initState() {
    super.initState();

    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
    _setupPosts();
    _setupProfileUser();
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
                _buildProfileInfo(user),
                _buildToggleButtons(),
                Divider(),
                _buildDisplayPosts()
              ],
            );
          }),
    );
  }

  _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
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
                              _posts.length.toString(),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
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
                              _followerCount.toString(),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
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
                              _followingCount.toString(),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
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
                    _displayButton(user)
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${user.name}',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        ),
      ],
    );
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: Image(
        image: CachedNetworkImageProvider(post.imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      List<GridTile> tiles = [];
      _posts.forEach((post) => tiles.add(_buildTilePost(post)));

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      List<PostCard> posts = [];
      _posts.forEach((post) {
        posts.add(PostCard(
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });

      return Column(children: posts);
    }
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId, userId: widget.uid);

    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowersCount = await DatabaseService.numFollowers(widget.uid);

    print('Followers $userFollowersCount');

    setState(() {
      _followerCount = userFollowersCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.uid);

    print('Following $userFollowingCount');

    setState(() {
      _followingCount = userFollowingCount;
    });
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
                _isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                    fontSize: 18.0,
                    color: _isFollowing ? Colors.black : Colors.white),
              ),
              color: _isFollowing ? Colors.grey[200] : Colors.blue,
            ),
          );
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.uid);

    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
        currentUserId: widget.currentUserId, userId: widget.uid);

    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.uid);
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.uid);
    setState(() {
      _profileUser = profileUser;
    });
  }
}
