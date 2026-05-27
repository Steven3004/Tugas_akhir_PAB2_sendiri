import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(Post post) async {
    await postsCollection.add(post.toMap());
  }

  Stream<List<Post>> getPosts() {
    return postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await postsCollection.doc(postId).update(data);
  }

  Future<void> toggleFavorite(String postId, bool currentValue) async {
    await postsCollection.doc(postId).update({
      'isFavorite': !currentValue,
    });
  }

  Stream<List<Post>> getFavoritePosts() {
    return postsCollection
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addComment(String postId, String userName, String comment) async {
    await postsCollection.doc(postId).collection('comments').add({
      'userName': userName,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await postsCollection.doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<List<Post>> getUserPosts(String userId) {
    return postsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();
    });
  }
}