import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:newsverse/helper/navigation_bar.dart';
import 'package:newsverse/provider/modelProvider.dart';
import 'package:newsverse/provider/themeData.dart';
import 'package:newsverse/provider/theme_provider.dart';
import 'package:newsverse/screen/search_page.dart';
import 'package:newsverse/screens/home_screen.dart';
import 'package:newsverse/screens/tabBar.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transition/transition.dart';
import 'AnewPage/loginPage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDirectory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isLightTheme: isLightTheme),
      child: const AppStart(),
    ),
  );
}

class AppStart extends StatelessWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MyApp(themeProvider: themeProvider);
  }
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  final ThemeProvider themeProvider;
  const MyApp({Key? key, required this.themeProvider});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool viewLoginPage = true;
  bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  User? user;

  @override
  void initState() {
    getTheme();
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: user == null ?  LoginPage() : const Dashboard(),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (user==null){
               return LoginPage();
            }
            else if(user!=null){
              return const Dashboard();
            }
            return const Center(child: CircularProgressIndicator(color: Colors.white,));
          }

        // if (snapshot.hasData){
        //   return const Dashboard();
        // }
        // else {
        //   return LoginPage();
        // }
        // return const Center(child: CircularProgressIndicator(color: Colors.white,),);
      ),
    );
  }
}

/*
StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (BuildContext context,AsyncSnapshot snapshot){
      //     // if (snapshot.hasError){
      //     //   return Text(snapshot.error.toString());
      //     // }
      //     // if (snapshot.connectionState==ConnectionState.active){
      //     //   if (snapshot.data==null || FirebaseAuth.instance.currentUser==null){
      //     //     print("##############  #############");
      //     //     return LoginPage();
      //     //   }
      //     //   else {
      //     //     print("-----------------  -------------------");
      //     //     return const Dashboard();
      //     //   }
      //     // }
      //     if (snapshot.hasData){
      //       return const Dashboard();
      //     }
      //     else {
      //       return LoginPage();
      //     }
      //     // return const Center(child: CircularProgressIndicator(color: Colors.white,),);
      //   },
      // ),
 */

// /* if (FirebaseAuth.instance.currentUser!=null){
//                 Timer(const Duration(milliseconds: 100),
//                         ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(category: 'all'))));
//               }
//               else{
//                 Timer(const Duration(milliseconds: 100),
//                         ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage())));
//               }
//               return const SizedBox.shrink();
//
