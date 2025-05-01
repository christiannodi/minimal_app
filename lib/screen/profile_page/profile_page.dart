import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:minimal_app/bloc/editavatar_bloc/editavatar_bloc.dart';
import 'package:minimal_app/bloc/editprofile_bloc/editprofile_bloc.dart';
import 'package:minimal_app/bloc/getuserdata_bloc/getuserdata_bloc.dart';
import 'package:minimal_app/models/user_model.dart';
import 'package:minimal_app/screen/order_page/order_page.dart';
import 'package:minimal_app/screen/profile_page/order/mustpay_page.dart';
import 'package:minimal_app/screen/profile_page/order/paid_page.dart';
import 'package:minimal_app/screen/profile_page/order/review_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../bloc/getcount_bloc/getcount_bloc.dart';
import '../../bloc/paynow_bloc/paynow_bloc.dart';
import '../home_page/home_page.dart';
import 'screen/address_settings.dart';
import 'screen/privacy_settings.dart';
import 'screen/profile_settings.dart';
import '../../theme.dart';
import '../../widget_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditprofileBloc, EditprofileState>(
          listener: (context, state) {
            if (state is EditprofileSuccess) {
              context.read<GetuserdataBloc>().add(GetUser());
            }
          },
        ),
        BlocListener<EditavatarBloc, EditavatarState>(
          listener: (context, state) {
            if (state is EditavatarSuccess) {
              context.read<GetuserdataBloc>().add(GetUser());
            }
          },
        ),
      ],
      child: BlocBuilder<GetuserdataBloc, GetuserdataState>(
        builder: (context, state) {
          if (state is GetuserdataSuccess) {
            final userData = state.userDataModel; // ✅ Simpan data di sini
            return Scaffold(
              backgroundColor: AppPallete.whitedefault,
              body: LiquidPullToRefresh(
                color: AppPallete.pink,
                onRefresh: () async {
                  context.read<GetuserdataBloc>().add(GetUser());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      // Background Header
                      Container(
                        height: 250, // Sesuaikan tinggi background
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/png/bg.png"), // Background Image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Konten di atas background
                      Column(
                        children: [
                          const SizedBox(
                              height: 90), // Ruang untuk teks di atas

                          // Teks Selamat Datang
                          const TxtCustom(
                            tittle: "Hello, minimalist!",
                            color: AppPallete.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),

                          const SizedBox(height: 80),

                          // Card Profil
                          SizedBox(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                  top: 55), // Memberi ruang untuk foto profil
                              child: content(userData),
                            ),
                          ),
                        ],
                      ),

                      // Foto Profil (Posisi di Tengah)
                      Positioned(
                        top: 130, // Sesuaikan posisi vertikalnya
                        left: MediaQuery.of(context).size.width / 2 -
                            60, // Agar pas di tengah
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Colors.white, // Warna putih untuk border luar
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                NetworkImage(userData.avatar), // Gambar Profil
                          ),
                        ),
                      ),

                      // Tombol Shopping Cart di Sudut Kanan
                      Positioned(top: 140, right: 20, child: CartIcon()),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is GetuserdataLoading) {
            return Skeletonizer(enabled: true, child: loadingScreen());
          }
          return Center(child: Text("Load Error"));
        },
      ),
    );
  }

  Column content(UserDataModel userData) {
    return Column(
      children: [
        TxtCustom(
          tittle: userData.fullName,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppPallete.black,
        ),
        TxtCustom(
          tittle: userData.email,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppPallete.black,
        ),
        Gap(20),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 168,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppPallete.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BalanceWidget(
                      tittle: "Wallet",
                      image: 'assets/svg/wallet.svg',
                      balance: "Rp302.000",
                    ),
                    BalanceWidget(
                      tittle: "Point",
                      image: 'assets/svg/point.svg',
                      balance: "21.201",
                    ),
                  ],
                ),
                Container(
                  height: 0.8,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FiturWidget(
                      tittle: "Voucher",
                      image: 'assets/svg/voucher.svg',
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MustpayPage(),
                        ),
                      ),
                      child: Stack(
                        children: [
                          FiturWidget(
                            tittle: "Must Pay",
                            image: 'assets/svg/mustpay.svg',
                          ),
                          BlocBuilder<GetcountBloc, GetcountState>(
                            builder: (context, state) {
                              if (state is GetcountSuccess) {
                                final count = state.countDataModel;
                                if (count.pending == 0) {
                                  return Container();
                                }
                                return Positioned(
                                  top: 0,
                                  right: 10,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppPallete.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: TxtCustom(
                                        tittle: count.pending.toString(),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        color: AppPallete.black,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaidPage(),
                        ),
                      ),
                      child: Stack(
                        children: [
                          FiturWidget(
                            tittle: "Sent",
                            image: 'assets/svg/sent.svg',
                          ),
                          BlocBuilder<GetcountBloc, GetcountState>(
                            builder: (context, state) {
                              if (state is GetcountSuccess) {
                                final count = state.countDataModel;
                                if (count.paid == 0) {
                                  return Container();
                                }
                                return Positioned(
                                  top: 0,
                                  right: 10,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppPallete.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: TxtCustom(
                                        tittle: count.paid.toString(),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        color: AppPallete.black,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewPage(),
                        ),
                      ),
                      child: Stack(
                        children: [
                          FiturWidget(
                            tittle: "Rate",
                            image: 'assets/svg/rate.svg',
                          ),
                          BlocBuilder<GetcountBloc, GetcountState>(
                            builder: (context, state) {
                              if (state is GetcountSuccess) {
                                final count = state.countDataModel;
                                if (count.shipped == 0) {
                                  return Container();
                                }
                                return Positioned(
                                  top: 0,
                                  right: 10,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppPallete.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: TxtCustom(
                                        tittle: count.shipped.toString(),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        color: AppPallete.black,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Gap(20),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: TxtCustom(
            tittle: "GENERAL",
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppPallete.black,
          ),
        ),
        Gap(10),
        GeneralSetting(
          tittle: "Profile Settings",
          page: ProfileSettings(
            fullName: userData.fullName,
            username: userData.username,
            email: userData.email,
            phone: userData.phone,
            birthdate: userData.birthdate,
            gender: userData.gender,
            avatar: userData.avatar,
          ),
        ),
        Gap(10),
        GeneralSetting(
          tittle: "Address",
          page: AddressSettings(),
        ),
        Gap(10),
        GeneralSetting(
          tittle: "Notification",
          page: ProfilePage(),
        ),
        Gap(10),
        GeneralSetting(
          tittle: "Transaction History",
          page: ProfilePage(),
        ),
        Gap(10),
        GeneralSetting(
          tittle: "Settings & Privacy",
          page: PrivacySettings(),
        )
      ],
    );
  }

  Scaffold loadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Header
          Container(
            height: 250, // Sesuaikan tinggi background
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/png/bg.png"), // Background Image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Konten di atas background
          Column(
            children: [
              const SizedBox(height: 90), // Ruang untuk teks di atas

              // Teks Selamat Datang
              const TxtCustom(
                tittle: "Hello, minimalist!",
                color: AppPallete.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 80),

              // Card Profil
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      top: 55), // Memberi ruang untuk foto profil
                  child: Column(
                    children: [
                      TxtCustom(
                        tittle: "fullname",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.black,
                      ),
                      TxtCustom(
                        tittle: "email",
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.black,
                      ),
                      Gap(20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          height: 168,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: AppPallete.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  BalanceWidget(
                                    tittle: "Wallet",
                                    image: 'assets/svg/wallet.svg',
                                    balance: "Rp302.000",
                                  ),
                                  BalanceWidget(
                                    tittle: "Point",
                                    image: 'assets/svg/point.svg',
                                    balance: "21.201",
                                  ),
                                ],
                              ),
                              Container(
                                height: 0.8,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FiturWidget(
                                    tittle: "Voucher",
                                    image: 'assets/svg/voucher.svg',
                                  ),
                                  FiturWidget(
                                    tittle: "Must Pay",
                                    image: 'assets/svg/mustpay.svg',
                                  ),
                                  FiturWidget(
                                    tittle: "Sent",
                                    image: 'assets/svg/sent.svg',
                                  ),
                                  FiturWidget(
                                    tittle: "Rate",
                                    image: 'assets/svg/rate.svg',
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Gap(20),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: TxtCustom(
                          tittle: "GENERAL",
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppPallete.black,
                        ),
                      ),
                      Gap(10),
                      GeneralSetting(
                        tittle: "Profile Settings",
                        page: AddressSettings(),
                      ),
                      Gap(10),
                      GeneralSetting(
                        tittle: "Address",
                        page: AddressSettings(),
                      ),
                      Gap(10),
                      GeneralSetting(
                        tittle: "Notification",
                      ),
                      Gap(10),
                      GeneralSetting(
                        tittle: "Transaction History",
                      ),
                      Gap(10),
                      GeneralSetting(
                        tittle: "Settings & Privacy",
                        page: PrivacySettings(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Foto Profil (Posisi di Tengah)
          Positioned(
            top: 130, // Sesuaikan posisi vertikalnya
            left: MediaQuery.of(context).size.width / 2 -
                60, // Agar pas di tengah
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white, // Warna putih untuk border luar
              child: CircleAvatar(
                radius: 55,
                backgroundImage:
                    AssetImage("assets/png/photo_profile.png"), // Gambar Profil
              ),
            ),
          ),

          // Tombol Shopping Cart di Sudut Kanan
          Positioned(top: 140, right: 20, child: CartIcon()),
        ],
      ),
    );
  }
}

class GeneralSetting extends StatelessWidget {
  final String tittle;
  final Widget? page;

  const GeneralSetting({super.key, required this.tittle, this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          if (page != null) {
            // Cek apakah page tidak null
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page!),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: AppPallete.white),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TxtCustom(
                  tittle: tittle,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppPallete.black,
                ),
                SvgPicture.asset(
                  'assets/svg/arrow.svg',
                  color: AppPallete.black,
                  width: 25,
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FiturWidget extends StatelessWidget {
  final String tittle;
  final String image;

  const FiturWidget({super.key, required this.image, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      width: 70,
      child: Column(
        children: [
          Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppPallete.pink),
              child: Center(
                child: SvgPicture.asset(
                  image,
                  width: 20,
                  height: 20,
                ),
              )),
          Gap(4),
          TxtCustom(
            tittle: tittle,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppPallete.whitedefault,
          )
        ],
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  final String tittle;
  final String image;
  final String balance;

  const BalanceWidget(
      {super.key,
      required this.tittle,
      required this.image,
      required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            image,
            width: 35,
            height: 35,
            colorFilter: const ColorFilter.mode(
              AppPallete.white,
              BlendMode.srcIn,
            ),
          ),
          Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TxtCustom(
                tittle: tittle,
                color: AppPallete.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              TxtCustom(
                tittle: balance,
                color: AppPallete.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )
            ],
          )
        ]);
  }
}
