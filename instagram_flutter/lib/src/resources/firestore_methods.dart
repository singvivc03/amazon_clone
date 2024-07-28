import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/src/models/posts.dart';
import 'package:instagram_flutter/src/resources/storage.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Storage _storage = Storage();

  Future<String> uploadPost(String description, Uint8List file, String uid, String username, final String profileImage) async {
    String result = 'some error occurred';
    try {
      String photoUrl = await _storage.uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Posts post = Posts(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      result = "success";
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<void> upVote(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
       await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(final String postId, final String text, final String uid, final String name, final String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(final String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (err) {
      throw Exception(err);
    }
  }
}