import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:minimal_app/bloc/deletecart/deletecart_bloc.dart';
import 'package:minimal_app/bloc/getallcart_bloc/getallcart_bloc.dart';
import 'package:minimal_app/models/list_cart_model.dart';
import 'package:minimal_app/screen/order_page/order_page.dart';
import 'package:minimal_app/screen/product_page/product_page.dart';
import 'package:minimal_app/widget/loadingprogress_widget.dart';
import '../../bloc/getcount_bloc/getcount_bloc.dart';
import '../../theme.dart';
import '../../widget_text.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetallcartBloc>().add(Getallcart());
  }

  List<CartDataModel> selectedItems = [];

  void _handleItemSelection(CartDataModel item, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }

  void _handleDeleteItem(CartDataModel item) {
    setState(() {
      selectedItems.remove(item);
      // Tambahkan logika untuk menghapus item dari backend jika diperlukan
    });
  }

  // Hitung total item yang dipilih
  int _calculateSelectedItems() {
    return selectedItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Hitung total harga untuk item yang dipilih
  String _calculateSelectedPrice() {
    double total = selectedItems.fold(0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
    return total.toString(); // Return as plain number string
  }

  void _navigateToOrderPage() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No items selected'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(selectedItems: selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeletecartBloc, DeletecartState>(
      listener: (context, state) {
        if (state is DeletecartLoading) {
          // Tampilkan loading indicator di layer paling atas
          LoadingDialog.show(context);
        } else if (state is DeletecartSuccess) {
          // Tutup dialog loading jika masih terbuka
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item deleted successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<GetcountBloc>().add(GetCount());
          context.read<GetallcartBloc>().add(Getallcart());
        } else if (state is DeletecartError) {
          // Tutup dialog loading jika masih terbuka
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete item'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<GetallcartBloc, GetallcartState>(
        builder: (context, state) {
          if (state is GetallcartSuccess) {
            final cart = state.cartDataModel;
            return Scaffold(
              backgroundColor: AppPallete.whitedefault,
              bottomSheet: CheckoutSection(
                itemCount: _calculateSelectedItems(),
                totalPrice: _calculateSelectedPrice(),
                cartItems: selectedItems,
              ),
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
                  tittle: "Cart",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: AppPallete.whitedefault,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: 80,
                      ),
                      itemCount: cart.length,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Gap(20);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final carts = cart[index];
                        return ProductCart(
                          cartDataModel: carts,
                          onQuantityChanged: (newQuantity) {
                            carts.quantity = newQuantity;
                            setState(() {});
                          },
                          onSelectedChanged: (isSelected) {
                            _handleItemSelection(carts, isSelected);
                          },
                          onDelete: () {
                            _handleDeleteItem(carts);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppPallete.black,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCart extends StatefulWidget {
  final CartDataModel cartDataModel;
  final Function(int) onQuantityChanged;
  final Function(bool) onSelectedChanged;
  final Function() onDelete;

  const ProductCart({
    super.key,
    required this.cartDataModel,
    required this.onQuantityChanged,
    required this.onSelectedChanged,
    required this.onDelete,
  });

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  int localQuantity = 1;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    localQuantity = widget.cartDataModel.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  isSelected = value!;
                });
                widget.onSelectedChanged(value!);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigasi ke halaman detail produk dengan ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductPage(productId: widget.cartDataModel.productId),
                ),
              );
            },
            child: SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.cartDataModel.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Gap(12),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TxtCustom(
                        tittle: widget.cartDataModel.productTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.read<DeletecartBloc>().add(
                                Deletecart(widget.cartDataModel.id),
                              );
                        },
                        splashColor: AppPallete.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svg/cross.svg',
                              color: AppPallete.black,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppPallete.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Color(
                                  int.parse(widget.cartDataModel.colourHex)),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Gap(2),
                          TxtCustom(
                            tittle: widget.cartDataModel.colourName,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                    Gap(5),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppPallete.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          TxtCustom(
                            tittle: "SIZE ${widget.cartDataModel.size}",
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TxtCustom(
                      tittle:
                          "Rp${widget.cartDataModel.price.toStringAsFixed(0).replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                              )}",
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                    // Row(
                    //   children: [
                    //     IconButton(
                    //       icon: Icon(Icons.remove),
                    //       onPressed: () {
                    //         if (localQuantity > 1) {
                    //           setState(() {
                    //             localQuantity--;
                    //           });
                    //           widget.onQuantityChanged(localQuantity);
                    //         }
                    //       },
                    //     ),
                    //     Text(localQuantity.toString()),
                    //     IconButton(
                    //       icon: Icon(Icons.add),
                    //       onPressed: () {
                    //         setState(() {
                    //           localQuantity++;
                    //         });
                    //         widget.onQuantityChanged(localQuantity);
                    //       },
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutSection extends StatelessWidget {
  final int itemCount;
  final String totalPrice;
  final List<CartDataModel> cartItems;

  const CheckoutSection({
    super.key,
    required this.itemCount,
    required this.totalPrice,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
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
          Gap(3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp${double.parse(totalPrice.replaceAll(RegExp(r'[^0-9.]'), '')).toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.',
                        )}",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                color: AppPallete.pink,
                child: InkWell(
                  onTap: () {
                    if (cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No items selected'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    // Panggil fungsi navigasi dari parent widget
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderPage(selectedItems: cartItems),
                      ),
                    );
                    print("Checkout Data:");
                    // print(checkoutData);
                  },
                  splashColor: AppPallete.black.withOpacity(1),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: TxtCustom(
                        tittle: "Checkout ($itemCount)",
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
