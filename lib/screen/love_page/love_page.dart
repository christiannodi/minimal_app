import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/model/popular_model.dart';
import 'package:minimal_app/theme.dart';

class LovePage extends StatelessWidget {
  const LovePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppPallete.black,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 140,
            elevation: 0.0,
            automaticallyImplyLeading: false, //? matikan tombol back
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: EdgeInsets.only(left: 16, bottom: 30),
                title: Text(
                  "Product you like",
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.white,
                  ),
                ),
                background: Image.asset(
                  "assets/png/bg.png",
                  fit: BoxFit.cover,
                )),
            //!ruang paling bawah sliver
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Column(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: AppPallete.whitedefault),
                  ),
                ],
              ),
            ),
          ),
          //!ruang pertama setelah sliver
          SliverPersistentHeader(
              pinned: true, floating: false, delegate: MyHeaderDelegate()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! GridView yang berfungsi seperti Column normal
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

                  //! Tambahkan Konten Biasa di Bawah Grid
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                      child: Text(
                        "Explore Again",
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppPallete.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SaveProduct extends StatelessWidget {
  final PopularProductsModel saveProduct;

  const SaveProduct({super.key, required this.saveProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                saveProduct.image,
                fit: BoxFit.cover,
              )),
        ),
        Gap(8),
        Text(
          saveProduct.price,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppPallete.black,
          ),
        ),
        Text(
          saveProduct.name,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppPallete.grey,
          ),
        ),
      ],
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 42,
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: AppPallete.whitedefault,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Pastikan tidak ada spacing ekstra
        children: [
          Filter(
            tittle: "All",
          ),
          Gap(10),
          Filter(
            tittle: "Status",
          ),
          Gap(10),
          Filter(
            tittle: "Category",
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 42;
  @override
  double get minExtent => 42;
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class Filter extends StatelessWidget {
  final String tittle;

  const Filter({super.key, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppPallete.pink),
      child: Center(
        child: Text(
          tittle,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppPallete.white,
          ),
        ),
      ),
    );
  }
}
