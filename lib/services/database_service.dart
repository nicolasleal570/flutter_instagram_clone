import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/utilities/constans.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImgUrl': user.profileImgUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();

    return users;
  }

  static void createPost(Post post) {
    postsRef.document(post.authorId).collection('usersPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likes': post.likes,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    }).then((onValue) {
      print('Creating post');
    });
  }

  static void followUser({String currentUserId, String userId}) {
    // Add user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    // Add current users to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // Remove user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Remove current users to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return followingDoc.exists;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();

    return followersSnapshot.documents.length;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();

    return followingSnapshot.documents.length;
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts =
        feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();

    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userSnapshot = await usersRef.document(userId).get();

    if (userSnapshot.exists) {
      return User.fromDoc(userSnapshot);
    }

    return User();
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .document(userId)
        .collection('usersPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        userPostsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }
}
