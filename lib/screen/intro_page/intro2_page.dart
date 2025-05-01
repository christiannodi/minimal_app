import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/screen/intro_page/intro3_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class Intro2Page extends StatefulWidget {
  final String fullname;

  const Intro2Page({super.key, required this.fullname});

  @override
  _Intro2PageState createState() => _Intro2PageState();
}

class _Intro2PageState extends State<Intro2Page> {
  String? selectedGender;

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["Male", "Female"].map((gender) {
              return ListTile(
                title: Text(
                  gender,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedGender = gender;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 300,
            child: Image.asset(
              "assets/png/intro/gender.jpg",
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
            tittle: "What is your gender?",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _showGenderPicker,
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedGender ?? "Select Gender",
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            selectedGender == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          Gap(60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        if (selectedGender != null) {
                          print("Selected Gender: $selectedGender");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Intro3Page(
                                      fullname: widget.fullname,
                                      gender: selectedGender.toString(),
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
    );
  }
}
