import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:newsverse/screen/account_page.dart';
import 'package:newsverse/screens/home_screen.dart';

import '../screen/search_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  int selected = 0;

  void onTapped(int index) {
    setState(() {
      selected = index;
    });

  }
  static final List<Widget> screens = <Widget>[
    HomeScreen(category: 'all'),
    const DiscoveryPage(),
    ProfilePage()
  ];

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Center(
  //         child: _widgetOptions.elementAt(selected),
  //       ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: selected,
  //       onTap: onTapped,
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.call),
  //           label: 'Calls',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.camera),
  //           label: 'Camera',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.chat),
  //           label: 'Chats',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    Color iconColor = isLightTheme
        ? Colors.black.withOpacity(0.8)
        : Colors.white.withOpacity(0.8);
    return Scaffold(
        body: DefaultTabController(
          animationDuration: const Duration(milliseconds: 10),
          length: 3,
          child: Scaffold(
            backgroundColor: isLightTheme
                ? Colors.grey.withOpacity(0.08)
                : Colors.grey.shade900.withOpacity(0.95),
            bottomNavigationBar: SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: TabBar(
                indicator: BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.elliptical(30 , 100)),
                  // border: Border.all(color: Colors.grey.shade900.withOpacity(0.9)),
                    color: isLightTheme
                        ? Colors.grey.shade300.withOpacity(0.5)
                        : Colors.grey.shade900.withOpacity(0.8)
                ),
                indicatorWeight: 1.6,
                splashBorderRadius: BorderRadius.zero,
                indicatorColor: Colors.transparent,
                // isLightTheme ? Colors.grey.shade800 : Colors.white54,

                indicatorSize: TabBarIndicatorSize.tab,
                splashFactory: NoSplash.splashFactory,
                unselectedLabelColor: isLightTheme ? Colors.black.withOpacity(0.85) : Colors.white54,
                labelStyle: const TextStyle(fontSize: 12.3, fontWeight: FontWeight.w500),
                unselectedLabelStyle: const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w400),
                labelColor: iconColor,
                tabs: [
                  Tab(
                    text: "Home",
                    icon: Icon(Icons.home_outlined, color: iconColor),
                    iconMargin: const EdgeInsets.only(bottom: 3),
                  ),
                  Tab(
                    text: "Search",
                    icon: Icon(
                      Icons.search_outlined,
                      color: iconColor,
                    ),
                    iconMargin: const EdgeInsets.only(bottom: 3),
                  ),
                  Tab(
                    text: "Account",
                    icon: Icon(Icons.account_circle_outlined, color: iconColor),
                    iconMargin: const EdgeInsets.only(bottom: 3),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HomeScreen(category: 'all'),
                const DiscoveryPage(),
                ProfilePage()
              ],
            ),
          ),
        )
    );
  }



}
