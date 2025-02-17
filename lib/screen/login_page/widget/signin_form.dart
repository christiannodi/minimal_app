import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/screen/bottom_bar/bottom_bar.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget/button_widget.dart';
import 'package:minimal_app/widget/form_widget.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputForm(
          tittle: "Username",
          hinttext: "Enter your username...",
          obscure: false,
        ),
        Gap(14),
        InputForm(
          tittle: "Password",
          hinttext: "Enter your password...",
          obscure: true,
        ),
        Gap(14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent),
              child: Center(
                  child: Text(
                "Forgot Password?",
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              )),
            ),
            SizedBox(
              width: 16,
            ),
            ButtonWidget(
              tittle: "Sign In",
              height: 42,
              width: 170,
              color: AppPallete.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            )
          ],
        )
      ],
    );
  }
}
