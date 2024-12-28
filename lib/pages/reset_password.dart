import 'package:checkmate/controllers/auth_controller.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/display_info.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Reset Password"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Enter your email to reset your password.",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email.";
                    }
                    final emailRegex = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"); // From stackoverflow
                    if (!emailRegex.hasMatch(value)) {
                      return "Please enter a valid email!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await AuthController()
                            .sendPasswordReset(_emailController.text);
                        showSnackBar(
                            context, "Password reset email sent successfully!");
                      } catch (e) {
                        showSnackBar(context, e.toString());
                      }
                    }
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.email_outlined),
                    SizedBox(width: 10),
                    Text("Send Password Reset Email",
                        style: TextStyle(fontSize: 16)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
