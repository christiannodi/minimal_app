import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_app/screen/profile_page/order/mustpay_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

import '../bottom_bar/bottom_bar.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Gap(100),
          Expanded(
              child: Center(
            child: Lottie.asset("assets/lottie/success1.json",
                height: 250,
                width: 250,
                repeat: true,
                fit: BoxFit.fill,
                frameRate: FrameRate.max),
          )),
          TxtCustom(
            tittle: "Congratulations",
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: AppPallete.white,
          ),
          TxtCustom(
            tittle: "Your order is accepted!",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppPallete.white,
          ),
          Gap(50),
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppPallete.whitedefault,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TxtCustom(
                  tittle: "You order must pay pay",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.black,
                ),
                Gap(10),
                TxtCustom(
                  tittle: "in 60minutes",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.black,
                ),
                Gap(20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MustpayPage()));
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppPallete.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: TxtCustom(
                        tittle: "Pay Now",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppPallete.white,
                      ),
                    ),
                  ),
                ),
                Gap(10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainPage()), // Arahkan ke halaman baru
                      (Route<dynamic> route) =>
                          false, // Menghapus semua halaman sebelumnya
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppPallete.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: TxtCustom(
                        tittle: "Back to HomePage",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppPallete.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
