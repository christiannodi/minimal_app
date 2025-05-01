import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/bloc/getorder_bloc/getorder_bloc.dart';
import 'package:minimal_app/bloc/paynow_bloc/paynow_bloc.dart';
import 'package:minimal_app/models/list_order_model.dart';
import 'package:minimal_app/widget_text.dart';

import '../../../bloc/getcount_bloc/getcount_bloc.dart';
import '../../../theme.dart';
import '../../../widget/loadingprogress_widget.dart';

class MustpayPage extends StatefulWidget {
  const MustpayPage({super.key});

  @override
  State<MustpayPage> createState() => _MustpayPageState();
}

class _MustpayPageState extends State<MustpayPage> {
  @override
  void initState() {
    super.initState();

    // ✅ Hanya fetch jika state belum ada
    context.read<GetorderBloc>().add(Getorder());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaynowBloc, PaynowState>(
      listener: (context, state) {
        if (state is PaynowSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.read<GetorderBloc>().add(Getorder());
          context.read<GetcountBloc>().add(GetCount());
        } else if (state is PaynowLoading) {
          LoadingDialog.show(context);
        } else if (state is PaynowError) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to pay item'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.white,
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
            tittle: "Must Pay",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppPallete.whitedefault,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<GetorderBloc, GetorderState>(
            builder: (context, state) {
              if (state is GetorderSuccess) {
                final listOrders =
                    state.orderListDataModel; // Ambil list produk

                return SizedBox(
                  child: ListView.separated(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: listOrders.length,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Gap(10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final listOrder = listOrders[index];
                      return OrderList(
                        orderListDataModel: listOrder,
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final OrderListDataModel orderListDataModel;

  const OrderList({
    super.key,
    required this.orderListDataModel,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice =
        orderListDataModel.price + orderListDataModel.shippingCost + 10000;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.whitedefault,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppPallete.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TxtCustom(
                  tittle: "Order #${orderListDataModel.id}",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                TxtCustom(
                  tittle: "Pending",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.pink,
                ),
              ],
            ),
            Gap(10),
            Column(
              children: orderListDataModel.orderItems.map((item) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    // Gunakan Image.network untuk load dari URL
                                    item.thumbnail,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Gap(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TxtCustom(
                                      tittle: item.title,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Gap(4),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppPallete.greywhite,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                              color: Color(int.parse(item
                                                  .colourHex
                                                  .replaceFirst("0x", "0xFF"))),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          Gap(2),
                                          TxtCustom(
                                            tittle:
                                                item.colourName.toUpperCase(),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(4),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppPallete.greywhite,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TxtCustom(
                                        tittle: "SIZE S",
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Gap(4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TxtCustom(
                          tittle:
                              "Rp ${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ));
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
                      "Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            Gap(8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  context
                      .read<PaynowBloc>()
                      .add(Paynow(orderListDataModel.id, {"status": "Paid"}));
                },
                child: Container(
                  height: 30,
                  width: 87,
                  decoration: BoxDecoration(
                    color: AppPallete.pink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Container(
                      height: 28,
                      width: 85,
                      decoration: BoxDecoration(
                        color: AppPallete.whitedefault,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: TxtCustom(
                          tittle: "Pay Now",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.pink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
