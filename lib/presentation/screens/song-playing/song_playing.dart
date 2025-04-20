import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_cubit.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_event.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_state.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/song-playing/song_playing_cubit.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/song-playing/song_playing_event.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/song-playing/song_playing_state.dart';

class SongPlayingScreen extends StatefulWidget {
  const SongPlayingScreen({super.key, required this.songs});

  final QueryDocumentSnapshot<Object?> songs;

  @override
  State<SongPlayingScreen> createState() => _SongPlayingScreenState();
}

class _SongPlayingScreenState extends State<SongPlayingScreen> {
  final String firebaseUrl =
      'https://firebasestorage.googleapis.com/v0/b/spotify-b1d8f.firebasestorage.app/o/covers%2F';

  final String songFirebaseUrl =
      'https://firebasestorage.googleapis.com/v0/b/spotify-b1d8f.firebasestorage.app/o/songs%2F';

  final String imgFormat = '.jpg?alt=media';
  final String songFormat = '.mp3?alt=media';
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Now Playing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create:
            (context) =>
                SongPlayingBloc()..add(
                  LoadSongEvent(
                    '$songFirebaseUrl${Uri.encodeComponent(widget.songs['artists'])} - ${Uri.encodeComponent(widget.songs['title'])}$songFormat',
                  ),
                ),

        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userUid)
                  .collection('favorites')
                  .doc(widget.songs['songId'])
                  .snapshots(),
          builder: (context, snapshot) {
            bool isFavorite = false;
            if (snapshot.hasData && snapshot.data!.exists) {
              isFavorite = true;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            '$firebaseUrl${Uri.encodeComponent(widget.songs['artists'])} - ${Uri.encodeComponent(widget.songs['title'])}$imgFormat',
                            scale: 1,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    BlocProvider(
                      create: (context) {
                        final userUid = FirebaseAuth.instance.currentUser;
                        return FavoriteSongCubit()..add(
                          CheckFavoriteSongStatusEvent(
                            songId: widget.songs['songId'],
                            userUid: userUid!.uid,
                          ),
                        );
                      },
                      child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
                        builder: (context, state) {
                          if (state is FavoriteSongErrorState) {
                            return const Text('Something went wrong');
                          }

                          // if (state is FavoriteSongCheckStatusState) {
                          //   isFavorite = state.isFavorite;
                          // }

                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    widget.songs['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    widget.songs['artists'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  final userUid =
                                      FirebaseAuth.instance.currentUser;

                                  context.read<FavoriteSongCubit>().add(
                                    ToggleCreateFavoriteSongEvent(
                                      userUid: userUid!.uid,
                                      songId: widget.songs['songId'],
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.favorite,
                                    color:
                                        isFavorite == true
                                            ? AppColors.primary
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    songPlayer(),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        playAgainButton(),
                        SizedBox(width: 30),
                        Row(
                          children: [
                            Icon(Icons.skip_previous),
                            SizedBox(width: 20),

                            playPauseButton(),
                            SizedBox(width: 20),

                            Icon(Icons.skip_next),
                          ],
                        ),
                        SizedBox(width: 30),

                        Icon(Icons.shuffle),
                      ],
                    ),

                    // playPauseButton(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget songPlayer() {
    return BlocBuilder<SongPlayingBloc, SongPlayingState>(
      builder: (context, state) {
        if (state is SongPlayingLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SongPlayingLoadedState) {
          return Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2.0,
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Colors.black,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                ),
                child: Slider(
                  value: state.position.inSeconds.toDouble(),
                  min: 0.0,
                  max: state.duration.inSeconds.toDouble(),
                  onChanged: (value) {},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(formatTime(state.position)),
                  Text(formatTime(state.duration)),
                ],
              ),
            ],
          );
        } else if (state is SongPlayingErrorState) {
          return Center(child: Text("Error: ${state.error}"));
        }
        ;
        return Text('asdasd');
      },
    );
  }

  Widget playPauseButton() {
    return BlocBuilder<SongPlayingBloc, SongPlayingState>(
      builder: (context, state) {
        if (state is SongPlayingLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is SongPlayingLoadedState) {
          return GestureDetector(
            onTap: () {
              context.read<SongPlayingBloc>().togglePlayPause();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                state.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow, // Change icon dynamically
                color: Colors.white,
              ),
            ),
          );
        } else if (state is SongPlayingErrorState) {
          return Center(child: Text("Error: ${state.error}"));
        }
        return Center(child: Text("No song loaded"));
      },
    );
  }

  Widget playAgainButton() {
    return BlocBuilder<SongPlayingBloc, SongPlayingState>(
      builder: (context, state) {
        if (state is SongPlayingLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is SongPlayingLoadedState) {
          return GestureDetector(
            onTap: () {
              context.read<SongPlayingBloc>().togglePlayAgain();
            },
            child: Icon(Icons.replay),
          );
        }
        return Container();
      },
    );
  }

  formatTime(Duration duration) {
    if (duration.inSeconds < 60) {
      if (duration.inSeconds < 10) {
        return '0:0${duration.inSeconds.toString()}';
      }
      return '0:${duration.inSeconds.toString()}';
    }
    if (duration.inSeconds > 60) {
      var minutes = duration.inMinutes;
      var seconds = duration.inSeconds - duration.inMinutes * 60;
      if (duration.inSeconds < 10) {
        return '$minutes:0$seconds';
      }
      return '$minutes:$seconds';
    }
  }
}
