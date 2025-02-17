import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/theme.dart';

class TxtCustom extends StatelessWidget {
  final String tittle;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const TxtCustom(
      {super.key,
      required this.tittle,
      this.fontSize = 16, // Default font size
      this.fontWeight = FontWeight.w500, // Default font weight
      this.color = AppPallete.black // Default color
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      tittle,
      style: GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
