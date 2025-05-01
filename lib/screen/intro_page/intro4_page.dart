import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/bloc/editphonenumber_bloc/editphonenumber_bloc.dart';
import 'package:minimal_app/screen/intro_page/introend_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget/form_widget.dart';
import 'package:minimal_app/widget_text.dart';

class Intro4Page extends StatelessWidget {
  final String fullname;
  final String birthdate;
  final String gender;
  final _phonenumberController = TextEditingController();

  Intro4Page(
      {super.key,
      required this.fullname,
      required this.birthdate,
      required this.gender});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditphonenumberBloc, EditphonenumberState>(
      listener: (context, state) {
        if (state is EditphonenumberSuccess) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IntroendPage(
                      fullname: fullname,
                      birthdate: birthdate,
                      gender: gender)));
        } else if (state is EditphonenumberError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.whitedefault,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  child: Image.asset(
                    "assets/png/intro/phonenumber.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(70),
                TxtCustom(
                  tittle: " ",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TxtCustom(
                  tittle: "Add your phone number",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Gap(20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: InputForm(
                      tittle: "Phonenumber",
                      controller: _phonenumberController,
                      hinttext: "ex. 628122xxxxxx",
                      obscure: false),
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
                              if (_phonenumberController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Masukkan nomor telepon!"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                context
                                    .read<EditphonenumberBloc>()
                                    .add(EditphonenumberSubmitted(
                                      updatedFields: {
                                        "phone": _phonenumberController.text
                                      },
                                    ));
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
