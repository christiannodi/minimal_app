import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/theme.dart';

class ButtonWidget extends StatelessWidget {
  final String tittle;
  final VoidCallback onTap;
  final double height;
  final double width;
  final Color color;
  final double borderradius;

  const ButtonWidget(
      {super.key,
      required this.tittle,
      required this.onTap,
      required this.height,
      required this.width,
      required this.color,
      this.borderradius = 14});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: InkWell(
          splashColor: AppPallete.pink,
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Center(
            child: Text(
              tittle,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppPallete.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
