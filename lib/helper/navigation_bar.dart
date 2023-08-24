import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:transition/transition.dart';

import '../screen/account_page.dart';
import '../screen/search_page.dart';
import '../screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String _string;
  const BottomNavBar(this._string, {Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>{

  bool isLightTheme = false;

  @override
  void initState() {
    setState(() {
      getTheme();
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  int selectedIndex = 0;

  final screens = [
    HomeScreen(category: 'all'),
    const DiscoveryPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    Color iconColor = isLightTheme ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8);
    Color secIconColor = !isLightTheme ? Colors.black : Colors.white;
    Color backColor = isLightTheme
        ? Colors.grey.shade100
        : Colors.grey.shade900.withOpacity(0.85);
    // return BottomNavigationBar(
    //   selectedFontSize: 20.5,
    //   unselectedFontSize: 14.5,
    //   currentIndex: _selectedIndex,
    //   selectedLabelStyle:
    //   TextStyle(color: iconColor, fontWeight: FontWeight.w500),
    //   unselectedLabelStyle:
    //   TextStyle(color: iconColor, fontWeight: FontWeight.w500),
    //   selectedItemColor: Colors.orangeAccent,
    //   unselectedItemColor: iconColor,
    //   onTap: (index){
    //     setState(() {
    //       _selectedIndex = index;
    //     });
    //   },
    //   elevation: 0.5,
    //   backgroundColor: backColor,
    //   items: <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       tooltip: 'Home',
    //       icon: IconButton(
    //         splashRadius: 25,
    //           onPressed: () {
    //             // if (!widget._string.contains("home")) {
    //             //   Navigator.push(
    //             //     context,
    //             //       MaterialPageRoute(builder: (context)=> HomeScreen(category: 'all'))
    //             //   );
    //             // }
    //           },
    //           icon: Icon(Icons.home_outlined,
    //               size: 25.5, color: iconColor)),
    //       label: ('Home'),
    //     ),
    //     BottomNavigationBarItem(
    //       backgroundColor: backColor,
    //       tooltip: "Search",
    //       icon: IconButton(
    //           onPressed: () {
    //             // if (!widget._string.contains("search")) {
    //             //   Navigator.push(
    //             //       context,
    //             //       MaterialPageRoute(builder: (context)=>const  DiscoveryPage())
    //             //   );
    //             // }
    //           },
    //           icon: Icon(Icons.search_outlined,
    //               size: 26, color: iconColor)),
    //       label: "Search"
    //       ),
    //     BottomNavigationBarItem(
    //         backgroundColor: backColor,
    //         tooltip: "Profile",
    //         icon: IconButton(
    //             onPressed: () {
    //               // if (!widget._string.contains("account")) {
    //               //   Navigator.push(
    //               //       context,
    //               //       MaterialPageRoute(builder: (context)=> AccountPage())
    //               //   );
    //               // }
    //             },
    //             icon: Icon(Icons.person_outline,
    //                 size: 25.5, color: iconColor)),
    //         label: "Profile"
    //     ),
    //   ],
    //   // type: BottomNavigationBarType.fixed,
    //   // showSelectedLabels: false,
    // );
    return
      // Scaffold(
      // body: IndexedStack(index: selectedIndex,children: screens,),
      // bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedIconTheme:const  IconThemeData(size: 26),
        unselectedIconTheme:const  IconThemeData(size: 24.5),
        elevation: 0.5,
        selectedFontSize: 14.5,
        unselectedFontSize: 13.5,
        selectedLabelStyle: TextStyle(color: iconColor.withOpacity(0.8), fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(color: iconColor.withOpacity(0.5), fontWeight: FontWeight.w400),
        backgroundColor: backColor,
        selectedItemColor: isLightTheme?Colors.black:Colors.white,
        unselectedItemColor: isLightTheme?Colors.black54:Colors.white60,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined),label: "Search",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: "Profile",
          )
        ],
      // ),
    );
  }
}
