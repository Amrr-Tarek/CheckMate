import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/screen/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Image at the top
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://store-images.s-microsoft.com/image/apps.62514.14072257880299669.a6333773-bfab-44a6-8ce8-4884b6e58a5b.0dcdfaf5-1abb-4ac1-b68e-eec3728420e2?q=90&w=480&h=270",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title Section
            Text(
              "Check Mate",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors().textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDot(AppColors().boxColor),
                const SizedBox(width: 8),
                buildDot(AppColors().textColor),
                const SizedBox(width: 8),
                buildDot(AppColors().boxColor),
              ],
            ),
            const SizedBox(height: 16),

            // Login and Password Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Username Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(color: AppColors().textColor),
                        filled: true,
                        fillColor: AppColors().backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter your username",
                        hintStyle: TextStyle(
                            color: AppColors().textColor.withOpacity(0.5)),
                      ),
                    ),
                  ),

                  // Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: AppColors().textColor),
                        filled: true,
                        fillColor: AppColors().backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                            color: AppColors().textColor.withOpacity(0.5)),
                      ),
                    ),
                  ),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          Text(
                            "Remember me",
                            style: TextStyle(color: AppColors().smallText),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // ---------------> rember me logic <------------------------
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: AppColors().hyperlink),
                        ),
                      ),
                    ],
                  ),

                  // Log In Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().boxColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        // ---------------> log in logic <------------------------
                        // Directs to home page without validations (for now)
                        /// What should we do:
                        /// pass a function for validating input..
                        /// Inside the function we check the validation of the input then if the user's data is found in the database
                        /// Directs the user to his home page and passing in the parameters queried from the database
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomePage(),
                          ),
                        );
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          color: AppColors().backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Login with Google
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        // ---------------> log in google logic <------------------------
                      },
                      child: Text(
                        "Log in using Google",
                        style: TextStyle(
                          color: AppColors().boxColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sign Up Prompt
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: AppColors().smallText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // ---------------> sign up logic <------------------------
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: AppColors().hyperlink,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(Color color) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
