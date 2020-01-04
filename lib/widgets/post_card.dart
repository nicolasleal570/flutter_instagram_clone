import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class PostCard extends StatelessWidget {

  final String currentUserId;
  final Post post;
  final User author;

  PostCard({
    this.currentUserId,
    this.post,
    this.author
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId: currentUserId,
                        uid: post.authorId,
                      ))),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileImgUrl.isEmpty
                      ? AssetImage('assets/images/avatar.png')
                      : CachedNetworkImageProvider(author.profileImgUrl),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  author.name,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(post.imageUrl),
                  fit: BoxFit.cover)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '0 Likes',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 4.0),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12.0, right: 6.0),
                    child: Text(
                      author.name,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      post.caption,
                      style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 12.0,
        )
      ],
    );
  }
}