import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({super.key});

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
                  height: 135,
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
                      tittle: "Setting & Privacy",
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
                      padding: const EdgeInsets.only(top: 20),
                    ),
                  ],
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
              ],
            ),
            Container(
              color: AppPallete.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailSettings(
                        tittle: "Your account",
                        detail:
                            'See information about your account, download an archive of your data, or learn about your account.'),
                    Gap(15),
                    DetailSettings(
                        tittle: "Notification",
                        detail:
                            "Select the kinds of notifications you get about activities, interests, and recommendations."),
                    Gap(15),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: AppPallete.whitedefault,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TxtCustom(
                          tittle: "LOGOUT",
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppPallete.pink,
                        ),
                      ),
                    ),
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

class DetailSettings extends StatelessWidget {
  final String tittle;
  final String detail;

  const DetailSettings({super.key, required this.tittle, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppPallete.whitedefault,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TxtCustom(
            tittle: tittle,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          TxtCustom(
            tittle: detail,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppPallete.grey,
          ),
        ],
      ),
    );
  }
}
