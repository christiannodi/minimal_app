import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/screen/intro_page/intro2_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget/form_widget.dart';
import 'package:minimal_app/widget_text.dart';

class Intro1Page extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();

  Intro1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  child: Image.asset(
                    "assets/png/intro/fullname.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(70),
                TxtCustom(
                  tittle: "Hello!",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TxtCustom(
                  tittle: "Who do we know you as?",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Gap(20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: InputForm(
                    tittle: "Your Name",
                    hinttext: "ex. Joko Widodo",
                    controller: _fullnameController,
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }

                      return null;
                    },
                  ),
                ),
                Gap(60),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppPallete.black,
                          ),
                          child: InkWell(
                            splashColor: AppPallete.pink,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Intro2Page(
                                            fullname: _fullnameController.text,
                                          )),
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                "Next",
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
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
}
