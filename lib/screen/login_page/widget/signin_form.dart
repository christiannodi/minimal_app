import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/bloc/getuserdata_bloc/getuserdata_bloc.dart';
import 'package:minimal_app/bloc/login_bloc/login_bloc.dart';
import 'package:minimal_app/screen/intro_page/intro1_page.dart';
import '../../../widget/loadingprogress_widget.dart';
import '../../bottom_bar/bottom_bar.dart';
import '../../../theme.dart';
import '../../../widget/button_widget.dart';
import '../../../widget/form_widget.dart';

class SignInForm extends StatelessWidget {
  SignInForm({super.key});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          LoadingDialog.show(context);
        } else if (state is LoginSuccess) {
          Navigator.of(context, rootNavigator: true).pop();

          final session = state.sessionModel; // Ambil session dari state
          // Cek apakah fullname null atau kosong
          if (session.fullName == null) {
            // Arahkan ke halaman isi fullname
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Intro1Page()));
          } else {
            // Arahkan ke halaman utama jika fullname sudah ada
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          }
        } else if (state is LoginError) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Username or Password Wrong!"),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Column(
        children: [
          InputForm(
            tittle: "Username",
            hinttext: "Enter your username...",
            obscure: false,
            controller: _usernameController,
          ),
          Gap(14),
          InputForm(
            tittle: "Password",
            hinttext: "Enter your password...",
            obscure: true,
            controller: _passwordController,
          ),
          Gap(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent),
                child: Center(
                    child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                )),
              ),
              SizedBox(
                width: 16,
              ),
              ButtonWidget(
                tittle: "Sign In",
                height: 42,
                width: 170,
                color: AppPallete.black,
                onTap: () {
                  context.read<LoginBloc>().add(LoginRequest(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      ));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
