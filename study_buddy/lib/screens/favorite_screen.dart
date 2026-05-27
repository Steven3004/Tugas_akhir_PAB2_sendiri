import 'package:flutter/material.dart';
import '../widgets/post_list_item.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../widgets/post_list_item.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {

  const FavoriteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final FirestoreService
        firestoreService =
            FirestoreService();

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Favorite Posts',
        ),
      ),

      body:
          StreamBuilder<List<Post>>(

        stream:
            firestoreService
                .getFavoritePosts(),

        builder: (
          context,
          snapshot,
        ) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(

              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(

              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }
          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {

            return const Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Text(

                    'Belum ada favorite post',

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          final posts =
              snapshot.data!;

          return ListView.builder(

            padding:
                const EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),

            itemCount:
                posts.length,

            itemBuilder: (
              context,
              index,
            ) {

              final post =
                  posts[index];

              return PostListItem(

                post: post,

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          DetailScreen(
                        post: post,
                      ),
                    ),
                  );
                },

                onFavorite: () async {

                  await firestoreService
                      .toggleFavorite(

                    post.id!,
                    post.isFavorite,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}