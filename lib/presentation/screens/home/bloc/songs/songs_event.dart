import 'package:equatable/equatable.dart';

abstract class SongsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSongsEvent extends SongsEvent {}
