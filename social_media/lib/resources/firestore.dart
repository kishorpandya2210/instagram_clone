import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media/models/posts.dart';
import 'package:social_media/resources/storage.dart';
import 'package:uuid/uuid.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String postId = const Uuid().v1();

  // upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = 'Some error occured';
    try {
      String photoUrl = await Storage().uploadImage('posts', file, true);
      Posts post = Posts(
        description: description,
        username: username,
        uid: uid,
        postId: postId,
        image: photoUrl,
        datePublished: DateTime.now(),
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> postComment(
      String postId, String text, String uid, String name, String image) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'image': image,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'Success';
      } else {
        res = 'Please enter text';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // delete post
  Future<String> deletePost(String postId, String uid, String posterId) async {
    String res = 'Some error occured';
    try {
      if (uid == posterId) {
        await _firestore.collection('posts').doc(postId).delete();
        res = 'Success';
      } else {
        res = 'Can only delete your post.';
      }
    } catch (err) {
      res = err.toString();
      print(err.toString());
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
