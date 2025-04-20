import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/core/config/assets/app_vectors.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/auth/regis/regis.dart';
import 'package:spotify/presentation/screens/choose-mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/screens/home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _userEmail.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No account found with this email address.';
        break;
      case 'wrong-password':
        message = 'Invalid password. Please try again.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many login attempts. Please try again later.';
        break;
      default:
        message = 'Authentication failed. Please check your credentials.';
    }

    _showErrorSnackBar(message);
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final userEmail = _userEmail.text;
        final password = _userPassword.text;

        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: userEmail, password: password);

        final userLogin = userCredential.user;

        if (userLogin != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        _handleAuthError(e);
      } catch (e) {
        _showErrorSnackBar('An unexpected error occurred. Please try again.');
        debugPrint('Sign-in error: $e');
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(AppVectors.appSplash, height: 40),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 20,
          icon: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.arrow_back, // Using iOS-style back arrow
              size: 14, // Smaller size works better for iOS back arrow
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 60),
                  //Sign-in Title
                  Center(
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //Sign-in Support
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('If you need any support'),
                      SizedBox(width: 5),
                      Text(
                        'Click here!',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  //Sign-in Form
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Email input
                          TextFormField(
                            controller: _userEmail,
                            autofocus: true,
                            cursorColor: Colors.grey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }

                              // Basic email regex check
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }

                              return null; // valid
                            },

                            decoration: InputDecoration(
                              hintText: 'Enter Your Email',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),

                          //Gap
                          SizedBox(height: 20),

                          //Password Input
                          TextFormField(
                            controller: _userPassword,
                            cursorColor: Colors.grey,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }

                              if (value.length < 8) {
                                return 'Password must be more than 8 characters';
                              }

                              return null; // valid
                            },

                            decoration: InputDecoration(
                              hintText: 'Enter Your Password',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText == false
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),

                          //Gap
                          SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Recovery password',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),

                          //Gap
                          SizedBox(height: 20),

                          //Submit Button
                          SizedBox(
                            width: double.infinity, // full width of parent
                            height: 70, // fixed height
                            child: ElevatedButton(
                              onPressed: signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child:
                                  isLoading == true
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        'Sign In',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                            ),
                          ),

                          //Gap
                          SizedBox(height: 20),

                          //Switch
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  'Or',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          //Gap
                          SizedBox(height: 20),

                          //Login Methods
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/google_logo.png',
                                  width: 40,
                                ),
                              ),
                              SizedBox(width: 50),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/apple_logo.png',
                                  width: 40,
                                ),
                              ),
                            ],
                          ),

                          //Gap
                          SizedBox(height: 50),

                          //Navigate To Register
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Not A Member?'),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return RegisterScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Register Now',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
