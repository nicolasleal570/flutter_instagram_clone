import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileImgUrl;
  final String bio;

  User({this.id, this.name, this.email, this.profileImgUrl, this.bio});

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      email: doc['email'],
      profileImgUrl: doc['profileImgUrl'],
      bio: doc['bio'] ?? '',
    );
  }
}
