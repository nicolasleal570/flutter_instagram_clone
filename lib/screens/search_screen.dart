import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  static final String id = 'search_screen';

  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search...',
              prefixIcon: Icon(
                Icons.search,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30.0,
                  ),
                  onPressed: () => _clearSearch()),
              filled: true),
          onSubmitted: (value) {
            print('Value: $value');
            if (value.isNotEmpty) {
              setState(() {
                _users = DatabaseService.searchUsers(value);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? Center(
              child: Text('Search For a User'),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.data.documents.length == 0) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Text('No Users Found. Try Again.'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = User.fromDoc(snapshot.data.documents[index]);
                    return _buildUserTile(user);
                  },
                );
              },
            ),
    );
  }

  Widget _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: user.profileImgUrl.isEmpty
            ? AssetImage('assets/images/avatar.png')
            : CachedNetworkImageProvider(user.profileImgUrl),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileScreen(
                    uid: user.id,
                  ))),
      title: Text(user.name),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }
}
