import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:minimal_app/screen/intro_page/intro2_page.dart';
import 'package:minimal_app/screen/intro_page/intro4_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class Intro3Page extends StatefulWidget {
  final String fullname;
  final String gender;

  const Intro3Page({super.key, required this.fullname, required this.gender});

  @override
  _Intro3PageState createState() => _Intro3PageState();
}

class _Intro3PageState extends State<Intro3Page> {
  DateTime? selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // Format YYYY-MM-DD

  void _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime tempDate = selectedDate ?? DateTime.now();

        return Container(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Your Birthday",
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: tempDate,
                      maximumDate: DateTime.now(),
                      minimumYear: 1900,
                      maximumYear: DateTime.now().year,
                      onDateTimeChanged: (DateTime dateTime) {
                        tempDate = dateTime;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, tempDate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(50)
            ],
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                child: Image.asset(
                  "assets/png/intro/birthday.jpg",
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
                tittle: "What is your birthday",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppPallete.grey),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Select your birthday"
                              : DateFormat('dd-MMM-yyyy').format(selectedDate!),
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedDate == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Colors.black),
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
                            if (selectedDate != null) {
                              debugPrint(
                                  "Tanggal lahir yang dipilih: ${_dateFormat.format(selectedDate!)}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Intro4Page(
                                          fullname: widget.fullname,
                                          gender: widget.gender,
                                          birthdate:
                                              _dateFormat.format(selectedDate!),
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
    );
  }
}
