import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/model/address_model.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class AddressSettings extends StatelessWidget {
  const AddressSettings({super.key});

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
                      tittle: "Address",
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
                    TxtCustom(
                      tittle: "My address",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    Gap(10),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: listAddress.length,
                      shrinkWrap: true, // Memastikan semua item tampil
                      physics:
                          NeverScrollableScrollPhysics(), // Matikan scroll internal
                      separatorBuilder: (BuildContext context, int index) {
                        return const Gap(10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Address(addressModel: listAddress[index]);
                      },
                    ),
                    Gap(10),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: AppPallete.whitedefault,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TxtCustom(
                          tittle: "Add New Address",
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppPallete.pink,
                        ),
                      ),
                    ),
                    Gap(30),
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

class Address extends StatelessWidget {
  final AddressModel addressModel;

  const Address({super.key, required this.addressModel});

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
          Row(
            children: [
              TxtCustom(
                tittle: addressModel.name,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              Gap(10),
              TxtCustom(
                tittle: "|",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              Gap(10),
              TxtCustom(
                tittle: addressModel.phone,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          TxtCustom(
            tittle: addressModel.street,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppPallete.grey,
          ),
          TxtCustom(
            tittle: addressModel.city,
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: AppPallete.grey,
          ),
        ],
      ),
    );
  }
}
