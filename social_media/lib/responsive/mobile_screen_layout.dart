import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/models/user.dart' as model;
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/util/colors.dart';
import 'package:social_media/util/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              children: screens,
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
            bottomNavigationBar: BottomNavigationBar(
                onTap: navigationTap,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: 'Home',
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: _page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: 'Search',
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: _page == 2 ? primaryColor : secondaryColor,
                    ),
                    label: 'Post',
                    backgroundColor: primaryColor,
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(
                  //     Icons.favorite,
                  //     color: _page == 3 ? primaryColor : secondaryColor,
                  //   ),
                  //   label: 'Favorite',
                  //   backgroundColor: primaryColor,
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: _page == 3 ? primaryColor : secondaryColor,
                    ),
                    label: 'Profile',
                    backgroundColor: primaryColor,
                  ),
                ]),
          );
  }
}
