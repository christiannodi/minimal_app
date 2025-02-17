import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/screen/search_page/screen/dropdown_button.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Stack(alignment: AlignmentDirectional.bottomStart, children: [
                Image.asset(
                  'assets/png/bg.png',
                  width: double.infinity,
                  height: 164,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 28),
                  child: Text(
                    "Catalog",
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.white,
                    ),
                  ),
                ),
              ]),
              Container(
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "Please select category",
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppPallete.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomDropdownExample()),
              );
            },
            child: SelectCategory(
              tittle: "Man",
            ),
          ),
          SelectCategory(
            tittle: "Women",
          )
        ],
      ),
    );
  }
}

class SelectCategory extends StatelessWidget {
  final String tittle;

  const SelectCategory({super.key, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Gap(15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TxtCustom(
                tittle: tittle,
                color: AppPallete.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SvgPicture.asset(
                'assets/svg/arrow.svg',
                color: AppPallete.black,
                width: 20,
                height: 20,
              ),
            ],
          ),
          Gap(15),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
