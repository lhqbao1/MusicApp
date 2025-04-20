import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/presentation/screens/home/widgets/home_playlist.dart';
import 'package:spotify/presentation/screens/home/widgets/home_top_card.dart';
import 'package:spotify/presentation/screens/home/widgets/new_song_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 235, 235, 235),
          title: SvgPicture.asset(
            'assets/vectors/spotify_logo.svg',
            height: 40,
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HomeTopCard(),
              _homeTabs(),
              SizedBox(height: 10),
              _homeTabsView(),
              HomePlayList(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _homeTabs() {
  return TabBar(
    isScrollable: true,
    labelColor: Colors.black,
    indicatorColor: Colors.green,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: Colors.transparent,
    splashBorderRadius: BorderRadius.circular(30),

    tabs: [
      Tab(text: "News"),
      Tab(text: "Video"),
      Tab(text: "Artists"),
      Tab(text: "Artists"),
    ],
  );
}

class _homeTabsView extends StatelessWidget {
  const _homeTabsView({super.key});
  // Tab Content wrapped in a ConstrainedBox to provide finite height
  @override
  Widget build(context) {
    return SizedBox(
      // constraints: BoxConstraints.expand(height: 300),
      height: 300,
      child: TabBarView(
        // physics: NeverScrollableScrollPhysics(),
        children: [
          // News Tab Content
          NewSongsTab(),
          // Video Tab Content
          SingleChildScrollView(child: Center(child: Text('Video Content'))),
          // Artists Tab Content
          SingleChildScrollView(child: Center(child: Text('Artists Content'))),
          // Another Artists Tab Content
          SingleChildScrollView(
            child: Center(child: Text('More Artists Content')),
          ),
        ],
      ),
    );
  }
}
