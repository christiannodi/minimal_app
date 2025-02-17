import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/theme.dart';

class ManCatalogPage extends StatefulWidget {
  const ManCatalogPage({super.key});

  @override
  State<ManCatalogPage> createState() => _ManCatalogPageState();
}

class _ManCatalogPageState extends State<ManCatalogPage> {
  List<String> categorys = [
    "T-shirt, UT & Sweat",
    "Polo Shirt & Shirts",
    "Outwear",
    "Sweaters",
    "Accessories"
  ];
  List<String> categoryimages = [
    "assets/png/man_category/category1.png",
    "assets/png/man_category/category2.png",
    "assets/png/man_category/category3.png",
    "assets/png/man_category/category4.png",
    "assets/png/man_category/category5.png"
  ];
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categorys.length,
              (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedCategoryIndex == index
                                  ? AppPallete.pink
                                  : Colors.grey,
                              width: selectedCategoryIndex == index ? 3 : 0,
                            ),
                            color: selectedCategoryIndex == index
                                ? AppPallete.greywhite
                                : AppPallete.greywhite,
                          ),
                          child: Image.asset(
                            categoryimages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          color: Colors.transparent,
                          child: Text(
                            categorys[index],
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: selectedCategoryIndex == index
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: AppPallete.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                            bottom: 4,
                            child: SvgPicture.asset(
                              'assets/svg/arrow_down.svg',
                              height: 8,
                              color: selectedCategoryIndex == index
                                  ? AppPallete.pink
                                  : AppPallete.black,
                            ))
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySelect extends StatelessWidget {
  const CategorySelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 60,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppPallete.greywhite),
          child: Image.asset(
            'assets/png/man_category/category1.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: 100,
          padding: EdgeInsets.symmetric(horizontal: 1),
          color: Colors.transparent,
          child: Text(
            "T-shirt, UT & Sweat",
            style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppPallete.black),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
            bottom: 4,
            child: SvgPicture.asset(
              'assets/svg/arrow_down.svg',
              height: 8,
            ))
      ],
    );
  }
}
