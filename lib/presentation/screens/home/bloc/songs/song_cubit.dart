import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/screens/home/bloc/songs/songs_event.dart';
import 'package:spotify/presentation/screens/home/bloc/songs/songs_state.dart';

class SongBloc extends Bloc<SongsEvent, SongState> {
  SongBloc() : super(SongInitialState()) {
    on<FetchSongsEvent>((event, emit) async {
      emit(SongLoadingState()); // Phát trạng thái loading
      try {
        //Get songs data from firestore
        final QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('songs').get();

        List<Map<String, dynamic>> songs =
            snapshot.docs.map((item) {
              return {
                'title': item['title'],
                'artists': item['artists'],
                'duration': item['duration'],
                'releaseDate': item['releaseDate'],
              };
            }).toList();

        emit(SongLoadedState(songs: songs));
      } catch (e) {
        emit(SongErrorState(error: e.toString()));
      }
    });
  }
}
