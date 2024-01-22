import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/screens/categorywiseNews.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/navigation_bar.dart';
import '../screens/home_screen.dart';
import '../screens/imageCategory.dart';
import '../screens/image_screen.dart';
import '../screens/tabBar.dart';
import 'account_page.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final itemBuild = [
    'International',
    'Business',
    'Health',
    'Entertainment',
    'Technology',
    'Sports',
    'Science',
    'Miscellaneous'
  ];

  List<String> textItem = [
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
  ];

  String? dataFromFile;

  Future<void> readText() async {
    List<String> listOne = textItem;
    int c = 0;
    if (listOne.isEmpty) return;
    dataFromFile = "${listOne[0]} News";
    Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (c == textItem.length) {
        timer.cancel();
        return;
      }
      if (c != 0) {
        dataFromFile = "${listOne[c]} News";
      }
      c++;
    });
  }

  List articles = [];
  bool _showConnected = false;

  Icon themeIcon = const Icon(Icons.dark_mode);
  bool isLightTheme = false;

  Color baseColor = Colors.grey[300]!;
  Color highlightColor = Colors.grey[100]!;

  @override
  void initState() {
    if (mounted) {
      setState(() {
        readText();
        getTheme();
      });
    }
    super.initState();
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
      baseColor = isLightTheme ? Colors.grey[300]! : Color(0xff2c2c2c);
      highlightColor = isLightTheme ? Colors.grey[100]! : Color(0xff373737);
    });
  }

  checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    var isConnected = result != ConnectivityResult.none;
    if (!isConnected) {
      _showConnected = true;
      Fluttertoast.showToast(
          msg: "You are Offline",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white70,
          textColor: Colors.red);
    }

    if (isConnected && _showConnected) {
      _showConnected = false;
      Fluttertoast.showToast(
          msg: "You are Online",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white70,
          textColor: Colors.green);
    }
  }

  final searchController = TextEditingController();

  DateTime? ctime;
  Future<bool> tapToExit() async {
    DateTime now = DateTime.now();
    if (ctime == null || now.difference(ctime!) > Duration(seconds: 2)) {
      //add duration of press gap
      ctime = now;
      Fluttertoast.showToast(
          msg: "Press Back again to Exit",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
      return Future.value(false);
    }

    return Future.value(true);
  }

  Future<bool> backHome() async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomeScreen(category: 'all')));
    return true;
  }

  String searchSave = '';
  Future <bool> exitOverride() async{
    return (await showDialog(context: context,
        builder: (context)=> Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: AlertDialog(
            icon: IconButton(
                splashRadius: 25,
                onPressed: () => Navigator.of(context).pop(false),
                icon:const  Icon(Icons.dangerous_sharp,size: 30)),
            iconColor: Colors.black54.withOpacity(0.7),
            title: const Text("Don't leave us so Soon !!",textAlign: TextAlign.center,),
            content: const Text("Are you sure to exit the app?",textAlign: TextAlign.center,),
            titleTextStyle: TextStyle(color: isLightTheme?Colors.red.shade400:
            Colors.orange.shade800,fontWeight: FontWeight.w700,fontSize: 15),
            contentTextStyle: TextStyle(color: Colors.black87.withOpacity(0.85)
                ,fontSize: 15.5,fontWeight: FontWeight.w700),
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child:  Text('No',style: TextStyle(color: Colors.black87.withOpacity(0.6),
                    fontWeight: FontWeight.w800,fontSize: 15),),
              ),
              TextButton(
                onPressed: () {
                  FlutterExitApp.exitApp(iosForceExit: true);
                  Navigator.pop(context);
                  // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  // Navigator.of(context).pop(false);exit(0);
                },
                child: Text('Yes',style: TextStyle(color: Colors.black87.withOpacity(0.6),
                    fontWeight: FontWeight.w800,fontSize: 15)),
              ),
            ],
          ),
        )
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focus = FocusNode();bool hasFocus = false;
    void onFocusChange() {
      if (focus.hasFocus) {
        setState(() {
          hasFocus = true;
        });
      } else {
        setState(() {
          hasFocus = false;
        });
      }
    }
    initState(){
      focus.addListener(() {
        onFocusChange();
      });
    }

    Color iconColor =
        !isLightTheme ? Colors.black : Colors.white.withOpacity(0.9);
    Color textColor =
        !isLightTheme ? Colors.black.withOpacity(0.5) : Colors.white;
    return WillPopScope(
        onWillPop:exitOverride,
        child: SizedBox.expand(
          child: Scaffold(
            backgroundColor: isLightTheme
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey.shade800.withOpacity(0.4),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            // floatingActionButton: FloatingActionButton(onPressed: () { showSearch(context: context, delegate:MySearchBar (isLightTheme)); },
            // backgroundColor: isLightTheme
            //     ? Colors.grey
            //     : Colors.grey.shade800,
            //   child: const Icon(Icons.search_outlined,size: 25,),
            // ),
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: isLightTheme
                  ? Colors.white.withOpacity(0.04)
                  : Colors.grey.withOpacity(0.04),
              flexibleSpace: Container(
                margin:  EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.04,
                    left: MediaQuery.of(context).size.width*0.055, right: MediaQuery.of(context).size.width*0.055,
                    bottom: MediaQuery.of(context).size.height*0.001),
                // padding: ,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: TextFormField(
                  style: TextStyle(color: Colors.black.withOpacity(0.8)),
                  cursorColor: Colors.grey.withOpacity(0.08),
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        searchSave = value!;
                      });
                    }
                  },
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        textItem.clear();
                      });
                    }
                  },
                  onSaved: (value) {
                    if (mounted) {
                      setState(() {
                        searchSave = value!;
                      });
                    }
                  },
                  // cursorColor: Colors.black38,
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  autocorrect: true,
                  onFieldSubmitted: (value) {
                    if (mounted) {
                      setState(() {
                        if (value!.isEmpty) {
                          return;
                        } else {
                          searchSave = value!;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoriesPage(
                                        query: value,
                                      )));
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.5),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.6),
                          )),
                      // suffixIcon: IconButton(
                      //   icon: Icon(
                      //     Icons.search_rounded,
                      //     size: 24,
                      //     color: Colors.black.withOpacity(0.6),
                      //   ),
                      //   onPressed: () {
                      //     if (searchSave.isNotEmpty && mounted) {
                      //       setState(() {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => CategoriesPage(
                      //                       query: searchSave.trim(),
                      //                     )));
                      //       });
                      //     }
                      //   },
                      //   splashColor: Colors.transparent,
                      // ),
                      suffixIcon: IconButton(
                        tooltip: "Clear",
                        onPressed:  searchController.clear,
                        splashRadius: 25,
                        icon: Icon(Icons.clear_sharp,size: 24,
                          color: Colors.black.withOpacity(0.6),),
                      ),
                      prefixIcon: IconButton(
                        tooltip: "GitHub",
                        onPressed: () async {
                            final url = Uri.parse("https://github.com/adityabardhan/newsVerse");
                            if(await canLaunchUrl(url)){
                              Fluttertoast.showToast(
                                  msg: "Redirecting to Source Code",
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG
                              );
                              await launchUrl(url,mode: LaunchMode.externalApplication);
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Unable to Redirect",
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.white,textColor: Colors.red
                              );
                            }

                        },
                        splashRadius: 22,
                        icon: Icon(MdiIcons.github,size: 24,
                          color: Colors.black.withOpacity(0.6),),
                      ),
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.8)),
                      hintText: "Search News"
                  ),
                ),
              ),
            ),

            // bottomNavigationBar: const BottomNavBar("search"),
            body:  Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.013,),
                  Flexible(
                    fit: FlexFit.tight,flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 11, left: 12.5, right: 12.5,top: 0),
                      child: GridView.builder(
                          // scrollDirection: Axis.vertical,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: itemBuild.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 8 / 8,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemBuilder: (BuildContext context, int index) {
                              try {
                                return Card(
                                    elevation: 2.5,
                                    semanticContainer: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child:
                                    // index == 0
                                    //     ? GestureDetector(
                                    //         onTap: () {
                                    //           Navigator.push(
                                    //               context,
                                    //               MaterialPageRoute(
                                    //                   builder: (context) =>
                                    //                       CategoricalNews(
                                    //                           category:
                                    //                               'india')));
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             image: const DecorationImage(
                                    //                 image: AssetImage(
                                    //                   'assets/images/lion.png',
                                    //                 ),
                                    //                 fit: BoxFit.contain,
                                    //                 filterQuality:
                                    //                     FilterQuality.high),
                                    //           ),
                                    //           child: Container(
                                    //               alignment:
                                    //                   Alignment.bottomCenter,
                                    //               child: Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.only(
                                    //                         bottom: 3),
                                    //                 child: Text(
                                    //                   itemBuild[index],
                                    //                   style: const TextStyle(
                                    //                     fontSize: 15,
                                    //                     fontFamily:
                                    //                         "CourierPrime",
                                    //                     fontWeight:
                                    //                         FontWeight.w600,
                                    //                   ),
                                    //                 ),
                                    //               )),
                                    //         ))
                                    //     :
                                        index == 0
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoricalNews(
                                                                  category:
                                                                      'world')));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/worldGloble.png"),
                                                        fit: BoxFit.contain),
                                                  ),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                bottom: 1.8),
                                                        child: Text(
                                                          itemBuild[index],
                                                          style: const TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "CourierPrime",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      )),
                                                ))
                                            :
                                    index == 1
                                                // ? GestureDetector(
                                                // onTap: () {
                                                //   Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoricalNews(category: 'india')));
                                                // },
                                                // child: Container(
                                                //   decoration: BoxDecoration(
                                                //     borderRadius:
                                                //     BorderRadius.circular(10),
                                                //     image: const DecorationImage(
                                                //         image: AssetImage(
                                                //             'assets/images/doctor.jpg'),
                                                //         fit: BoxFit.cover),
                                                //   ),
                                                //   child: Container(
                                                //       alignment:
                                                //       Alignment.bottomCenter,
                                                //       child: Padding(
                                                //         padding:
                                                //         const EdgeInsets.only(
                                                //             bottom: 1),
                                                //         child: Text(
                                                //           itemBuild[index],
                                                //           style: const TextStyle(
                                                //             fontSize: 15,
                                                //             fontFamily:
                                                //             "CourierPrime",
                                                //             fontWeight:
                                                //             FontWeight.w600,
                                                //           ),
                                                //         ),
                                                //       )),
                                                // ))
                                                // : index == 3
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CategoricalNews(
                                                                      category:
                                                                          'business')));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/business.png'),
                                                            fit: BoxFit.cover),
                                                      ),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 3),
                                                            child: Text(
                                                              itemBuild[index],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "CourierPrime",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          )),
                                                    ))
                                                : index == 2
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CategoricalNews(
                                                                          category:
                                                                              'health')));
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            image: const DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/sciencee.png'),
                                                                fit:
                                                                    BoxFit.cover),
                                                          ),
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            2.5),
                                                                child: Text(
                                                                  itemBuild[
                                                                      index],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily:
                                                                        "CourierPrime",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              )),
                                                        ))
                                                    : index == 3
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CategoricalNews(
                                                                              category:
                                                                                  'entertainment')));
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
                                                                  image: const DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/online.png'),
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      filterQuality:
                                                                          FilterQuality
                                                                              .high)),
                                                              child: Container(
                                                                  alignment: Alignment
                                                                      .bottomCenter,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            2),
                                                                    child: Text(
                                                                      itemBuild[
                                                                          index],
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            "CourierPrime",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ))
                                                        : index == 4
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                                  CategoricalNews(category: 'technology')));
                                                                },
                                                                child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                    image: const DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/tech.png'),
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                          alignment:
                                                                              Alignment
                                                                                  .bottomCenter,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 3),
                                                                            child:
                                                                                Text(
                                                                              itemBuild[index],
                                                                              style:
                                                                                  const TextStyle(
                                                                                fontSize: 15,
                                                                                fontFamily: "CourierPrime",
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          )),
                                                                ))
                                                            : index == 5
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  CategoricalNews(category: 'sports')));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        image: const DecorationImage(
                                                                            image: AssetImage(
                                                                                'assets/images/sports.png'),
                                                                            fit: BoxFit
                                                                                .cover),
                                                                      ),
                                                                      child: Container(
                                                                          alignment: Alignment.bottomCenter,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 2),
                                                                            child:
                                                                                Text(
                                                                              itemBuild[index],
                                                                              style:
                                                                                  const TextStyle(
                                                                                fontSize: 15,
                                                                                fontFamily: "CourierPrime",
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          )),
                                                                    ))
                                                                : index == 6
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => CategoricalNews(category: 'science')));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            image: const DecorationImage(
                                                                                image: AssetImage('assets/images/scs.png'),
                                                                                fit: BoxFit.contain),
                                                                          ),
                                                                          child: Container(
                                                                              alignment: Alignment.bottomCenter,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(bottom: 3),
                                                                                child: Text(
                                                                                  itemBuild[index],
                                                                                  style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontFamily: "CourierPrime",
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ))
                                                                    // : index == 7
                                                                    //     ? GestureDetector(
                                                                    //         onTap:
                                                                    //             () {
                                                                    //           Navigator.push(context,
                                                                    //               MaterialPageRoute(builder: (context) => CategoricalNews(category: 'automobile')));
                                                                    //         },
                                                                    //         child:
                                                                    //             Container(
                                                                    //           decoration:
                                                                    //               BoxDecoration(
                                                                    //             borderRadius: BorderRadius.circular(10),
                                                                    //             image: const DecorationImage(image: AssetImage('assets/images/idea.png'), fit: BoxFit.cover),
                                                                    //           ),
                                                                    //           child: Container(
                                                                    //               alignment: Alignment.bottomCenter,
                                                                    //               child: Padding(
                                                                    //                 padding: const EdgeInsets.only(bottom: 3),
                                                                    //                 child: Text(
                                                                    //                   itemBuild[index],
                                                                    //                   style: const TextStyle(
                                                                    //                     fontSize: 15,
                                                                    //                     fontFamily: "CourierPrime",
                                                                    //                     fontWeight: FontWeight.w600,
                                                                    //                   ),
                                                                    //                 ),
                                                                    //               )),
                                                                    //         ))
                                                                        : index == 7
                                                                            ? GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoricalNews(category: 'general')));
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    image: const DecorationImage(image: AssetImage('assets/images/ideas.png'), fit: BoxFit.fill),
                                                                                  ),
                                                                                  child: Container(
                                                                                      alignment: Alignment.bottomCenter,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 3),
                                                                                        child: Text(
                                                                                          itemBuild[index],
                                                                                          style: const TextStyle(
                                                                                            fontSize: 15,
                                                                                            fontFamily: "CourierPrime",
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                ))
                                                                            : Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  image: const DecorationImage(
                                                                                    image: AssetImage('assets/images/business.png'),
                                                                                  ),
                                                                                ),
                                                                                child: Container(
                                                                                    alignment: Alignment.bottomCenter,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(bottom: 3),
                                                                                      child: Text(
                                                                                        itemBuild[index],
                                                                                        style: const TextStyle(
                                                                                          fontSize: 15,
                                                                                          fontFamily: "CourierPrime",
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                              ));
                              } catch (e) {
                                print('429');
                                return const SizedBox.shrink();
                              }
                            }),

                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  // Container(
                  //   child: GestureDetector(
                  //     onTap: () async => _pullToRefresh(),
                  //     child: Icon(
                  //         Icons.refresh_outlined,
                  //         color: Color(0xffffffff),
                  //         size: 33.0
                  //     ),
                  //   ),
                  //   padding: EdgeInsets.all(10.0),
                  //   margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.black38,
                  //     borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  //   ),
                  // )
                ],
              ),
          ),
        ));
  }
}

class  MySearchBar extends SearchDelegate{
  List<String> textItem = [
    'National',
    'International',
    'Business & Commerce',
    'Science & Education',
    'Entertainment & Fun',
    'Technological',
    'Sports',
    'Political',
    'Car & AutoMobile',
  ];
  bool isLightTheme;
  MySearchBar(this.isLightTheme);


  ThemeData appBarTheme(BuildContext context) {
    Color bg = (isLightTheme?Colors.white:Colors.grey.withOpacity(0.0));
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: !isLightTheme?Colors.grey:Colors.grey.withOpacity(0.25)
      ),
      brightness:isLightTheme?Brightness.light:Brightness.dark,
      platform: TargetPlatform.android,

      textTheme: TextTheme(
        // Use this to change the query's text style
        titleLarge: TextStyle(fontSize: 18.0,color: isLightTheme?Colors.black:Colors.white,),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: bg,
        // backgroundColor: bg,
      ),

      inputDecorationTheme: InputDecorationTheme(
        isCollapsed: true,
        border: InputBorder.none,
        // Use this change the placeholder's text style
        hintStyle: TextStyle(fontSize: 18.0,color: isLightTheme?Colors.black:Colors.white,),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
      splashRadius: 18,
          onPressed: () {
            query = "";
          },
          icon:  Icon(Icons.clear,color: isLightTheme?Colors.black:Colors.white,),
        )
];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.pop(context);
    },splashRadius: 18,
        icon: Icon(Icons.arrow_back,color: isLightTheme?Colors.black:Colors.white,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return CategoriesPage(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final List<String> suggestionList = query.isEmpty
        ? []
        : textItem
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            // Show the search results based on the selected suggestion.
          },
        );
      },
    );
  }
}