import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/api/request_api.dart';
import 'package:minimal_app/bloc/addcart_bloc/addcart_bloc.dart';
import 'package:minimal_app/bloc/getdetailedproduct_bloc/getdetailedproduct_bloc.dart';
import 'package:minimal_app/models/detail_product_model.dart';
import 'package:minimal_app/models/secure_storage_flutter/secure_storage.dart';
import 'package:minimal_app/widget/loadingprogress_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../bloc/getcount_bloc/getcount_bloc.dart';
import '../../model/popular_model.dart';
import '../love_page/love_page.dart';
import '../../theme.dart';
import '../../widget_text.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _currentIndex = 0;
  String? selectedSize;
  String? selectedColor;
  List<String> sizes = [];
  Map<String, List<Map<String, dynamic>>> colorsBySize = {};

  /// ✅ **Fungsi untuk mendapatkan harga berdasarkan size & color yang dipilih**
  int getSelectedVariantPrice(DetailProductDataModel product) {
    var selectedVariant = product.productVariants.firstWhere(
      (variant) =>
          variant.size == selectedSize &&
          variant.colour["hex"] == selectedColor,
      orElse: () => product.productVariants.firstWhere(
        (variant) => variant.stock > 0, // Fallback ke varian dengan stok > 0
        orElse: () => product
            .productVariants.first, // Jika semua habis, pakai varian pertama
      ),
    );

    return selectedVariant.price;
  }

  String getSelectedVariantColor(DetailProductDataModel product) {
    var selectedVariant1 = product.productVariants.firstWhere(
      (variant) =>
          variant.size == selectedSize &&
          variant.colour["hex"] == selectedColor,
      orElse: () => product.productVariants.firstWhere(
        (variant) => variant.stock > 0,
        orElse: () => product.productVariants.first,
      ),
    );

    return selectedVariant1.colour["name"] ?? "Unknown"; // ✅
  }

  ProductVariant? getSelectedVariant(DetailProductDataModel product) {
    if (selectedSize == null || selectedColor == null) return null;

    try {
      return product.productVariants.firstWhere(
        (variant) =>
            variant.size == selectedSize &&
            variant.colour["hex"] == selectedColor,
      );
    } catch (e) {
      return null; // Jika tidak ditemukan
    }
  }

//! Data jumlah review per rating
  Map<int, int> ratings = {
    5: 50,
    4: 4,
    3: 1,
    2: 1,
    1: 20,
  };

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final secureStorageHelper = SecureStorageHelper();
    //!logika
    int totalReviews = ratings.values.reduce((a, b) => a + b);

    // Hitung rata-rata rating
    double averageRating = (5 * ratings[5]! +
            4 * ratings[4]! +
            3 * ratings[3]! +
            2 * ratings[2]! +
            1 * ratings[1]!) /
        totalReviews;

    return BlocProvider(
      create: (context) => GetdetailedproductBloc(
          requestApiHeader: RequestApiHeader(secureStorageHelper))
        ..add(Getdetailproduct(widget.productId)),
      child: BlocListener<AddcartBloc, AddcartState>(
        listener: (context, state) {
          if (state is AddcartLoading) {
            LoadingDialog.show(context);
          } else if (state is AddcartSuccess) {
            // Tutup dialog loading jika masih terbuka
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Add to Cart Success")));
            context.read<GetcountBloc>().add(GetCount());
          } else if (state is AddcartError) {
            // Tutup dialog loading jika masih terbuka
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.error)));
          }
        },
        child: BlocBuilder<GetdetailedproductBloc, GetdetailedproductState>(
          builder: (context, state) {
            if (state is GetdetailedproductSuccess) {
              final product = state.detailProductDataModel;

              // **PERBAIKAN: Gunakan postFrameCallback untuk setState()**
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (sizes.isEmpty) {
                  initializeVariants(product.productVariants);
                }
              });

              return Scaffold(
                backgroundColor: AppPallete.whitedefault,
                bottomNavigationBar: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: AppPallete.whitedefault,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // Rata kiri
                        children: [
                          TxtCustom(
                            tittle:
                                "Rp${getSelectedVariantPrice(product).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.')}",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(), // Tambahkan spacer untuk memisahkan elemen berikutnya
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonWidgetProduct(
                                tittle: "Add to Cart",
                                textcolor: AppPallete.whitedefault,
                                color: AppPallete.black,
                                splashColor: AppPallete.pink,
                                onTap: () {
                                  final selectedVariant =
                                      getSelectedVariant(product);
                                  if (selectedVariant != null) {
                                    context
                                        .read<AddcartBloc>()
                                        .add(AddcartSubmitted(
                                          updatedFields: {
                                            "product_variant_id":
                                                selectedVariant.id,
                                            "quantity": 1,
                                          },
                                        ));
                                  } else {}
                                },
                              ),
                              SizedBox(width: 10), // Jarak antar tombol
                              ButtonWidgetProduct(
                                tittle: "Buy Now",
                                textcolor: AppPallete.whitedefault,
                                color: AppPallete.pink,
                                splashColor: AppPallete.black,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Ini foto
                      Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 450,
                              autoPlay: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            items: product.productImages.map((image) {
                              return Image.network(
                                image.url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            }).toList(),
                          ),

                          // Tombol Back di kiri atas
                          Positioned(
                            top: 40, // Sesuaikan dengan status bar
                            left: 15,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                    context); // Kembali ke halaman sebelumnya
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  'assets/svg/arrow_back.svg',
                                  color: AppPallete.black,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ),

                          // Indicator di bawah
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  product.productImages.length, (index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  width: _currentIndex == index ? 12 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentIndex == index
                                        ? AppPallete.pink
                                        : AppPallete.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "Rp${getSelectedVariantPrice(product)}",
                      //   style: const TextStyle(fontSize: 20, color: Colors.green),
                      // ),

                      Gap(10),
                      //! ini tulisan dan like
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TxtCustom(
                                  tittle: product.category,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                TxtCustom(
                                  tittle: product.title,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite; // Toggle state
                                  });
                                },
                                child: SvgPicture.asset(
                                  isFavorite
                                      ? "assets/svg/love1.svg" // Warna merah (favorit)
                                      : "assets/svg/love.svg", // Warna hitam/abu (bukan favorit)
                                  width: 25,
                                  colorFilter: ColorFilter.mode(
                                    isFavorite
                                        ? AppPallete.pink
                                        : AppPallete.grey,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Gap(10),
                      //!Size
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TxtCustom(
                              tittle: "Size",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            Wrap(
                              spacing: 2, // ✅ Tetap seperti di versi awal kamu
                              children: sizes.map((size) {
                                bool isSelected = selectedSize == size;

                                // Cek apakah size ini semua stoknya habis
                                bool isOutOfStock = product.productVariants
                                    .where((variant) =>
                                        variant.size == size &&
                                        variant.stock > 0)
                                    .isEmpty;

                                return GestureDetector(
                                  onTap: isOutOfStock
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedSize = size;

                                            // Cari warna dengan stok > 0 untuk ukuran ini
                                            String? availableColor;
                                            for (var color
                                                in colorsBySize[size]!) {
                                              if (product.productVariants.any(
                                                  (variant) =>
                                                      variant.size == size &&
                                                      variant.colour["hex"] ==
                                                          color["hex"] &&
                                                      variant.stock > 0)) {
                                                availableColor = color["hex"];
                                                break;
                                              }
                                            }

                                            selectedColor = availableColor ??
                                                (colorsBySize[size]?.contains({
                                                          "hex": selectedColor
                                                        }) ==
                                                        true
                                                    ? selectedColor
                                                    : colorsBySize[size]!
                                                            .isNotEmpty
                                                        ? colorsBySize[size]![0]
                                                            ["hex"]
                                                        : null);
                                          });
                                        },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.red
                                            : Colors.grey,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      color: isOutOfStock
                                          ? Colors.grey.withOpacity(0.5)
                                          : (isSelected
                                              ? AppPallete.pink.withOpacity(0.1)
                                              : Colors.white),
                                    ),
                                    child: Center(
                                      child: Text(
                                        size,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: isOutOfStock
                                              ? Colors.grey
                                              : isSelected
                                                  ? AppPallete.pink
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            Gap(10),
                            //! CHOOSE COLORS
                            Wrap(
                              spacing: 2, // ✅ Tetap sama dengan versi awal kamu
                              children: colorsBySize[selectedSize]
                                      ?.map((color) {
                                    final bool isSelected =
                                        selectedColor == color["hex"];
                                    final bool isOutOfStock = product
                                        .productVariants
                                        .where((variant) =>
                                            variant.size == selectedSize &&
                                            variant.colour["hex"] ==
                                                color["hex"] &&
                                            variant.stock > 0)
                                        .isEmpty;

                                    return GestureDetector(
                                      onTap: isOutOfStock
                                          ? null
                                          : () {
                                              setState(() {
                                                selectedColor = color["hex"];
                                              });
                                            },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppPallete.pink
                                                : AppPallete.whitedefault,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          color: AppPallete.whitedefault,
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(42),
                                              color: isOutOfStock
                                                  ? Colors.grey.withOpacity(0.5)
                                                  : Color(
                                                      int.parse(color["hex"])),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList() ??
                                  [],
                            ),

                            TxtCustom(
                              tittle:
                                  "Color: ${getSelectedVariantColor(product)}",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            Gap(20),
                            //! Detail
                            Column(
                              children: [
                                TittleDetailProduct(
                                  tittle: "Details",
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              top: 40,
                                              left: 20,
                                              right: 20,
                                              bottom: 50),
                                          height: 900,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppPallete.whitedefault,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Text(product.description),
                                        );
                                      },
                                    );
                                  },
                                ),
                                Gap(6),
                                Text(
                                  product.description,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12,
                                      color: AppPallete.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Gap(20),
                            //! RATING
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TittleDetailProduct(
                                  tittle: "Review",
                                  onTap: () {},
                                ),
                                Gap(10),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/star.svg',
                                              width: 20,
                                              height: 20,
                                              color:
                                                  CupertinoColors.systemYellow,
                                            ),
                                            TxtCustom(
                                              tittle: averageRating
                                                  .toStringAsFixed(1),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: AppPallete.black,
                                            )
                                          ],
                                        ),
                                        TxtCustom(
                                          tittle: "231 reviews",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppPallete.grey,
                                        ),
                                      ],
                                    ),
                                    Gap(20),
                                    Expanded(
                                      child: Column(
                                        children: ratings.keys.map((rating) {
                                          double percentage =
                                              ratings[rating]! / totalReviews;

                                          return Row(
                                            children: [
                                              TxtCustom(
                                                tittle: "$rating",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value:
                                                        percentage, // Menggunakan persentase jumlah review
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    color: Colors.black,
                                                    minHeight: 8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Gap(20),
                            //!Produk Serupa
                            Center(
                              child: TxtCustom(
                                tittle: "Recommended for you",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(10),
                            GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics:
                                  NeverScrollableScrollPhysics(), // Agar tidak scroll sendiri
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Jumlah kolom grid
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: listPopular.length, // Jumlah item grid
                              itemBuilder: (context, index) {
                                return SaveProduct(
                                    saveProduct: listPopular[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is GetdetailedproductLoading) {
              return loadingData(context);
            }
            return Center(
              child: Text("Data Error"),
            );
          },
        ),
      ),
    );
  }

  Skeletonizer loadingData(BuildContext context) {
    return Skeletonizer(
        child: Scaffold(
      backgroundColor: Colors.white, // Ganti sesuai palet kamu
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Gambar produk (kosong)
            Stack(
              children: [
                Container(
                  height: 450,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Center(child: Text("Image Carousel")),
                ),
                Positioned(
                  top: 40,
                  left: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white.withOpacity(0.6),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),

            //! Judul dan like
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Product Title",
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.favorite_border),
                ],
              ),
            ),

            const Gap(20),

            //! Ukuran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Size", style: GoogleFonts.jetBrainsMono(fontSize: 14)),
                  const Gap(1),
                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),

                  //! Warna

                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),

                  //! Detail produk
                  TittleDetailProduct(
                    tittle: "Details",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                          padding: const EdgeInsets.all(20),
                          height: 300,
                          child: const Text("Deskripsi produk..."),
                        ),
                      );
                    },
                  ),
                  const Gap(6),
                  Text(
                    "Deskripsi produk singkat...",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.jetBrainsMono(fontSize: 12),
                  ),
                  const Gap(20),

                  //! Rating
                  TittleDetailProduct(
                    tittle: "Review",
                    onTap: () {},
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const Gap(6),
                      Text("4.5",
                          style: GoogleFonts.jetBrainsMono(fontSize: 18)),
                      const Gap(8),
                      Text("(123 reviews)",
                          style: GoogleFonts.jetBrainsMono(fontSize: 12)),
                    ],
                  ),

                  const Gap(30),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void initializeVariants(List<ProductVariant> productVariants) {
    Set<String> allSizes = {};
    Map<String, List<Map<String, dynamic>>> colorMap = {};
    List<String> sizePriority = ["S", "M", "L"]; // Urutan ukuran

    for (var variant in productVariants) {
      allSizes.add(variant.size); // **Simpan semua ukuran**
      colorMap.putIfAbsent(variant.size, () => []);

      if (!colorMap[variant.size]!
          .any((c) => c["hex"] == variant.colour["hex"])) {
        colorMap[variant.size]!.add(variant.colour);
      }
    }

    List<String> sortedSizes = allSizes.toList();
    sortedSizes.sort(
        (a, b) => sizePriority.indexOf(a).compareTo(sizePriority.indexOf(b)));

    // **Cari ukuran pertama yang memiliki stok > 0**
    String? initialSize;
    for (var size in sortedSizes) {
      if (productVariants
          .any((variant) => variant.size == size && variant.stock > 0)) {
        initialSize = size;
        break;
      }
    }
    initialSize ??= sortedSizes.isNotEmpty
        ? sortedSizes[0]
        : null; // Fallback jika semua stok 0

    // **Cari warna pertama dalam ukuran terpilih yang memiliki stok > 0**
    String? initialColor;
    if (initialSize != null && colorMap[initialSize]!.isNotEmpty) {
      for (var color in colorMap[initialSize]!) {
        if (productVariants.any((variant) =>
            variant.size == initialSize &&
            variant.colour["hex"] == color["hex"] &&
            variant.stock > 0)) {
          initialColor = color["hex"];
          break;
        }
      }
    }
    initialColor ??= colorMap[initialSize]?.isNotEmpty == true
        ? colorMap[initialSize]![0]["hex"]
        : null;

    setState(() {
      sizes = sortedSizes; // **Semua ukuran tetap ditampilkan**
      colorsBySize = colorMap; // **Semua warna tetap ditampilkan**
      selectedSize = initialSize;
      selectedColor = initialColor;
    });
  }
}

class ButtonWidgetProduct extends StatelessWidget {
  final String tittle;
  final Color textcolor;
  final Color color;
  final Color splashColor;
  final void Function() onTap;

  const ButtonWidgetProduct({
    super.key,
    required this.tittle,
    required this.textcolor,
    required this.color,
    required this.splashColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: color, // Pindah warna ke sini
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor.withOpacity(1),
        borderRadius: BorderRadius.circular(10), // Radius harus sama
        child: Container(
          height: 40,
          width: 100,
          padding: EdgeInsets.all(10),
          child: Center(
            child: TxtCustom(
              tittle: tittle,
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: textcolor,
            ),
          ),
        ),
      ),
    );
  }
}

class TittleDetailProduct extends StatelessWidget {
  final String tittle;
  final VoidCallback onTap;

  const TittleDetailProduct({
    super.key,
    required this.tittle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          tittle,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppPallete.black,
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, // sesuai UI kamu
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            "View All",
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
