import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/screen/login_page/widget/signin_form.dart';
import 'package:minimal_app/screen/login_page/widget/signup_form.dart';
import 'package:minimal_app/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Stack(alignment: AlignmentDirectional.centerStart, children: [
                  Image.asset(
                    'assets/png/loginpage_bg.png',
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ".minimal",
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppPallete.white),
                        ),
                        Text(
                          "live, eat, and shop",
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppPallete.white),
                        ),
                      ],
                    ),
                  )
                ]),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: AppPallete.white),
                ),
              ],
            ),
            formLogin()
          ],
        )),
      ),
    );
  }

  Widget formLogin() {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 90, right: 90),
            child: TabBar(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerColor: Colors.transparent,
                indicatorColor: AppPallete.pink,
                labelColor: AppPallete.black,
                unselectedLabelColor: AppPallete.grey,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: GoogleFonts.jetBrainsMono(
                    fontSize: 16, fontWeight: FontWeight.w500),
                labelPadding: EdgeInsets.only(bottom: 15),
                tabs: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Sign In'),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Sign Up'),
                  ),
                ]),
          ),
          SizedBox(
            height: 450,
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: SignInForm(),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: SignUpForm()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
