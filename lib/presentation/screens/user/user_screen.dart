import 'package:flutter/material.dart';
import 'package:spotify/presentation/screens/user/widgets/user_info.dart';
import 'package:spotify/presentation/screens/user/widgets/user_list.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 30, minHeight: 30),
          icon: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, size: 18, color: Colors.black),
          ),
          onPressed: () {
            // Your onPressed handler here
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [UserInfo(), UserSongList()]),
        ),
      ),
    );
  }
}
