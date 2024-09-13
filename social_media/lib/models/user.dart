import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String bio;
  final String image;
  final List following;
  final List followers;
  final String uid;

  const User(
      {required this.email,
      required this.bio,
      required this.followers,
      required this.following,
      required this.image,
      required this.uid,
      required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'image': image,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return User(
        email: snapshot['email'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        image: snapshot['image'],
        uid: snapshot['uid'],
        username: snapshot['username']);
  }
}
