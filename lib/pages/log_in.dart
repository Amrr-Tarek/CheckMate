import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/const/shapes.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Image at the top
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
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
                const Text(
                  "Check Mate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColor,
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
                    buildDot(AppColors.boxColor),
                    const SizedBox(width: 8),
                    buildDot(AppColors.textColor),
                    const SizedBox(width: 8),
                    buildDot(AppColors.boxColor),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                const TextStyle(color: AppColors.textColor),
                            filled: true,
                            fillColor: AppColors.backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(
                                color: AppColors.textColor.withOpacity(0.5)),
                          ),
                        ),
                      ),

                      // Password Field
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                const TextStyle(color: AppColors.textColor),
                            filled: true,
                            fillColor: AppColors.backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Enter your password",
                            hintStyle: TextStyle(
                                color: AppColors.textColor.withOpacity(0.5)),
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
                              const Text(
                                "Remember me",
                                style: TextStyle(color: AppColors.smallText),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // ---------------> rember me logic <------------------------
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: AppColors.hyperlink),
                            ),
                          ),
                        ],
                      ),

                      // Log In Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Button(
                          label: "Log in",
                          onPressed: () async {
                            // ---------------> log in logic <------------------------

                            await AuthController().signIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context,
                            );
                            // navigate(context, "/home");
                          },
                          backgroundColor: AppColors.boxColor,
                          textColor: AppColors.backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          borderRadius: 24.0,
                          height: 48.0,
                        ),
                      ),

                      // Google and github buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google Button
                          _siginInWith(
                            () => AuthController()
                                .signInWithGoogle(context: context),
                            'assets/google-logo.png',
                          ),
                          SizedBox(width: 32),
                          // Github Button
                          _siginInWith(
                              () => AuthController()
                                  .signInWithGithub(context: context),
                              'assets/github-logo.png')
                        ],
                      ),
                    ],
                  ),
                ),

                // Sign Up Prompt
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.smallText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/signup");
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: AppColors.hyperlink,
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
        ),
      ),
    );
  }

  GestureDetector _siginInWith(onTap, iconPath) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(150, 158, 158, 158),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Image.asset(
          iconPath,
          height: 60,
          width: 60,
        ),
      ),
    );
  }
}
