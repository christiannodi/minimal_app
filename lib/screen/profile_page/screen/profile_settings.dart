import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/widget/button_widget.dart';
import 'package:minimal_app/widget/form_widget.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: SingleChildScrollView(
        //Menghindari status bar tertutup
        child: Column(
          children: [
            Stack(
              children: [
                // Background Header
                Container(
                  height: 210,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/png/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Konten di atas background
                Column(
                  children: [
                    const SizedBox(height: 50),

                    // Teks Edit Profile
                    const TxtCustom(
                      tittle: "Edit Profile",
                      color: AppPallete.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),

                    const SizedBox(height: 40),

                    // Card Profil
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppPallete.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 100),
                    ),
                  ],
                ),

                // Foto Profil (Posisi di Tengah)
                Positioned(
                  top: 90,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          AssetImage("assets/png/photo_profile.png"),
                    ),
                  ),
                ),

                // Tombol Back
                Positioned(
                  top: 40,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/svg/arrow_back.svg',
                        color: AppPallete.white,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ),

                // Tombol SAVE
                Positioned(
                  top: 130,
                  right: 25,
                  child: ButtonWidget(
                    tittle: "Save",
                    onTap: () {},
                    height: 32,
                    width: 70,
                    borderradius: 10,
                    color: AppPallete.pink,
                  ),
                ),
              ],
            ),
            Container(
              color: AppPallete.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TxtCustom(
                        tittle: "Username",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(initialValue: "christiannodi"),
                    Gap(15),
                    TxtCustom(
                        tittle: "Full Name",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(initialValue: "Kristian Nodi"),
                    Gap(15),
                    TxtCustom(
                        tittle: "Email",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(initialValue: "kristiannodi@gmail.com"),
                    Gap(15),
                    TxtCustom(
                        tittle: "Phone Number",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(initialValue: "0822-4293-6628"),
                    Gap(15),
                    TxtCustom(
                        tittle: "Date of birth",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(initialValue: "15 June 1998"),
                    Gap(15),
                    TxtCustom(
                        tittle: "Gender",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(initialValue: "Male"),
                    Gap(30), // Tambahkan gap untuk menghindari ketutupan keyboard
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
