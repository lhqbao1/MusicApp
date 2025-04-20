import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/core/config/assets/app_vectors.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/choose-mode/choose_mode.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({super.key});

  void redirect(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChooseModeScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // ensure full width
        height: double.infinity, // ensure full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/intro_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.96,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap SVG in a SizedBox or give it constraints
              SizedBox(
                width: 200,
                child: SvgPicture.asset(
                  AppVectors.appSplash,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  const Text(
                    'Enjoy Listening To Music',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: const Text(
                              "Discover, stream, and enjoy millions of songs with our all-in-one music app designed to elevate your listening experience anytime, anywhere.",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => redirect(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
