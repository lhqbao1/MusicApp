// song_playing_event.dart
abstract class SongPlayingEvent {}

class LoadSongEvent extends SongPlayingEvent {
  final String url;
  LoadSongEvent(this.url);
}

class TogglePlayPauseEvent extends SongPlayingEvent {}

class TogglePlayAgainEvent extends SongPlayingEvent {}

class PlaySongEvent extends SongPlayingEvent {}

class PauseSongEvent extends SongPlayingEvent {}

class SeekSongEvent extends SongPlayingEvent {
  final Duration position;
  SeekSongEvent(this.position);
}
