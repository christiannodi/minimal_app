import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/bloc/deleteaddress_bloc/deleteaddress_bloc.dart';
import 'package:minimal_app/bloc/editaddress_bloc/editaddress_bloc.dart';
import 'package:minimal_app/models/list_address_model.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget/form_widget.dart';
import 'package:minimal_app/widget/loadingprogress_widget.dart';
import 'package:minimal_app/widget_text.dart';

class EditaddressPage extends StatefulWidget {
  final AddressDataModel addressDataModel;

  const EditaddressPage({super.key, required this.addressDataModel});

  @override
  State<EditaddressPage> createState() => _EditaddressPageState();
}

class _EditaddressPageState extends State<EditaddressPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _streetController = TextEditingController();
  late TextEditingController _postalcodeController = TextEditingController();
  late TextEditingController _districtController = TextEditingController();
  late TextEditingController _cityController = TextEditingController();
  late TextEditingController _provinceController = TextEditingController();
  late TextEditingController _notesController = TextEditingController();

  late List<bool> _isSelected;
  late String addressType;
  late bool isDefaultAddress; // Untuk switch alamat utama

  @override
  void initState() {
    super.initState();
    // Mengisi nilai awal dari data yang diterima
    _fullnameController =
        TextEditingController(text: widget.addressDataModel.name);
    _phoneController =
        TextEditingController(text: widget.addressDataModel.phone);
    _streetController =
        TextEditingController(text: widget.addressDataModel.address);
    _postalcodeController =
        TextEditingController(text: widget.addressDataModel.postalCode);
    _districtController =
        TextEditingController(text: widget.addressDataModel.district);
    _cityController = TextEditingController(text: widget.addressDataModel.city);
    _provinceController =
        TextEditingController(text: widget.addressDataModel.province);
    _notesController =
        TextEditingController(text: widget.addressDataModel.notes);

    // Menentukan tipe alamat berdasarkan data yang diterima
    addressType = widget.addressDataModel.flag;
    _isSelected = [addressType == "Home", addressType == "Office"];

    // Mengatur status alamat utama
    isDefaultAddress = widget.addressDataModel.isDefault == 1;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteaddressBloc, DeleteaddressState>(
          listener: (context, state) {
            if (state is DeleteaddressLoading) {
              LoadingDialog.show(context);
              // Tampilkan dialog loading saat memproses permintaan)
            } else if (state is DeleteaddressSuccess) {
              // Tutup dialog loading jika masih terbuka
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Delete Address Success")));
              Navigator.pop(context);
            } else if (state is DeleteaddressError) {
              // Tutup dialog loading jika masih terbuka
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.error)));
            }
          },
        ),
        BlocListener<EditaddressBloc, EditaddressState>(
            listener: (context, state) {
          if (state is EditaddressLoading) {
            LoadingDialog.show(context);
            // Tampilkan dialog loading saat memproses permintaan)
          } else if (state is EditaddressSuccess) {
            // Tutup dialog loading jika masih terbuka
            LoadingDialog.hide(context);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Edit Address Success")));

            // ✅ Kembalikan data terbaru saat navigasi ulang
            Navigator.pop(context);
          } else if (state is EditaddressError) {
            // Tutup dialog loading jika masih terbuka
            LoadingDialog.hide(context);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.error)));
          }
        })
      ],
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
                        Positioned(
                          top: 40,
                          right: 15,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: AppPallete.white),
                            onPressed: () async {
                              final shouldDeleteAddress =
                                  await showDialog<bool>(
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
                                          'Delete Address',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Are you sure you want to delete this address?',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                'DELETE',
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

                              if (shouldDeleteAddress == true &&
                                  context.mounted) {
                                context.read<DeleteaddressBloc>().add(
                                      Deleteaddress(widget.addressDataModel.id),
                                    );
                              }
                            },
                            // onPressed: () {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Column(
                            //           children: [
                            //             Icon(Icons.check_circle,
                            //                 color: Colors.green,
                            //                 size: 60), // Icon sukses
                            //             SizedBox(height: 10),
                            //             Text(
                            //                 "Are you sure you want to proceed?",
                            //                 textAlign: TextAlign.center),
                            //           ],
                            //         ),
                            //         actions: [
                            //           ElevatedButton(
                            //             onPressed: () {
                            //               Navigator.pop(
                            //                   context); // Tutup dialog
                            //               // Jalankan event delete
                            //               context.read<DeleteaddressBloc>().add(
                            //                     Deleteaddress(
                            //                         widget.addressDataModel.id),
                            //                   );
                            //             },
                            //             child: Text("Yes, proceed"),
                            //           ),
                            //           ElevatedButton(
                            //             onPressed: () {
                            //               Navigator.pop(
                            //                   context); // Tutup dialog
                            //             },
                            //             child: Text("Close",
                            //                 style:
                            //                     TextStyle(color: Colors.grey)),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // },
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
                                  controller: _notesController,
                                  tittle: "Notes",
                                  hinttext: "If you have a note, tell us",
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
                          print("Updated Address Type: ");
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
                          context.read<EditaddressBloc>().add(Editaddress(
                                addressId: widget.addressDataModel.id,
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
                                  "flag": addressType
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
