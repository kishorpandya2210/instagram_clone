import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String username;
  final String uid;
  final String postId;
  final String image;
  final DateTime datePublished;
  final String profileImage;
  final likes;

  const Posts({
    required this.description,
    required this.username,
    required this.uid,
    required this.postId,
    required this.image,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'uid': uid,
        'postId': postId,
        'image': image,
        'datePublished': datePublished,
        'profileImage': profileImage,
        'likes': likes,
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return Posts(
      description: snapshot['description'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      image: snapshot['image'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
