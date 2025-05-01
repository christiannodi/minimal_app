import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/bloc/getshippingcost_bloc/getshippingcost_bloc.dart';
import 'package:minimal_app/models/list_address_model.dart';
import 'package:minimal_app/models/list_cart_model.dart';
import 'package:minimal_app/models/list_shippingcost_model.dart';
import 'package:minimal_app/screen/order_page/order_success.dart';
import 'package:minimal_app/screen/profile_page/screen/address_page/addaddress_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/addaddress_bloc/addaddress_bloc.dart';
import '../../bloc/addorder_bloc/addorder_bloc.dart';
import '../../bloc/deleteaddress_bloc/deleteaddress_bloc.dart';
import '../../bloc/editaddress_bloc/editaddress_bloc.dart';
import '../../bloc/getalladdress_bloc/getalladdress_bloc_bloc.dart';
import '../../bloc/getcount_bloc/getcount_bloc.dart';
import '../../widget/loadingprogress_widget.dart';

class OrderPage extends StatefulWidget {
  final List<CartDataModel> selectedItems;

  const OrderPage({
    super.key,
    required this.selectedItems,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class CartItem {
  final int productVariantId;
  final int quantity;

  CartItem({
    required this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_variant_id': productVariantId,
      'quantity': quantity,
    };
  }
}

class _OrderPageState extends State<OrderPage> {
  int? selectedAddressId;
  String? selectedPostalCode;
  String? selectedCourier;
  String? selectedCourierCode;
  String? selectedService;
  String? selectedEtd;
  String? selectedDescription;
  String? selectedShippingCost;

  ShippingcostDataModel? selectedShippingOption; // Tambahkan di State
  List<CartItem> selectedItems = [];

  int get totalPayment {
    final subtotal = widget.selectedItems
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
    final shippingCost = int.tryParse(selectedShippingCost ?? '0') ?? 0;
    const adminFee = 10000; // Biaya admin tetap
    return subtotal + shippingCost + adminFee;
  }

  @override
  void initState() {
    super.initState();
    selectedItems = widget.selectedItems.map((item) {
      return CartItem(
        productVariantId: item.productVariantId,
        quantity: item.quantity,
      );
    }).toList();
    context.read<GetalladdressBloc>().add(Getalladdress());
    context.read<GetshippingcostBloc>().add(GetshippingcostSubmitted(
          updatedFields: {
            "postal_code": selectedPostalCode,
            "weight": 1,
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.selectedItems.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });

    return BlocListener<AddorderBloc, AddorderState>(
      listener: (context, state) {
        if (state is AddorderLoading) {
          LoadingDialog.show(context);
        } else if (state is AddorderSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
          Navigator.pop(context);
          context.read<GetcountBloc>().add(GetCount());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrderSuccess()));
        } else if (state is AddorderError) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to order item'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.whitedefault,
        bottomSheet: bottomSheet(),
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/svg/arrow_back.svg',
              color: AppPallete.black,
              height: 30,
              width: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: TxtCustom(
            tittle: "Order",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppPallete.whitedefault,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                MultiBlocListener(
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
                      if (state is GetalladdressLoading) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppPallete.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TxtCustom(
                                      tittle: "Shipiing Address",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Gap(4),
                                    Skeletonizer(
                                      enabled: true,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              TxtCustom(
                                                tittle: "Kristian Nodi Aditria",
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
                                                tittle: "0822-4293-6628",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                          TxtCustom(
                                            tittle:
                                                "Jalan Karya Barat 1 No 19 16, Rt 8/Rw 3",
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color: AppPallete.grey,
                                          ),
                                          TxtCustom(
                                            tittle:
                                                "GROGOL PETAMBURAN, KOTA JAKARTA BARAT ",
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                            color: AppPallete.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is GetalladdressSuccess) {
                        final addresses = state.addressDataModel;

                        // Check if addresses is empty
                        if (addresses.isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddaddressPage()));
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppPallete.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TxtCustom(
                                          tittle: "Shipiing Address",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Gap(4),
                                        TxtCustom(
                                          tittle:
                                              "No Addres Found, Please Add Address Here",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppPallete.pink,
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(
                                      'assets/svg/arrow.svg',
                                      color: AppPallete.black,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // Set default selected address
                        if (selectedAddressId == null) {
                          selectedAddressId = addresses
                              .firstWhere((address) => address.isDefault == 1)
                              .id;
                          selectedPostalCode = addresses
                              .firstWhere(
                                  (address) => address.id == selectedAddressId)
                              .postalCode;

                          context
                              .read<GetshippingcostBloc>()
                              .add(GetshippingcostSubmitted(
                                updatedFields: {
                                  "postal_code": selectedPostalCode,
                                  "weight": 1,
                                },
                              ));
                        }

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _showAddressBottomSheet(context, addresses),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppPallete.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TxtCustom(
                                            tittle: "Shipiing Address",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          Gap(4),
                                          Row(
                                            children: [
                                              TxtCustom(
                                                tittle: addresses
                                                    .firstWhere((address) =>
                                                        address.id ==
                                                        selectedAddressId)
                                                    .name,
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
                                                tittle: addresses
                                                    .firstWhere((address) =>
                                                        address.id ==
                                                        selectedAddressId)
                                                    .phone,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                          TxtCustom(
                                            tittle:
                                                "${addresses.firstWhere((address) => address.id == selectedAddressId).address}, ${addresses.firstWhere((address) => address.id == selectedAddressId).notes}",
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color: AppPallete.grey,
                                          ),
                                          TxtCustom(
                                            tittle:
                                                "${addresses.firstWhere((address) => address.id == selectedAddressId).district}, ${addresses.firstWhere((address) => address.id == selectedAddressId).city}, ${addresses.firstWhere((address) => address.id == selectedAddressId).province}, ${addresses.firstWhere((address) => address.id == selectedAddressId).postalCode}",
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                            color: AppPallete.grey,
                                          ),
                                        ],
                                      ),
                                      SvgPicture.asset(
                                        'assets/svg/arrow.svg',
                                        color: AppPallete.black,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Container(
                        child: TxtCustom(
                          tittle: "Data Error",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                Gap(12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppPallete.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TxtCustom(
                          tittle: "Items (${widget.selectedItems.length})",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(10),
                        Column(
                          children: widget.selectedItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              item.thumbnail,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Gap(10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TxtCustom(
                                                tittle: item.productTitle,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Gap(4),
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: AppPallete.greywhite,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 9,
                                                      width: 9,
                                                      decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            item.colourHex)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                    ),
                                                    Gap(2),
                                                    TxtCustom(
                                                      tittle: item.colourName
                                                          .toUpperCase(),
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Gap(4),
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: AppPallete.greywhite,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: TxtCustom(
                                                  tittle: "SIZE ${item.size}",
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Gap(4),
                                              TxtCustom(
                                                tittle: "Qty: ${item.quantity}",
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TxtCustom(
                                    tittle:
                                        "Rp${(item.price * item.quantity).toStringAsFixed(0).replaceAllMapped(
                                              RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                              (Match m) => '${m[1]}.',
                                            )}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Gap(5),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppPallete.greywhite,
                        ),
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TxtCustom(tittle: "Total Price", fontSize: 12),
                            Gap(20),
                            TxtCustom(
                              tittle:
                                  "Rp${totalPrice.toStringAsFixed(0).replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]}.',
                                      )}",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(12),
                BlocBuilder<GetshippingcostBloc, GetshippingcostState>(
                  builder: (context, state) {
                    if (state is GetshippingcostLoading) {
                      return _buildShippingOptionSkeleton();
                    }
                    if (state is GetshippingcostSuccess) {
                      final shippingOptions = state.shippingcostDataModel;
                      if (shippingOptions.isEmpty) {
                        return _buildNoShippingOption();
                      }
                      final displayOption =
                          selectedShippingOption ?? shippingOptions[0];
                      selectedCourier = displayOption.name;
                      selectedCourierCode = displayOption.code;
                      selectedService = displayOption.service;
                      selectedEtd = displayOption.etd;
                      selectedDescription = displayOption.description;
                      selectedShippingCost = displayOption.cost.toString();

                      return GestureDetector(
                        onTap: () => _showShippingOptionsBottomSheet(
                            context, shippingOptions),
                        child: _buildShippingOptionCard(
                          courier: displayOption.name,
                          service: displayOption.service,
                          etd: displayOption.etd,
                          cost: displayOption.cost,
                        ),
                      );
                    }
                    if (state is GetshippingcostError) {
                      return _buildShippingError(state.error);
                    }
                    return Container(
                      child: TxtCustom(tittle: "No Data"),
                    );
                  },
                ),
                Gap(12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppPallete.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TxtCustom(
                          tittle: "Payment Details",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TxtCustom(
                              tittle: "Subtotal for Products",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            BlocBuilder<GetshippingcostBloc,
                                GetshippingcostState>(
                              builder: (context, state) {
                                if (state is GetshippingcostLoading) {
                                  Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                if (state is GetshippingcostSuccess) {
                                  return TxtCustom(
                                    tittle:
                                        "Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(
                                              RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                              (Match m) => '${m[1]}.',
                                            )}",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  );
                                }
                                if (state is GetshippingcostError) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                return Skeletonizer(
                                  enabled: true,
                                  child: TxtCustom(
                                    tittle: "Counting...",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TxtCustom(
                              tittle: "Subtotal Shipping",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            BlocBuilder<GetshippingcostBloc,
                                GetshippingcostState>(
                              builder: (context, state) {
                                if (state is GetshippingcostLoading) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                if (state is GetshippingcostSuccess) {
                                  final shippingOptions =
                                      state.shippingcostDataModel;
                                  if (shippingOptions.isEmpty) {
                                    return TxtCustom(
                                      tittle: "No shipping options available",
                                      fontSize: 12,
                                      color: AppPallete.grey,
                                    );
                                  }
                                  final displayOption =
                                      selectedShippingOption ??
                                          shippingOptions[0];
                                  selectedCourier = displayOption.name;
                                  selectedCourierCode = displayOption.code;
                                  selectedService = displayOption.service;
                                  selectedEtd = displayOption.etd;
                                  selectedDescription =
                                      displayOption.description;
                                  selectedShippingCost =
                                      displayOption.cost.toString();

                                  return TxtCustom(
                                    tittle:
                                        "Rp ${displayOption.cost.toStringAsFixed(0).replaceAllMapped(
                                              RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                              (Match m) => '${m[1]}.',
                                            )}",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppPallete.black,
                                  );
                                }
                                if (state is GetshippingcostError) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                return Skeletonizer(
                                  enabled: true,
                                  child: TxtCustom(
                                    tittle: "Counting...",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TxtCustom(
                              tittle: "Admin Fee",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            BlocBuilder<GetshippingcostBloc,
                                GetshippingcostState>(
                              builder: (context, state) {
                                if (state is GetshippingcostLoading) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                if (state is GetshippingcostSuccess) {
                                  return TxtCustom(
                                    tittle: "Rp 10.000",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppPallete.black,
                                  );
                                }
                                if (state is GetshippingcostError) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                return Skeletonizer(
                                  enabled: true,
                                  child: TxtCustom(
                                    tittle: "Counting...",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Gap(3),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppPallete.greywhite,
                        ),
                        Gap(2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TxtCustom(
                              tittle: "Total Payment",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            BlocBuilder<GetshippingcostBloc,
                                GetshippingcostState>(
                              builder: (context, state) {
                                if (state is GetshippingcostLoading) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }
                                if (state is GetshippingcostSuccess) {
                                  final shippingOptions =
                                      state.shippingcostDataModel;
                                  if (shippingOptions.isEmpty) {
                                    return TxtCustom(
                                      tittle: "No shipping options available",
                                      fontSize: 12,
                                      color: AppPallete.grey,
                                    );
                                  }
                                  // final displayOption = selectedShippingOption ??
                                  //     shippingOptions[0];
                                  // selectedCourier = displayOption.name;
                                  // selectedCourierCode = displayOption.code;
                                  // selectedService = displayOption.service;
                                  // selectedEtd = displayOption.etd;
                                  // selectedDescription = displayOption.description;
                                  // selectedShippingCost =
                                  //     displayOption.cost.toString();

                                  return TxtCustom(
                                    tittle:
                                        "Rp${totalPayment.toStringAsFixed(0).replaceAllMapped(
                                              RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                              (Match m) => '${m[1]}.',
                                            )}",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppPallete.black,
                                  );
                                }
                                if (state is GetshippingcostError) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: TxtCustom(
                                      tittle: "Counting...",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }
                                return Skeletonizer(
                                  enabled: true,
                                  child: TxtCustom(
                                    tittle: "Counting...",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show BottomSheet for selecting address
  // Show BottomSheet for selecting address
  void _showAddressBottomSheet(
      BuildContext context, List<AddressDataModel> addresses) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppPallete.whitedefault,
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.9, // Maksimal 90% dari tinggi layar
        minHeight: 0, // Minimum height
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Mengatur ukuran kolom
            children: [
              Text(
                "Select Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Hapus Expanded dan atur shrinkWrap pada ListView
              ListView.builder(
                shrinkWrap:
                    true, // Penting: membuat ListView hanya mengambil ruang yang dibutuhkan
                physics:
                    NeverScrollableScrollPhysics(), // Nonaktifkan scroll individual
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final addressModel = addresses[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAddressId = addressModel.id;
                        selectedPostalCode = addressModel.postalCode;
                      });
                      context
                          .read<GetshippingcostBloc>()
                          .add(GetshippingcostSubmitted(
                            updatedFields: {
                              "postal_code": selectedPostalCode,
                              "weight": 1,
                            },
                          ));

                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppPallete.whitedefault,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            tittle:
                                "${addressModel.address}, ${addressModel.notes}",
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
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddaddressPage()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppPallete.white,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildShippingOptionSkeleton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TxtCustom(
                  tittle: "Shipping Options",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                Gap(4),
                Skeletonizer(
                  enabled: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TxtCustom(
                        tittle: "Loading courier...",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      TxtCustom(
                        tittle: "Loading service...",
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: AppPallete.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Skeletonizer(
              enabled: true,
              child: Row(
                children: [
                  TxtCustom(
                    tittle: "Rp...",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SvgPicture.asset(
                    'assets/svg/arrow.svg',
                    color: AppPallete.black,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoShippingOption() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TxtCustom(
              tittle: "Shipping Options",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            Gap(4),
            TxtCustom(
              tittle: "No shipping options available",
              fontSize: 12,
              color: AppPallete.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingError(String message) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TxtCustom(
              tittle: "Shipping Options",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            Gap(4),
            TxtCustom(
              tittle: "Please select an address",
              fontSize: 12,
              color: AppPallete.pink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingOptionCard({
    required String courier,
    required String service,
    required String etd,
    required int cost,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppPallete.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TxtCustom(
                          tittle: "Shipping Options",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap(4),
                        TxtCustom(
                          tittle: courier,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        TxtCustom(
                          tittle: "$service - Est $etd day",
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: AppPallete.grey,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TxtCustom(
                          tittle: "Rp${cost.toStringAsFixed(0).replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                              )}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppPallete.black,
                        ),
                        SvgPicture.asset(
                          'assets/svg/arrow.svg',
                          color: AppPallete.black,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showShippingOptionsBottomSheet(
    BuildContext context,
    List<ShippingcostDataModel> options,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppPallete.whitedefault,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TxtCustom(
                tittle: "Select Shipping Option",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: TxtCustom(
                        tittle: "${option.name} - ${option.service}",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      subtitle: TxtCustom(
                        tittle:
                            "Est ${option.etd} day - Rp${option.cost.toStringAsFixed(0).replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]}.',
                                )}",
                        fontSize: 12,
                        color: AppPallete.grey,
                      ),
                      onTap: () {
                        setState(() {
                          selectedShippingOption =
                              option; // Simpan opsi yang dipilih
                          selectedCourier = option.name;
                          selectedCourierCode = option.code;
                          selectedService = option.service;
                          selectedEtd = option.etd;
                          selectedDescription = option.description;
                          selectedShippingCost = option.cost.toString();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container bottomSheet() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<GetshippingcostBloc, GetshippingcostState>(
                    builder: (context, state) {
                      if (state is GetshippingcostLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: TxtCustom(
                            tittle: "Counting...",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }
                      if (state is GetshippingcostSuccess) {
                        // final shippingOptions = state.shippingcostDataModel;
                        // if (shippingOptions.isEmpty) {
                        //   return Container();
                        // }

                        return TxtCustom(
                          tittle:
                              "Rp${totalPayment.toStringAsFixed(0).replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]}.',
                                  )}",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        );
                      }
                      if (state is GetshippingcostError) {
                        return Container();
                      }
                      return Container();
                    },
                  ),
                ],
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                color: AppPallete.pink,
                child: InkWell(
                  onTap: () {
                    if (selectedAddressId != null &&
                        selectedPostalCode != null) {
                      // print("Selected Address ID: $selectedAddressId");
                      // print("Selected Postal Code: $selectedPostalCode");
                      // print(
                      //     selectedItems.map((item) => item.toJson()).toList());
                      // print("Selected Courier: $selectedCourier");
                      // print("Selected Courier Code: $selectedCourierCode");
                      // print("Selected Service: $selectedService");
                      // print("Selected ETD: $selectedEtd");
                      // print("Selected Description: $selectedDescription");
                      // print("Selected Shipping Cost: $selectedShippingCost");

                      context.read<AddorderBloc>().add(AddorderSubmitted(
                            updatedFields: {
                              "address_id": selectedAddressId,
                              "postal_code": selectedPostalCode,
                              "weight": 1,
                              "items": selectedItems
                                  .map((item) => item.toJson())
                                  .toList(),
                              "shipping": {
                                "name": selectedCourier,
                                "code": selectedCourierCode,
                                "service": selectedService,
                                "description": selectedDescription,
                                "etd": selectedEtd
                              }
                            },
                          ));
                    } else {
                      print("No address selected");
                    }
                  },
                  splashColor: AppPallete.black.withOpacity(1),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: TxtCustom(
                        tittle: "Order ",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppPallete.whitedefault,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class OrderSection extends StatelessWidget {
//   final int totalPayment;

//   const OrderSection({
//     super.key,
//     required this.totalPayment,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 1,
//             color: Colors.grey.shade300,
//           ),
//           Gap(3),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   BlocBuilder<GetshippingcostBloc, GetshippingcostState>(
//                     builder: (context, state) {
//                       if (state is GetshippingcostLoading) {
//                         return Skeletonizer(
//                           enabled: true,
//                           child: TxtCustom(
//                             tittle: "Counting...",
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         );
//                       }
//                       if (state is GetshippingcostSuccess) {
//                         // final shippingOptions = state.shippingcostDataModel;
//                         // if (shippingOptions.isEmpty) {
//                         //   return Container();
//                         // }

//                         return TxtCustom(
//                           tittle:
//                               "Rp${totalPayment.toStringAsFixed(0).replaceAllMapped(
//                                     RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//                                     (Match m) => '${m[1]}.',
//                                   )}",
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         );
//                       }
//                       if (state is GetshippingcostError) {
//                         return Container();
//                       }
//                       return Container();
//                     },
//                   ),
//                 ],
//               ),
//               Material(
//                 borderRadius: BorderRadius.circular(10),
//                 color: AppPallete.pink,
//                 child: InkWell(
//                   onTap: () {},
//                   splashColor: AppPallete.black.withOpacity(1),
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                     height: 40,
//                     width: 150,
//                     padding: EdgeInsets.all(10),
//                     child: Center(
//                       child: TxtCustom(
//                         tittle: "Order ",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                         color: AppPallete.whitedefault,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
