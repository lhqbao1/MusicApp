import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/screens/home/bloc/songs/song_cubit.dart';
import 'package:spotify/presentation/screens/home/bloc/songs/songs_event.dart';
import 'package:spotify/presentation/screens/home/bloc/songs/songs_state.dart';
import 'package:spotify/presentation/screens/home/widgets/new_song_tab_card.dart';

final Stream<QuerySnapshot> songStream =
    FirebaseFirestore.instance.collection('songs').snapshots();

class NewSongsTab extends StatefulWidget {
  const NewSongsTab({super.key});

  @override
  State<NewSongsTab> createState() => _NewSongsTabState();
}

class _NewSongsTabState extends State<NewSongsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SongBloc()..add(FetchSongsEvent()),
      child: BlocBuilder<SongBloc, SongState>(
        builder: (context, state) {
          if (state is SongLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SongLoadedState) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                var song = state.songs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: SongCard(
                          artist: song['artists'],
                          song: song['title'],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text("No songs available"));
        },
      ),
    );
  }
}
