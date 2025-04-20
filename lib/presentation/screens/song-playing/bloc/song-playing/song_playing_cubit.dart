import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'song_playing_event.dart';
import 'song_playing_state.dart';

class SongPlayingBloc extends Bloc<SongPlayingEvent, SongPlayingState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  SongPlayingBloc() : super(SongPlayingInitialState()) {
    on<LoadSongEvent>((context, emit) async {
      emit(SongPlayingLoadingState());
      try {
        await _audioPlayer.setUrl(context.url);

        final duration = await _audioPlayer.durationFuture ?? Duration.zero;
        if (duration == Duration.zero) {
          throw Exception("Failed to retrieve duration from the audio URL.");
        }
        emit(
          SongPlayingLoadedState(
            duration: duration,
            position: Duration.zero,
            isPlaying: true,
          ),
        );

        await _audioPlayer.play();
      } catch (e) {
        SongPlayingErrorState(error: e.toString());
      }
    });
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<TogglePlayAgainEvent>(_onTogglePlayAgain);

    // Set up listeners
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (state is SongPlayingLoadedState) {
        emit(
          SongPlayingLoadedState(
            duration: (state as SongPlayingLoadedState).duration,
            position: position,
            isPlaying: _audioPlayer.playing,
          ),
        );
      }
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null && state is SongPlayingLoadedState) {
        emit(
          SongPlayingLoadedState(
            duration: duration,
            position: (state as SongPlayingLoadedState).position,
            isPlaying: _audioPlayer.playing,
          ),
        );
      }
    });

    // Listen for playback state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // Restart the song automatically
        _audioPlayer.seek(Duration.zero); // Go back to the start
        _audioPlayer.play(); // Play the song again

        emit(
          SongPlayingLoadedState(
            duration: (state as SongPlayingLoadedState).duration,
            position: Duration.zero,
            isPlaying: _audioPlayer.playing,
          ),
        );
      }
    });
  }

  Future<void> _onTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<SongPlayingState> emit,
  ) async {
    if (state is SongPlayingLoadedState) {
      final currentState = state as SongPlayingLoadedState;

      // Check if the song is complete
      if (currentState.position >= currentState.duration) {
        // Song is finished, restart it
        await _audioPlayer.seek(
          Duration.zero,
        ); // Restart the song from the beginning
        await _audioPlayer.play(); // Play the song again
      } else {
        // Toggle play/pause
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play();
        }
      }

      // Emit the updated state; this will be updated by the position stream listener
      emit(
        SongPlayingLoadedState(
          duration: currentState.duration,
          position: currentState.position,
          isPlaying: _audioPlayer.playing,
        ),
      );
    }
  }

  Future<void> _onTogglePlayAgain(
    TogglePlayAgainEvent event,
    Emitter<SongPlayingState> emit,
  ) async {
    try {
      if (state is SongPlayingLoadedState) {
        final currentState = state as SongPlayingLoadedState;

        await _audioPlayer.seek(Duration.zero);

        emit(
          SongPlayingLoadedState(
            duration: currentState.duration,
            position: Duration.zero,
            isPlaying: true,
          ),
        );
      }
    } catch (e) {
      emit(SongPlayingErrorState(error: e.toString()));
    }
  }

  // Convenience methods for UI
  void loadSong(String url) {
    add(LoadSongEvent(url));
  }

  void togglePlayPause() {
    add(TogglePlayPauseEvent());
  }

  void togglePlayAgain() {
    add(TogglePlayAgainEvent());
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
