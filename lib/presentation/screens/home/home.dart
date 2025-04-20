import 'package:flutter/material.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/choose-mode/choose_mode.dart';
import 'package:spotify/presentation/screens/home/main_screen.dart';
import 'package:spotify/presentation/screens/splash/splash_screen.dart';
import 'package:spotify/presentation/screens/user/user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> bodyPages = [MainScreen(), UserScreen(), ChooseModeScreen()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Stack(
          children: [
            SizedBox(
              height: 100,
              child: BottomNavigationBar(
                fixedColor: AppColors.primary,
                currentIndex: _selectedIndex,
                onTap: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: "Home",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: "User",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                  ),
                ],
              ),
            ),
            // Green Line Above Active Item
            AnimatedPositioned(
              duration: Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut, // Animation curve for smooth effect
              top: 0, // Position above the bar
              left: MediaQuery.of(context).size.width / 3 * _selectedIndex,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 4, // Line height
                color: Colors.green,
              ),
            ),
          ],
        ),
        body: bodyPages[_selectedIndex],
      ),
    );
  }
}
