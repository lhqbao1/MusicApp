import 'package:equatable/equatable.dart';

abstract class FavoriteSongEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleCreateFavoriteSongEvent extends FavoriteSongEvent {
  final String userUid; // Add the user UID field
  final String songId;

  ToggleCreateFavoriteSongEvent({required this.userUid, required this.songId});

  @override
  List<Object?> get props => [userUid, songId];
}

class LoadFavoriteSongsEvent extends FavoriteSongEvent {
  final String userUid;

  LoadFavoriteSongsEvent({required this.userUid});
}

class CheckFavoriteSongStatusEvent extends FavoriteSongEvent {
  final String userUid;
  final String songId;

  CheckFavoriteSongStatusEvent({required this.userUid, required this.songId});
}
