import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/src/models/user.dart' as model;
import 'package:instagram_flutter/src/resources/storage.dart';

class AuthMethods {

  static const String invalidEmail = 'INVALID_LOGIN_CREDENTIALS';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';

  static const String weakPassword = 'weak-password';
  static const String incorrectEmailFormatError = 'The email is badly formatted';
  static const String incorrectPasswordError = 'Password should be at least 6 characters long';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Storage _storage = Storage();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnapshot(snapshot);
  }

  // sign up
  Future<String> signupUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    Uint8List? file
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty || bio.isNotEmpty) {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        String photoUrl = await _storage.uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(uid: userCredential.user!.uid, email: email, photoUrl: photoUrl, username: userName, bio: bio);
        await _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());
        res = 'Success';
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == invalidEmail) {
        res = incorrectEmailFormatError;
      }
      if (err.code == weakPassword) {
        res = incorrectPasswordError;
      }
    }
    catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({ required String email, required String password }) async {
    String res = 'Some error Occurred';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'Success';
    } on FirebaseAuthException catch (err) {
      print(err.code);
      if (err.code == invalidEmail) {
        res = 'Email is invalid';
      }
      if (err.code == userDisabled) {
        res = 'User with email [$email] is not active';
      }
      if (err.code == userNotFound) {
        res = 'User with provided credential cannot be found';
      }
      if (err.code == wrongPassword) {
        res = 'The provided password is incorrect';
      }
    } catch(err) {
      print(err.runtimeType);
      res = err.toString();
    }
    return res;
  }
}