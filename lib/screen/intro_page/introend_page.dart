import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/bloc/editprofile_bloc/editprofile_bloc.dart';
import 'package:minimal_app/screen/bottom_bar/bottom_bar.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class IntroendPage extends StatelessWidget {
  final String fullname;
  final String birthdate;
  final String gender;

  const IntroendPage(
      {super.key,
      required this.fullname,
      required this.birthdate,
      required this.gender});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditprofileBloc, EditprofileState>(
      listener: (context, state) {
        if (state is EditprofileSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage()), // Arahkan ke halaman baru
            (Route<dynamic> route) =>
                false, // Menghapus semua halaman sebelumnya
          );
        } else if (state is EditprofileError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.whitedefault,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Image.asset(
                "assets/png/intro/alldone.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Gap(20),
            TxtCustom(
              tittle: "You're All Set!",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TxtCustom(
                tittle:
                    "Thank you for completing your profile! Now, it's time to explore an exciting shopping experience 🎉",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                alignment: TextAlign.center,
              ),
            ),
            Gap(50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppPallete.black,
                      ),
                      child: InkWell(
                        splashColor: AppPallete.pink,
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context
                              .read<EditprofileBloc>()
                              .add(EditprofileSubmitted(
                                updatedFields: {
                                  "full_name": fullname,
                                  "gender": gender,
                                  "birthdate": birthdate
                                },
                              ));
                        },
                        child: Center(
                          child: Text(
                            "Explore Now",
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 14,
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
    );
  }
}
