import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postUrl;
  final String username;
  final String postId;
  final datePublished;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postUrl,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'description': description,
        'postUrl': postUrl,
        'postId': postId,
        'datePublished': datePublished,
        'profImage': profImage,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot['uid'],
      username: snapshot['username'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['datePublished'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['snapshot'],
    );
  }
}
