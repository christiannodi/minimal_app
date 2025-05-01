import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/api/request_api.dart';
import 'package:minimal_app/models/secure_storage_flutter/secure_storage.dart';
import 'package:minimal_app/screen/login_page/login_page.dart';
import '../../../theme.dart';
import '../../../widget_text.dart';

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
              alignment: AlignmentDirectional.bottomCenter,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        height: 20,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppPallete.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        )),
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
                    GestureDetector(
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Sudut lebih rounded
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Are you sure you want to logout?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(
                                          'LOGOUT',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                        if (shouldLogout == true && context.mounted) {
                          final secureStorageHelper = SecureStorageHelper();
                          RequestApiHeader requestApiHeader =
                              RequestApiHeader(secureStorageHelper);
                          await requestApiHeader.logout(context);

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppPallete.whitedefault,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TxtCustom(
                            tittle: "LOGOUT",
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppPallete.pink,
                          ),
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
