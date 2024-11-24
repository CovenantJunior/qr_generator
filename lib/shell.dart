import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:qr_generator/layouts/home.dart';
import 'package:qr_generator/layouts/options.dart';
class Shell extends StatelessWidget {
  final int index;

  const Shell({
    super.key,
    required this.index
  });


  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController(initialIndex: index);
    return PersistentTabView(
      context,
      controller: controller,
      screens: const [
        Home(),
        Options(),
      ],
      items: [
        PersistentBottomNavBarItem(
          activeColorPrimary: Colors.white,
          icon: const Icon(
            Icons.qr_code_rounded,
            color: Colors.white,
            size: 20,
          ),
          textStyle: GoogleFonts.quicksand(
            color: Colors.white,
          ),
        ),
        PersistentBottomNavBarItem(
          activeColorPrimary: Colors.white,
          icon: const Icon(
            Icons.settings_suggest_sharp,
            color: Colors.white,
            size: 20,
          ),
          textStyle: GoogleFonts.quicksand(
            color: Colors.white,
          ),
        ),
      ],
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.purple[700]!,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style19 // Choose the nav bar style with this property
    );
  }
}
