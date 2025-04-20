import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/core/config/assets/app_vectors.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/core/config/theme/app_themes.dart';
import 'package:spotify/presentation/screens/auth/login/login.dart';
import 'package:spotify/presentation/screens/choose-mode/bloc/theme_cubit.dart';

class ChooseModeScreen extends StatefulWidget {
  const ChooseModeScreen({super.key});

  @override
  State<ChooseModeScreen> createState() => _ChooseModeScreenState();
}

class _ChooseModeScreenState extends State<ChooseModeScreen> {
  void redirect() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/choose_mode_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(child: SvgPicture.asset(AppVectors.appSplash)),
                  Column(
                    children: [
                      Text(
                        'Choose mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('object');
                                  context.read<ThemeCubit>().updateTheme(
                                    ThemeMode.dark,
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Color.fromRGBO(50, 59, 62, 1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/vectors/moon.svg',
                                      height: 40,
                                      width: 40,
                                      color:
                                          themeMode == ThemeMode.dark
                                              ? Colors.black
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 50),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<ThemeCubit>().updateTheme(
                                    ThemeMode.light,
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        themeMode == ThemeMode.light
                                            ? Colors.white
                                            : Color.fromRGBO(50, 59, 62, 1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/vectors/sun.svg',
                                      height: 40,
                                      width: 40,
                                      color:
                                          themeMode == ThemeMode.light
                                              ? Colors.black
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Light Mode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 55),
                      ElevatedButton(
                        onPressed: redirect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 20,
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
