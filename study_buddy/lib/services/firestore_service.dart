import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    'posts',
  );

  Future<void> addPost(
    String userId,
    String title,
    String content,
    String category,
  ) {
    return posts.add({
      'userId': userId,
      'title': title,
      'content': content,
      'category': category,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deletePost(String id) {
    return posts.doc(id).delete();
  }
}
