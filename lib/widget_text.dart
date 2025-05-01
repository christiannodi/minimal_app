import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class TxtCustom extends StatelessWidget {
  final String tittle;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? alignment; // Tambahkan alignment opsional

  const TxtCustom({
    super.key,
    required this.tittle,
    this.fontSize = 16, // Default font size
    this.fontWeight = FontWeight.w500, // Default font weight
    this.color = AppPallete.black, // Default color
    this.alignment, // Optional alignment
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      tittle,
      maxLines: 1,
      textAlign: alignment, // Pakai alignment kalau ada
      style: GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
