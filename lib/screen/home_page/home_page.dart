import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/model/popular_model.dart';
import 'package:minimal_app/screen/product_page/product_page.dart';
import 'package:minimal_app/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(40),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                ".minimal",
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
            ),
            Gap(8),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [searchBar(), Gap(10), CartIcon()],
              ),
            ),
            Gap(20),
            promotionBox(),
            Gap(16),
            TittleProduct(
              tittle: "Popular products",
            ),
            Gap(10),
            SizedBox(
              height: 212,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: listPopular.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  return const Gap(20);
                },
                itemBuilder: (BuildContext context, int index) {
                  return PopularProduct(
                    popularProduct: listPopular[index],
                  );
                },
              ),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppPallete.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Who are you shopping for?",
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppPallete.black,
                      ),
                    ),
                    Gap(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Button(tittle: "MAN"),
                        Gap(20),
                        Button(tittle: "WOMEN")
                      ],
                    )
                  ],
                ),
              ),
            ),
            Gap(16),
            TittleProduct(
              tittle: "T-shirt products",
            ),
            Gap(10),
            SizedBox(
              height: 212,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: listPopular.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  return const Gap(20);
                },
                itemBuilder: (BuildContext context, int index) {
                  return PopularProduct(
                    popularProduct: listPopular[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded searchBar() {
    return Expanded(
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppPallete.grey,
            width: 1,
          ),
          color: AppPallete.whitedefault,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              "Search product...",
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppPallete.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding promotionBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
        Container(
          width: double.infinity,
          height: 185,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black),
          child: Image.asset(
            'assets/png/promotion.png',
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Button(
              tittle: "Shop Now",
            ),
          ),
        )
      ]),
    );
  }
}

class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppPallete.black),
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/cart.svg',
            width: 20,
            height: 20,
          ),
        ));
  }
}

class Button extends StatelessWidget {
  final String tittle;

  const Button({super.key, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 87,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppPallete.pink),
      child: Center(
        child: Text(
          tittle,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppPallete.white,
          ),
        ),
      ),
    );
  }
}

class PopularProduct extends StatelessWidget {
  final PopularProductsModel popularProduct;

  const PopularProduct({super.key, required this.popularProduct});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 212,
      width: 151,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 167,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  popularProduct.image,
                  fit: BoxFit.cover,
                )),
          ),
          Gap(8),
          Text(
            popularProduct.price,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppPallete.black,
            ),
          ),
          Text(
            popularProduct.name,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppPallete.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TittleProduct extends StatelessWidget {
  final String tittle;

  const TittleProduct({super.key, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tittle,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppPallete.black,
            ),
          ),
          Text(
            "See All",
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppPallete.black,
            ),
          ),
        ],
      ),
    );
  }
}
