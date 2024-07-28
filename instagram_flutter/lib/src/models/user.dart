import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String uid;
  final String email;
  final String photoUrl;
  final String username;
  final String bio;

  const User({required this.uid, required this.email, required this.photoUrl, required this.username,
              required this.bio});

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "photoUrl": photoUrl,
    "bio": bio
  };

  static User fromSnapshot(final DocumentSnapshot snapshot) {
    Map<String, dynamic> userDetail = snapshot.data() as Map<String, dynamic>;
    return User(
        bio: userDetail['bio'],
        uid: userDetail['uid'],
        email: userDetail['email'],
        photoUrl: userDetail['photoUrl'],
        username: userDetail['username']
    );
  }
}