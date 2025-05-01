import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:minimal_app/bloc/editavatar_bloc/editavatar_bloc.dart';
import 'package:minimal_app/bloc/editprofile_bloc/editprofile_bloc.dart';
import 'package:minimal_app/bloc/getuserdata_bloc/getuserdata_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widget/button_widget.dart';
import '../../../widget/form_widget.dart';
import '../../../theme.dart';
import '../../../widget_text.dart';

class ProfileSettings extends StatefulWidget {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String birthdate;
  final String gender;
  final String avatar;

  const ProfileSettings({
    super.key,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.gender,
    required this.avatar,
  });

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late TextEditingController _fullnameController;
  String? selectedGender;
  DateTime? selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // ✅ Setel initial value dari widget ke state
    _fullnameController = TextEditingController(text: widget.fullName);
    selectedGender = widget.gender;
    selectedDate = _parseDate(widget.birthdate);
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (_) {
      return null;
    }
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["Male", "Female"].map((gender) {
              return ListTile(
                title: Text(
                  gender,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedGender = gender;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime tempDate = selectedDate ?? DateTime.now();

        return Container(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Your Birthday",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  maximumDate: DateTime.now(),
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  onDateTimeChanged: (DateTime dateTime) {
                    tempDate = dateTime;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, tempDate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(50)
            ],
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditprofileBloc, EditprofileState>(
      listener: (context, state) {
        if (state is EditprofileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            behavior: SnackBarBehavior.floating,
          ));

          // ✅ Kembalikan data terbaru saat navigasi ulang
          Navigator.pop(context);
        } else if (state is EditprofileError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Scaffold(
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
                    top: 90,
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    child: GestureDetector(
                      onTap: _pickImage, // ✅ Pilih gambar dari galeri
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(
                                      _selectedImage!) // ✅ Gunakan gambar yang dipilih
                                  : NetworkImage(widget.avatar)
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .blue, // Warna latar belakang ikon edit
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      onTap: () {
                        if (_selectedImage != null) {
                          context
                              .read<EditavatarBloc>()
                              .add(UploadAvatar(File(_selectedImage!.path)));
                        }
                        print(_dateFormat.format(selectedDate!));
                        print(selectedGender);
                        print(_fullnameController.text);
                        context
                            .read<EditprofileBloc>()
                            .add(EditprofileSubmitted(
                              updatedFields: {
                                "full_name": _fullnameController.text,
                                "gender": selectedGender,
                                "birthdate": _dateFormat.format(selectedDate!)
                              },
                            ));
                        // if (mounted) {
                        //   Navigator.pop(context);
                        // }
                      },
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
                    TxtCustom(
                        tittle: "Username",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(
                      initialValue: widget.username,
                      enabled: false,
                    ),
                    Gap(15),
                    TxtCustom(
                        tittle: "Full Name",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(
                      controller: _fullnameController,
                      initialValue: widget.fullName,
                      enabled: true,
                    ),
                    Gap(15),
                    TxtCustom(
                        tittle: "Email",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(
                      initialValue: widget.email,
                      enabled: false,
                    ),
                    Gap(15),
                    TxtCustom(
                        tittle: "Phone Number",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    InputFormProfile(
                        initialValue: widget.phone, enabled: false),
                    Gap(15),
                    TxtCustom(
                        tittle: "Date of birth",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Select your birthday"
                                  : _dateFormat.format(selectedDate!),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: selectedDate == null
                                    ? Colors.grey
                                    : AppPallete.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(15),
                    TxtCustom(
                        tittle: "Gender",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    GestureDetector(
                      onTap: _showGenderPicker,
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedGender ?? "Select Gender",
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: selectedGender == null
                                    ? Colors.grey
                                    : AppPallete.black,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    Gap(30),
                  ],
                ),
              ),
            ],
          ),
        ),
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
