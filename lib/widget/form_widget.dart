import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/theme.dart';

class InputForm extends StatefulWidget {
  final String tittle;
  final String hinttext;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputForm({
    super.key,
    required this.tittle,
    required this.hinttext,
    required this.obscure,
    this.controller,
    this.validator,
  });

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure ? _obscureText : false,
      validator: widget.validator,
      style: GoogleFonts.jetBrainsMono(
          fontSize: 14, fontWeight: FontWeight.w500, color: AppPallete.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPallete.whitedefault,
        labelText: widget.tittle,
        labelStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        hintText: widget.hinttext,
        hintStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppPallete.grey, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        suffixIcon: widget.obscure
            ? Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              )
            : null,
      ),
    );
  }
}

//! FORM PROFILE SETTING
class InputFormProfile extends StatefulWidget {
  final String initialValue; // Data awal yang bisa diedit
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputFormProfile({
    super.key,
    required this.initialValue,
    this.controller,
    this.validator,
  });

  @override
  State<InputFormProfile> createState() => _InputFormProfileState();
}

class _InputFormProfileState extends State<InputFormProfile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _controller, // Teks awal diatur dari controller
        validator: widget.validator,
        style: GoogleFonts.jetBrainsMono(
            fontSize: 12, fontWeight: FontWeight.w400, color: AppPallete.grey),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppPallete.whitedefault,
          hintText: widget.initialValue, // Menampilkan teks awal
          hintStyle: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppPallete.white),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppPallete.white, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}
