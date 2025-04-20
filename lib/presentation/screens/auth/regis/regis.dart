import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/core/config/assets/app_vectors.dart';
import 'package:spotify/core/config/theme/app_colors.dart';
import 'package:spotify/presentation/screens/auth/login/login.dart';
import 'package:spotify/presentation/screens/auth/regis/regis.dart';
import 'package:spotify/presentation/screens/choose-mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/screens/home/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();
  final _repeatUserPassword = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextRepeat = true;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _userEmail.dispose();
    _userPassword.dispose();
    _repeatUserPassword.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        setState(() {
          isLoading = true;
        });

        final userEmail = _userEmail.text.trim();
        final userPassword = _userPassword.text;

        // Create user with email and password
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: userEmail,
              password: userPassword,
            );

        final user = userCredential.user;

        if (user != null) {
          // Optional: Add user data to Firestore or Realtime Database
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'email': userEmail,
                'user_name':
                    userEmail.split('@')[0], // 👈 Extracts part before '@'
                'createdAt': Timestamp.now(),
                // Add other user details as needed
              })
              .onError((e, _) => print("Error writing document: $e"));
          ;

          // Navigate to home screen or profile completion page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase Auth errors for registration
        String errorMessage;

        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already registered.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          default:
            errorMessage = 'Registration failed. Please try again.';
        }

        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      } finally {
        // Hide loading indicator
        setState(() {
          isLoading = false;
        });
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
                  SizedBox(height: 30),
                  //Sign-in Title
                  Center(
                    child: Text(
                      'Register',
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
                          SizedBox(
                            height: 70, // 👈 your desired height
                            child: TextFormField(
                              controller: _userEmail,
                              autofocus: true,
                              maxLines: null, // 👈 allows it to expand
                              expands: true, // 👈 fills the parent height
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
                                  vertical: 0,
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
                          ),

                          //Gap
                          SizedBox(height: 20),

                          //Password Input
                          TextFormField(
                            controller: _userPassword,
                            autofocus: false,
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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 25,
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

                          //Repeat Password Input
                          TextFormField(
                            controller: _repeatUserPassword,
                            autofocus: false,
                            cursorColor: Colors.grey,
                            obscureText: _obscureTextRepeat,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password one more time';
                              }

                              if (value != _userPassword.text) {
                                return 'Repeat password does not match!';
                              }

                              return null; // valid
                            },

                            decoration: InputDecoration(
                              hintText: 'Enter Your Password',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 25,
                                horizontal: 20,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureTextRepeat = !_obscureTextRepeat;
                                  });
                                },
                                icon: Icon(
                                  _obscureTextRepeat == false
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
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

                          //Submit Button
                          SizedBox(
                            width: double.infinity, // full width of parent
                            height: 70, // fixed height
                            child: ElevatedButton(
                              onPressed: signUp,
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
