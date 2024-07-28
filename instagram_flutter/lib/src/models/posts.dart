import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {

  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final List<int> likes;

  const Posts({required this.description, required this.uid, required this.username, required this.postId, required this.datePublished,
               required this.postUrl, required this.profileImage, required this.likes});

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    "postUrl": postUrl,
    "likes": likes,
    "profileImage": profileImage
  };

  static Posts fromSnapshot(DocumentSnapshot snapshot) {
    var postDetail = snapshot.data() as Map<String, dynamic>;
    return Posts(
      description: postDetail['description'],
      uid: postDetail['uid'],
      username: postDetail['username'],
      postId: postDetail['postId'],
      datePublished: postDetail['datePublished'],
      postUrl: postDetail['postUrl'],
      profileImage: postDetail['profileImage'],
      likes: postDetail['likes'],
    );
  }
}