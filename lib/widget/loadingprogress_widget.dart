import 'package:flutter/material.dart';
import 'package:minimal_app/theme.dart';

class LoadingDialog {
  static void show(BuildContext context, {Color? indicatorColor}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AbsorbPointer(
        absorbing: true,
        child: Center(
          child: CircularProgressIndicator(
            color: indicatorColor ?? AppPallete.black, // Warna default hitam
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
