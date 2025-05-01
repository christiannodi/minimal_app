import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:minimal_app/bloc/editprofile_bloc/editprofile_bloc.dart';
import 'package:minimal_app/bloc/getuserdata_bloc/getuserdata_bloc.dart';
import 'package:minimal_app/widget/loadingprogress_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widget/button_widget.dart';
import '../../../widget/form_widget.dart';
import '../../../theme.dart';
import '../../../widget_text.dart';

class EditavatarPage extends StatefulWidget {
  const EditavatarPage({super.key});

  @override
  State<EditavatarPage> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<EditavatarPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditprofileBloc, EditprofileState>(
      listener: (context, state) {
        if (state is EditprofileLoading) {
          LoadingDialog.show(context);
        } else if (state is EditprofileSuccess) {
          // Tutup dialog loading jika masih terbuka
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Edit Success")));

          // ✅ Kembalikan data terbaru saat navigasi ulang
          Navigator.pop(context);
        } else if (state is EditprofileError) {
          // Tutup dialog loading jika masih terbuka
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating, content: Text(state.error)));
        }
      },
      child: BlocBuilder<GetuserdataBloc, GetuserdataState>(
        builder: (context, state) {
          if (state is GetuserdataLoading) {
            return loadingShimmer(context);
          }
          if (state is GetuserdataSuccess) {
            return Scaffold(
              backgroundColor: AppPallete.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 210,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/png/bg.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            const TxtCustom(
                              tittle: "Edit Profile",
                              color: AppPallete.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 40),
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
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage:
                                  NetworkImage(state.userDataModel.avatar),
                            ),
                          ),
                          Gap(30),
                          TxtCustom(
                              tittle: "Username",
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          InputFormProfile(
                            initialValue: state.userDataModel.username,
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text("Load Error"));
        },
      ),
    );
  }

  Skeletonizer loadingShimmer(BuildContext context) {
    return Skeletonizer(
        enabled: true,
        child: Scaffold(
          backgroundColor: AppPallete.white,
          body: Center(child: CircularProgressIndicator()),
        ));
  }
}
