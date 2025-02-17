import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/model/popular_model.dart';
import 'package:minimal_app/screen/love_page/love_page.dart';
import 'package:minimal_app/theme.dart';
import 'package:minimal_app/widget_text.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
//! Data jumlah review per rating
  Map<int, int> ratings = {
    5: 50,
    4: 4,
    3: 1,
    2: 1,
    1: 20,
  };

  // Hitung total review

  //!description
  String description = """
- Versatile stand collar design can be worn as an inner or outer layer.
- Unisex design.

Product ID: 476521
Please note that this product may have different product ID, even if it is the same item.

Fabric Details:
Shell: 100% Nylon
Lining: 100% Polyester
Pocket Lining: 100% Polyester

Function Details:
- Fit: Relaxed
- Pockets: With Pockets

Washing Instructions:
- Hand wash cold
- Do not Dry Clean
- Do not tumble dry

The images shown may include colors that are not available.
""";

  //!Size
  List<String> sizes = ["XS", "S", "M", "L", "XL"];
  int selectedSizeIndex = 0; // Default memilih 'S'
  //!colors
  List<int> colors = [0xFF2F2E33, 0xFF5D553E, 0xFF4C6373];
  List<String> colorNames = ["02 Black", "62 Coklat", "42 Biru"];
  int selectedColorIndex = 0; // Default memilih 'S'
  int _currentIndex = 0;
  List<String> imageList = [
    "assets/png/product/product1.png",
    "assets/png/product/product2.png",
    "assets/png/product/product3.png",
    "assets/png/product/product4.png",
    "assets/png/product/product5.png",
  ];
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    //!logika
    int totalReviews = ratings.values.reduce((a, b) => a + b);

    // Hitung rata-rata rating
    double averageRating = (5 * ratings[5]! +
            4 * ratings[4]! +
            3 * ratings[3]! +
            2 * ratings[2]! +
            1 * ratings[1]!) /
        totalReviews;

    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
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
                  items: imageList.map((imagePath) {
                    return Image.asset(
                      imagePath,
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
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
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
                    children: List.generate(imageList.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
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
                        tittle: "Upper",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      TxtCustom(
                        tittle: "Windproof Vest",
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
                          isFavorite ? AppPallete.pink : AppPallete.grey,
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
                    spacing: 8, // Jarak antar tombol
                    children: List.generate(
                      sizes.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSizeIndex = index;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedSizeIndex == index
                                  ? Colors.red
                                  : Colors.grey,
                              width: selectedSizeIndex == index ? 2 : 1,
                            ),
                            color: selectedSizeIndex == index
                                ? AppPallete.pink.withOpacity(0.1)
                                : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              sizes[index],
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: selectedSizeIndex == index
                                    ? AppPallete.pink
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  //! CHOOSE COLORS
                  Wrap(
                    spacing: 2, // Jarak antar tombol
                    children: List.generate(
                      colors.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorIndex = index;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: selectedColorIndex == index
                                    ? AppPallete.pink
                                    : AppPallete.whitedefault,
                                width: selectedColorIndex == index ? 2 : 1,
                              ),
                              color: AppPallete.whitedefault),
                          child: Center(
                            child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42),
                                  color: Color(colors[index]),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TxtCustom(
                    tittle: "Color: ${colorNames[selectedColorIndex]}",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  Gap(20),
                  //! Detail
                  Column(
                    children: [
                      TittleDetailProduct(tittle: "Details"),
                      Gap(6),
                      Text(
                        description,
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
                      TittleDetailProduct(tittle: "Review"),
                      Gap(10),
                      Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/star.svg',
                                    width: 20,
                                    height: 20,
                                    color: CupertinoColors.systemYellow,
                                  ),
                                  TxtCustom(
                                    tittle: averageRating.toStringAsFixed(1),
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
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value:
                                              percentage, // Menggunakan persentase jumlah review
                                          backgroundColor: Colors.grey.shade300,
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Jumlah kolom grid
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: listPopular.length, // Jumlah item grid
                    itemBuilder: (context, index) {
                      return SaveProduct(saveProduct: listPopular[index]);
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
}

class TittleDetailProduct extends StatelessWidget {
  final String tittle;

  const TittleDetailProduct({super.key, required this.tittle});

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
        Text(
          "View All",
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppPallete.black,
          ),
        ),
      ],
    );
  }
}
