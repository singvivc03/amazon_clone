import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Storage {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(final String childName, final Uint8List? file, final bool isPost) async {
    if (file != null) {
      Reference reference = _firebaseStorage.ref().child(childName).child(
          _firebaseAuth.currentUser!.uid);
      if (isPost) {
        String id = const Uuid().v1();
        reference = reference.child(id);
      }
      UploadTask uploadTask = reference.putData(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      return await taskSnapshot.ref.getDownloadURL();
    }
    return "";
  }
}