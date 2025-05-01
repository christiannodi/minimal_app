import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/bloc/addaddress_bloc/addaddress_bloc.dart';
import 'package:minimal_app/bloc/deleteaddress_bloc/deleteaddress_bloc.dart';
import 'package:minimal_app/bloc/editaddress_bloc/editaddress_bloc.dart';
import 'package:minimal_app/bloc/getalladdress_bloc/getalladdress_bloc_bloc.dart';
import 'package:minimal_app/models/list_address_model.dart';
import 'package:minimal_app/screen/profile_page/screen/address_page/addaddress_page.dart';
import 'package:minimal_app/screen/profile_page/screen/address_page/editaddress_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme.dart';
import '../../../widget_text.dart';

class AddressSettings extends StatefulWidget {
  const AddressSettings({super.key});

  @override
  State<AddressSettings> createState() => _AddressSettingsState();
}

class _AddressSettingsState extends State<AddressSettings> {
  @override
  void initState() {
    super.initState();

    // ✅ Hanya fetch jika state belum ada
    context.read<GetalladdressBloc>().add(Getalladdress());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddaddressBloc, AddaddressState>(
          listener: (context, state) {
            if (state is AddaddressSuccess) {
              context.read<GetalladdressBloc>().add(
                  Getalladdress()); // 🔄 Fetch ulang saat alamat sukses ditambahkan
            }
          },
        ),
        BlocListener<DeleteaddressBloc, DeleteaddressState>(
          listener: (context, state) {
            if (state is DeleteaddressSuccess) {
              context.read<GetalladdressBloc>().add(
                  Getalladdress()); // 🔄 Fetch ulang saat alamat sukses ditambahkan
            }
          },
        ),
        BlocListener<EditaddressBloc, EditaddressState>(
          listener: (context, state) {
            if (state is EditaddressSuccess) {
              context.read<GetalladdressBloc>().add(
                  Getalladdress()); // 🔄 Fetch ulang saat alamat sukses ditambahkan
            }
          },
        ),
      ],
      child: BlocBuilder<GetalladdressBloc, GetalladdressState>(
        builder: (context, state) {
          if (state is GetalladdressSuccess) {
            final products = state.addressDataModel; // Ambil list produk
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
                              tittle: "Address",
                              color: AppPallete.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),

                            const SizedBox(height: 40),

                            Container(
                              height: 20,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppPallete.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
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
                              itemCount: products.length,
                              shrinkWrap: true, // Memastikan semua item tampil
                              physics:
                                  NeverScrollableScrollPhysics(), // Matikan scroll internal
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Gap(10);
                              },
                              itemBuilder: (context, index) {
                                final address = products[index];
                                return Address(addressModel: address);
                              },
                            ),
                            Gap(10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddaddressPage()));
                              },
                              child: Container(
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
          if (state is GetalladdressLoading) {
            return Skeletonizer(
                child: Scaffold(
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
                          mainAxisAlignment: MainAxisAlignment.end,
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
                              height: 20,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppPallete.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
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
                              itemCount: 5,
                              shrinkWrap: true, // Memastikan semua item tampil
                              physics:
                                  NeverScrollableScrollPhysics(), // Matikan scroll internal
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Gap(10);
                              },
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  // ?fungsi ontap

                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppPallete.whitedefault,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            TxtCustom(
                                              tittle: "addressModel.name",
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
                                              tittle: "addressModel.phone",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        TxtCustom(
                                          tittle:
                                              "addressModel.address, addressModel.notes",
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          color: AppPallete.grey,
                                        ),
                                        TxtCustom(
                                          tittle:
                                              "addressModel.district, addressModel.city, addressModel.province, addressModel.postalCode",
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400,
                                          color: AppPallete.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Gap(10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddaddressPage()));
                              },
                              child: Container(
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
                            ),
                            Gap(30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Address extends StatelessWidget {
  final AddressDataModel addressModel;

  const Address({super.key, required this.addressModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ?fungsi ontap
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditaddressPage(addressDataModel: addressModel),
          ),
        );
      },
      child: Container(
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
              tittle: "${addressModel.address}, ${addressModel.notes}",
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: AppPallete.grey,
            ),
            TxtCustom(
              tittle:
                  "${addressModel.district}, ${addressModel.city}, ${addressModel.province}, ${addressModel.postalCode}",
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppPallete.grey,
            ),
          ],
        ),
      ),
    );
  }
}
