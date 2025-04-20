import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_event.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_state.dart';

class FavoriteSongCubit extends Bloc<FavoriteSongEvent, FavoriteSongState> {
  FavoriteSongCubit() : super(FavoriteSongInitialState()) {
    on<ToggleCreateFavoriteSongEvent>(_onToggleCreateFavoriteSong);
    on<LoadFavoriteSongsEvent>(_onLoadFavoriteSongs);
    on<CheckFavoriteSongStatusEvent>(_onCheckFavoriteStatus);
  }

  Future<void> _onToggleCreateFavoriteSong(
    ToggleCreateFavoriteSongEvent event,
    Emitter<FavoriteSongState> emit,
  ) async {
    try {
      emit(FavoriteSongLoadingState());

      final songDoc =
          await FirebaseFirestore.instance
              .collection('songs')
              .doc(event.songId)
              .get();

      if (!songDoc.exists) {
        emit(FavoriteSongErrorState(error: "Song not found."));
        return;
      }

      final songData = songDoc.data();
      if (songData == null) {
        emit(FavoriteSongErrorState(error: "Invalid song data."));
        return;
      }

      // Check if the song is already in user's favorites
      final favRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.userUid)
          .collection('favorites')
          .doc(event.songId);

      final favDoc = await favRef.get();

      if (!favDoc.exists) {
        // Add to favorites
        await favRef.set({
          'title': songData['title'],
          'artists': songData['artists'],
          'duration': songData['duration'],
          'addedAt': FieldValue.serverTimestamp(),
        });
        emit(FavoritesSongCreatedState());
      } else {
        // Remove from favorites
        await favRef.delete();
        emit(FavoritesSongRemovedState());
      }
    } catch (e) {
      emit(FavoriteSongErrorState(error: e.toString()));
    }
  }

  Future<void> _onLoadFavoriteSongs(
    LoadFavoriteSongsEvent event,
    Emitter<FavoriteSongState> emit,
  ) async {
    try {
      emit(FavoriteSongLoadingState());
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(event.userUid)
              .collection('favorites')
              .get();
      final listFavoriteSongs = snapshot.docs.map((e) => e.data()).toList();
      emit(FavoriteSongLoadedState(favoriteSongs: listFavoriteSongs));
    } catch (error) {
      emit(FavoriteSongErrorState(error: error.toString()));
    }
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteSongStatusEvent event,
    Emitter<FavoriteSongState> emit,
  ) async {
    try {
      emit(FavoriteSongLoadingState());

      final songDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(event.userUid)
              .collection('favorites')
              .doc(event.songId)
              .get();

      emit(FavoriteSongCheckStatusState(isFavorite: songDoc.exists));
    } catch (e) {
      emit(FavoriteSongErrorState(error: e.toString()));
    }
  }
}
