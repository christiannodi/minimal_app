import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_app/screen/home_page/home_page.dart';
import 'package:minimal_app/screen/love_page/love_page.dart';
import 'package:minimal_app/screen/profile_page/profile_page.dart';
import 'package:minimal_app/screen/search_page/search_page.dart';
import 'package:minimal_app/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget?> _pages = [null, null, null, null];

  Widget _getPage(int index) {
    if (_pages[index] == null) {
      switch (index) {
        case 0:
          _pages[index] = HomePage();
          break;
        case 1:
          _pages[index] = SearchPage();
          break;
        case 2:
          _pages[index] = LovePage();
          break;
        case 3:
          _pages[index] = ProfilePage();
          break;
      }
    }
    return _pages[index]!;
  }

  void _onItemTapped(int index) {
    setState(() {
      _pages[index] = null;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whitedefault,
      body: _getPage(_currentIndex),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Container(
            color: AppPallete.whitedefault,
            child: bottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      backgroundColor: AppPallete.whitedefault,
      selectedItemColor: AppPallete.pink,
      unselectedItemColor: AppPallete.black,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      onTap: _onItemTapped,
      items: [
        bottomNavigationBarItem(
          icon: 'assets/svg/home.svg',
          icon2: 'assets/svg/home1.svg',
          label: '',
        ),
        bottomNavigationBarItem(
          icon: 'assets/svg/search.svg',
          icon2: 'assets/svg/search1.svg',
          label: '',
        ),
        bottomNavigationBarItem(
          icon: 'assets/svg/love.svg',
          icon2: 'assets/svg/love1.svg',
          label: '',
        ),
        bottomNavigationBarItem(
          icon: 'assets/svg/account.svg',
          icon2: 'assets/svg/account1.svg',
          label: '',
        ),
      ],
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem({
    required String label,
    required String icon,
    required String icon2,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        width: 22,
        height: 22,
        colorFilter: const ColorFilter.mode(
          AppPallete.black,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        icon2,
        width: 22,
        height: 22,
        colorFilter: const ColorFilter.mode(
          AppPallete.pink,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
