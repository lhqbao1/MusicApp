import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/screens/choose-mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_cubit.dart';
import 'package:spotify/presentation/screens/song-playing/bloc/favorite-song/favorite_song_event.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  User? userData; // To store the authenticated user
  late DocumentReference<Map<String, dynamic>> userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = FirebaseAuth.instance.currentUser;
    if (userData != null) {
      userInfo = FirebaseFirestore.instance
          .collection('users')
          .doc(userData?.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(bottom: 20),
      child: StreamBuilder(
        stream: userInfo.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No songs available'));
          }
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'https://i0.wp.com/ourgenerationmusic.com/wp-content/uploads/2022/08/henryhwu_@henryhwu_playboicarti12-1.jpg?fit=2813%2C2576&ssl=1',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Display user's email with fallback
              Text(
                userData?.email ?? "Email not available",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),

              SizedBox(height: 5),

              Text(
                snapshot.data!.data()?['user_name'] ?? 'Name not available',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '779',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text('Followers'),
                    ],
                  ),
                  SizedBox(width: 70),
                  Column(
                    children: [
                      Text(
                        '977',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text('Follow'),
                    ],
                  ),
                ],
              ),
            ],
          );
          ;
        },
      ),
    );
  }
}
