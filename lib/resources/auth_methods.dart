import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // SIGN UP USER
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // REGISTER USER
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // STORAGE METHOD
        String photoUrl = await StorageMethods().uploadImageToStorage(
          'ProfilPics',
          file,
          false,
        );

        model.User user = model.User(
          uid: credential.user!.uid,
          username: username,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        // ADD USER TO OUR DATABASE
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        res = 'Your password should be at least 6 characters';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // LOGGING USER
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'There is no user record corresponding to this identifier';
      }
    } catch (err) {
      res = err.toString();
      print('res' + res);
    }
    return res;
  }
}
