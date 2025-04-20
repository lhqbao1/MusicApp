import 'package:equatable/equatable.dart';

abstract class FavoriteSongState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteSongInitialState extends FavoriteSongState {}

class FavoriteSongLoadingState extends FavoriteSongState {}

class FavoritesSongCreatedState extends FavoriteSongState {}

class FavoritesSongRemovedState extends FavoriteSongState {}

class FavoriteSongCheckStatusState extends FavoriteSongState {
  FavoriteSongCheckStatusState({required this.isFavorite});

  final bool isFavorite;
}

class FavoriteSongLoadedState extends FavoriteSongState {
  FavoriteSongLoadedState({required this.favoriteSongs});

  final List<Map<String, dynamic>> favoriteSongs;

  @override
  List<Object?> get props => [favoriteSongs];
}

class FavoriteSongErrorState extends FavoriteSongState {
  FavoriteSongErrorState({required this.error});

  final String error;
}
