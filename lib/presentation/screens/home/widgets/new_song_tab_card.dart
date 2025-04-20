import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  const SongCard({super.key, required this.artist, required this.song});

  final String artist;
  final String song;

  final String firebaseUrl =
      'https://firebasestorage.googleapis.com/v0/b/spotify-b1d8f.firebasestorage.app/o/covers%2F';

  final String imgFormat = '.jpg?alt=media';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none, // 👈 allow the Positioned to overflow
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    '$firebaseUrl${Uri.encodeComponent(artist)} - ${Uri.encodeComponent(song)}$imgFormat',
                    scale: 1,
                    height: 200,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  bottom: -10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 35,
                    height: 35,
                    child: Icon(Icons.play_arrow, size: 20),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              width: 150,
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Text(artist, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
