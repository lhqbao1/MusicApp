import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/song-playing/song_playing.dart';

final Stream<QuerySnapshot> songStream =
    FirebaseFirestore.instance.collection('songs').snapshots();

class HomePlayList extends StatefulWidget {
  const HomePlayList({super.key});

  @override
  State<HomePlayList> createState() => _HomePlayListState();
}

class _HomePlayListState extends State<HomePlayList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Playlist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See more',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: songStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No songs available'));
              }

              var songs = snapshot.data!.docs;
              return ListView.builder(
                padding: EdgeInsets.all(0),

                shrinkWrap: true, // Makes ListView take only needed space
                physics: NeverScrollableScrollPhysics(),
                // physics:
                //     ClampingScrollPhysics(), // Optional: controls scroll behavior
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              songs[index]['title'],
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Text(songs[index]['artists']),
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SongPlayingScreen(
                                        songs: songs[index],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.play_arrow),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Text(songs[index]['duration'].toString()),
                        ),

                        // Alternative: Custom icon button with GestureDetector
                        GestureDetector(
                          onTap: () {
                            // Your action here
                          },
                          child: Container(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              // Optional styling
                              // color: Colors.grey.shade200,
                              // borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
