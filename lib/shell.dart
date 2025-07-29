import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/components/themes.dart';
import 'package:qr_generator/controllers/option_controller.dart';
import 'package:qr_generator/layouts/home.dart';
import 'package:qr_generator/layouts/options.dart';
class Shell extends StatelessWidget {
  final int index;
  late bool exit;

  Shell({
    super.key,
    required this.index,
    this.exit = false,
  });


  @override
  Widget build(BuildContext context) {
   List<Map<String, dynamic>> themes = Themes().themes;
    int themeID = context.watch<OptionController>().options.first.theme!;
    Map<String, dynamic> theme = themes.firstWhere((theme) => theme['id'] == themeID);
    List<Color> colors = theme['color'];
    Color textColor = theme['textColor'];

    final PersistentTabController controller = PersistentTabController(initialIndex: index);
    return PersistentTabView(
      context,
      controller: controller,
      onWillPop: (p0) {
          if (exit) {
            FlutterExitApp.exitApp();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Press back again to exit",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: textColor
                )
              ),
              backgroundColor: Colors.white,
              duration: const Duration(seconds: 3)
            ),
          );
          exit = true;
          Future.delayed(const Duration(seconds: 3), (){
            exit = false;
          });
          return Future.value(false);
        },
      screens: [
        Home(colors: colors, textColor: textColor),
        Options(colors: colors, textColor: textColor),
      ],
      items: [
        PersistentBottomNavBarItem(
          activeColorPrimary: textColor,
          icon: Icon(
            Icons.qr_code_rounded,
            color: textColor,
            size: 20,
          ),
          textStyle: GoogleFonts.quicksand(
            color: textColor,
          ),
        ),
        PersistentBottomNavBarItem(
          activeColorPrimary: textColor,
          icon: Icon(
            Icons.settings_suggest_sharp,
            color: textColor,
            size: 20,
          ),
          textStyle: GoogleFonts.quicksand(
            color: textColor,
          ),
        ),
      ],
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: colors[1],
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
