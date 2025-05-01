import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/bloc/addaddress_bloc/addaddress_bloc.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget/form_widget.dart';
import 'package:minimal_app/widget/loadingprogress_widget.dart';
import 'package:minimal_app/widget_text.dart';

class AddaddressPage extends StatefulWidget {
  const AddaddressPage({super.key});

  @override
  State<AddaddressPage> createState() => _AddaddressPageState();
}

class _AddaddressPageState extends State<AddaddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalcodeController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<bool> _isSelected = [true, false]; // Default "Home"
  String addressType = "Home";
  bool isDefaultAddress = true; // Default bukan alamat utama

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddaddressBloc, AddaddressState>(
      listener: (context, state) {
        if (state is AddaddressLoading) {
          LoadingDialog.show(context);
        } else if (state is AddaddressSuccess) {
          // Tutup dialog loading jika masih terbuka
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Add Address Success")));

          // ✅ Kembalikan data terbaru saat navigasi ulang
          Navigator.pop(context);
        } else if (state is AddaddressError) {
          // Tutup dialog loading jika masih terbuka
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating, content: Text(state.error)));
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.black,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
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
                              tittle: "New Address",
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
                    Column(
                      children: [
                        Container(
                          color: AppPallete.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TxtCustom(
                                    tittle: "Address",
                                    fontSize: 12,
                                  ),
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "Name",
                                  hinttext: "Enter your name",
                                  controller: _fullnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "Phone Number",
                                  hinttext: "Enter your phone number",
                                  controller: _phoneController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Phone number cannot be empty";
                                    }
                                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return "Only numbers are allowed";
                                    }

                                    if (value.length < 8) {
                                      return "Phone number must be at least 8 digits";
                                    }
                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "Street Name",
                                  hinttext: "Enter your street name",
                                  controller: _streetController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "District",
                                  hinttext: "Enter your district",
                                  controller: _districtController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "City",
                                  hinttext: "Enter your city",
                                  controller: _cityController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "Province",
                                  hinttext: "Enter your province",
                                  controller: _provinceController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "Postal Code",
                                  hinttext: "Enter your postal code",
                                  controller: _postalcodeController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Postal code cannot be empty";
                                    }
                                    if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                                      return "Postal code must be exactly 5 digits";
                                    }
                                    return null;
                                  },
                                ),
                                Gap(10),
                                InputFormAddress(
                                  tittle: "Notes",
                                  hinttext: "If you have a note, tell us",
                                  controller: _notesController,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(alignment: Alignment.topCenter, children: [
                      Container(
                        height: 25,
                        color: AppPallete.black,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppPallete.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 20),
                      ),
                    ]),
                    Stack(alignment: Alignment.bottomCenter, children: [
                      Container(
                        height: 25,
                        color: AppPallete.black,
                      ),
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
                    ]),
                    Container(
                      color: AppPallete.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TxtCustom(
                                  tittle: "Set as Primary Address",
                                  fontSize: 12,
                                ),
                                Switch(
                                  value: isDefaultAddress,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      isDefaultAddress = newValue;
                                    });
                                  },
                                  activeColor: AppPallete.black,
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: AppPallete.grey,
                            ),
                            Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TxtCustom(
                                  tittle: "Mark As",
                                  fontSize: 12,
                                ),
                                ToggleButtons(
                                  isSelected: _isSelected,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int i = 0;
                                          i < _isSelected.length;
                                          i++) {
                                        _isSelected[i] = (i == index);
                                      }
                                      addressType =
                                          index == 0 ? "Home" : "Office";
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  borderWidth: 1.5,
                                  borderColor: Colors.grey,
                                  selectedBorderColor: Colors.red,
                                  selectedColor: Colors.red,
                                  color: Colors.grey,
                                  fillColor: Colors.transparent,
                                  constraints: BoxConstraints(minHeight: 30),
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 20, // Atur tinggi tombol
                                      alignment: Alignment.center,
                                      child: Text("Home",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 20, // Atur tinggi tombol
                                      alignment: Alignment.center,
                                      child: Text("Office",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: AppPallete.grey,
                            ),
                            Gap(5),
                          ],
                        ),
                      ),
                    ),
                    Stack(alignment: Alignment.topCenter, children: [
                      Container(
                        height: 40,
                        color: AppPallete.black,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppPallete.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 20),
                      ),
                    ]),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          print("Updated Address Type: $addressType");
                          print(
                              "Is Default Address: ${isDefaultAddress ? 1 : 0}");
                          print("Name: ${_fullnameController.text}");
                          print("Phone: ${_phoneController.text}");
                          print("Address: ${_streetController.text}");
                          print("Postal Code: ${_postalcodeController.text}");
                          print("District: ${_districtController.text}");
                          print("City: ${_cityController.text}");
                          print("Province: ${_provinceController.text}");
                          print("Notes: ${_notesController.text}");
                          context
                              .read<AddaddressBloc>()
                              .add(AddaddressSubmitted(
                                updatedFields: {
                                  "name": _fullnameController.text,
                                  "phone": _phoneController.text,
                                  "address": _streetController.text,
                                  "postal_code": _postalcodeController.text,
                                  "district": _districtController.text,
                                  "city": _cityController.text,
                                  "province": _provinceController.text,
                                  "notes": _notesController.text,
                                  "is_default": isDefaultAddress ? 1 : 0,
                                  "flag": addressType,
                                },
                              ));
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            color: AppPallete.pink,
                            borderRadius: BorderRadius.circular(10)),
                        child: Align(
                          alignment: Alignment.center,
                          child: TxtCustom(
                            tittle: "SAVE ADDRESS",
                            color: AppPallete.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Gap(50),
                    Flexible(
                        child: Container(
                      color: AppPallete.black,
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
