import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class FirestoreService {
  // ================= FIREBASE INSTANCE =================
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= COLLECTION =================
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // ================= ADD POST =================
  // FIXED: Removed the broken, duplicate String parameters
  Future<void> addPost(Post post) async {
    await postsCollection.add(post.toMap());
  }

  // ================= GET POSTS =================
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

  // ================= DELETE POST =================
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  // ================= UPDATE POST =================
  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await postsCollection.doc(postId).update(data);
  }

  // ================= TOGGLE FAVORITE =================
  Future<void> toggleFavorite(String postId, bool currentValue) async {
    await postsCollection.doc(postId).update({
      'isFavorite': !currentValue,
    });
  }

  // ================= GET FAVORITES =================
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

  // ================= ADD COMMENT =================
  Future<void> addComment(String postId, String userName, String comment) async {
    await postsCollection.doc(postId).collection('comments').add({
      'userName': userName,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // update comment count
    await postsCollection.doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  // ================= GET COMMENTS =================
  Stream<QuerySnapshot> getComments(String postId) {
    return postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ================= GET USER POSTS =================
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