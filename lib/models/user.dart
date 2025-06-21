import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  //final String photoUrl;
  final String username;
  final String uid;
  final String? rating;
  final String? review;


  const User({
    required this.username,
    required this.email,
    //required this.photoUrl,
    required this.uid,
    this.rating,
    this.review,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'rating':rating,
        'review':review
        //'photoUrl': photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      email: snapshot['email'],
      //photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      review: snapshot['review'],
      rating: snapshot['rating'],
    );
  }

  User copyWithLocation(double lat, double lng) {
    return User(
      username: username,
      email: email,
      //photoUrl: photoUrl,
      uid: uid,
      rating:rating,
      review:review,
    );
  }
}