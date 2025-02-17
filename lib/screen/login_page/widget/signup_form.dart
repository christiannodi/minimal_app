import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/widget/form_widget.dart';
import 'package:minimal_app/theme.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputForm(
            tittle: "Username",
            hinttext: "Enter your username...",
            obscure: false,
            controller: _usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Username cannot be empty";
              }

              return null;
            },
          ),
          Gap(14),
          InputForm(
            tittle: "Email",
            hinttext: "Enter your email...",
            obscure: false,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email cannot be empty";
              }

              String pattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              RegExp regex = RegExp(pattern);

              if (!regex.hasMatch(value)) {
                return "Enter a valid email address";
              }

              return null;
            },
          ),
          Gap(14),
          InputForm(
            tittle: "Password",
            hinttext: "Enter your password...",
            obscure: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password cannot be empty";
              }
              if (!RegExp(
                      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                  .hasMatch(value)) {
                return "Password must have at least 1 uppercase, 1 number, 1 special character";
              }
              return null;
            },
          ),
          Gap(14),
          InputForm(
            tittle: "Re-Password",
            hinttext: "Enter your password again...",
            obscure: true,
            controller: _rePasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Re-Password cannot be empty";
              }
              if (value != _passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          Gap(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: Ink(
                  height: 42,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppPallete.black,
                  ),
                  child: InkWell(
                    splashColor: AppPallete.pink,
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {}
                    },
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
