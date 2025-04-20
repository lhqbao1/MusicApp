import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_cubit.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_event.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_state.dart';

class UserSongList extends StatefulWidget {
  const UserSongList({super.key});

  @override
  State<UserSongList> createState() => _UserSongListState();
}

class _UserSongListState extends State<UserSongList> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorite songs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 10),
          BlocProvider(
            create:
                (context) =>
                    FavoriteSongCubit()
                      ..add(LoadFavoriteSongsEvent(userUid: userUid)),
            child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
              builder: (context, state) {
                if (state is FavoriteSongErrorState) {
                  return Text(state.error);
                }
                if (state is FavoriteSongLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is FavoriteSongLoadedState) {
                  final listSongs = state.favoriteSongs;
                  if (listSongs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: listSongs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final artist = Uri.encodeComponent(
                          listSongs[index]['artists'],
                        );
                        final title = Uri.encodeComponent(
                          listSongs[index]['title'],
                        );
                        final imageUrl =
                            'https://firebasestorage.googleapis.com/v0/b/spotify-b1d8f.firebasestorage.app/o/covers%2F';
                        final imageSuffix = '.jpg?alt=media';
                        final imageUrlFull =
                            '$imageUrl$artist - $title$imageSuffix';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrlFull,
                                  height: 50,
                                  width: 50,
                                ),
                              ),

                              SizedBox(width: 10),

                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      listSongs[index]['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      listSongs[index]['artists'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  listSongs[index]['duration'].toString(),
                                ),
                              ),

                              Expanded(child: Icon(Icons.more_horiz)),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
                return Center(
                  child: Text(
                    'No favorite song found',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
