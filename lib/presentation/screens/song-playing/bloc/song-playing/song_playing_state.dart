// song_playing_state.dart
abstract class SongPlayingState {}

class SongPlayingInitialState extends SongPlayingState {}

class SongPlayingLoadingState extends SongPlayingState {}

class SongPlayingLoadedState extends SongPlayingState {
  final Duration duration;
  final Duration position;
  final bool isPlaying;

  SongPlayingLoadedState({
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.isPlaying = false,
  });
}

class SongPlayingErrorState extends SongPlayingState {
  final String error;
  SongPlayingErrorState({required this.error});
}
