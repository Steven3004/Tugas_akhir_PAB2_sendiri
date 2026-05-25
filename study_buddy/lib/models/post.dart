// lib/models/post.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;

  String? title;
  String? description;

  String? image;

  String? category;

  String? userId;
  String? userFullName;
  String? userProfilePic;

  double? latitude;
  double? longitude;

  bool isFavorite;

  int likesCount;
  int commentsCount;

  DateTime? createdAt;

  Post({
    this.id,
    this.title,
    this.description,
    this.image,
    this.category,
    this.userId,
    this.userFullName,
    this.userProfilePic,
    this.latitude,
    this.longitude,
    this.isFavorite = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.createdAt,
  });

  // ================= TO MAP =================
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,

      'image': image,

      'category': category,

      'userId': userId,
      'userFullName': userFullName,
      'userProfilePic': userProfilePic,

      'latitude': latitude,
      'longitude': longitude,

      'isFavorite': isFavorite,

      'likesCount': likesCount,
      'commentsCount': commentsCount,

      'createdAt':
          createdAt != null
              ? Timestamp.fromDate(createdAt!)
              : FieldValue.serverTimestamp(),
    };
  }

  // ================= FROM FIRESTORE =================
  factory Post.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;

    return Post(
      id: doc.id,

      title:
          data['title'] != null
              ? data['title'].toString()
              : '',

      description:
          data['description'] != null
              ? data['description'].toString()
              : '',

      image:
          data['image'] != null
              ? data['image'].toString()
              : '',

      category:
          data['category'] != null
              ? data['category'].toString()
              : '',

      userId:
          data['userId'] != null
              ? data['userId'].toString()
              : '',

      userFullName:
          data['userFullName'] != null
              ? data['userFullName'].toString()
              : 'Unknown User',

      userProfilePic:
          data['userProfilePic'] != null
              ? data['userProfilePic'].toString()
              : '',

      latitude:
          data['latitude'] != null
              ? (data['latitude'] as num)
                  .toDouble()
              : null,

      longitude:
          data['longitude'] != null
              ? (data['longitude'] as num)
                  .toDouble()
              : null,

      isFavorite:
          data['isFavorite'] ?? false,

      likesCount:
          data['likesCount'] ?? 0,

      commentsCount:
          data['commentsCount'] ?? 0,

      createdAt:
          (data['createdAt']
                  as Timestamp?)
              ?.toDate(),
    );
  }
}