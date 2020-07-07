import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email; // 이메일
  final String id; // 아이디
  final String photoUrl; // 프로필 사진
  final String username; // 닉네임
  final String displayName; // ?
  final String bio; // ?
//  final Map followers;
//  final Map following;

  const User({
    this.username,
    this.id,
    this.photoUrl,
    this.email,
    this.displayName,
    this.bio,
    //        this.followers,
    //        this.following
  });

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document.documentID,
      displayName: document['displayName'],
      bio: document['bio'],
//      followers: document['followers'],
//      following: document['following'],
    );
  }
}
