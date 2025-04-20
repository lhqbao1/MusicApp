import 'package:equatable/equatable.dart';

abstract class SongState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SongInitialState extends SongState {}

class SongLoadingState extends SongState {}

class SongLoadedState extends SongState {
  SongLoadedState({required this.songs});

  final List<Map<String, dynamic>> songs;
  @override
  List<Object?> get props => [songs];
}

class SongErrorState extends SongState {
  final String error;

  SongErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
