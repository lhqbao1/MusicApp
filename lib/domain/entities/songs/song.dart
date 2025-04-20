import 'package:cloud_firestore/cloud_firestore.dart';

class SongEntity {
  SongEntity({
    required this.title,
    required this.artists,
    required this.duration,
  });

  final String title;
  final String artists;
  final Timestamp duration;

  // Convert Firestore document to SongEntity
  factory SongEntity.fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return SongEntity(
      title: doc['title'], // Map 'title' field
      artists: doc['artists'], // Map 'artists' field
      duration: doc['duration'], // Map 'duration' field
    );
  }
}
