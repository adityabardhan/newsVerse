// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/components/second_news_tile.dart';
import 'package:newsverse/helper/infoPage.dart';
import 'package:newsverse/helper/navigation_bar.dart';
import 'package:newsverse/screen/account_page.dart';
import 'package:newsverse/screen/search_page.dart';
import 'package:newsverse/screens/tabBar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/news_tile.dart';
import '../components/shimmer_news_tile.dart';
import '../helper/news.dart';
import '../helper/secondApiCall.dart';
import '../provider/theme_provider.dart';
import 'drawer_scren.dart';
import 'image_screen.dart';

class HomeScreen extends StatefulWidget {
  final String category;
  HomeScreen({required this.category});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {
  List articles = [];
  bool _loading = true;
  bool _showConnected = false;
  bool _articleExists = true;
  bool _retryBtnDisabled = false;

  Icon themeIcon = const Icon(Icons.dark_mode);
  bool isLightTheme = false;

  ScrollController scrollController = ScrollController();
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });
    _loading = true;
    getNewsByQuery();
    getTheme();
    scrollController.addListener(() { //scroll listener
      double showoffset = 10.0; //Back to top botton will show on scroll offset 10.0

      if(scrollController.offset > showoffset){
        showButton = true;
        if (mounted){
          // setState(() {
          // });
        }
      }else{
        showButton = false;
        // if (mounted){
        //   setState(() {
        //   });
        // }
      }
    });
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    if (mounted){
      setState(() {
        isLightTheme = settings.get('isLightTheme') ?? false;
        themeIcon = isLightTheme ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode);
      });
    }
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
          backgroundColor: Colors.white70,textColor: Colors.red
      );

    }

    if (isConnected && _showConnected) {
      _showConnected = false;
      Fluttertoast.showToast(
          msg: "You are Online",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white70,textColor: Colors.green
      );
      getNewsByQuery();
    }
  }

  // getNews() async {
  //   _loading = true;
  //   checkConnectivity();
  //   News newsClass = News();
  //   await newsClass.getNews(category: widget.category);
  //   articles = newsClass.news;
  //   if (mounted){
  //     setState(() {
  //       if (articles.isEmpty) {
  //         _articleExists = false;
  //       } else {
  //         _articleExists = true;
  //       }
  //       _loading = false;
  //       _retryBtnDisabled = false;
  //     });
  //   }
  // }

  List<SecondNewsModel> catModelList = [];
  bool isLoading  = false;

  getNewsByQuery()async {
    _loading = true;
    checkConnectivity();
    String url=
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=8c02b3ba6e59447ea29c296741495fce";
    Response response = await get(Uri.parse(url));
    Map element;
    int i = 0;
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data['articles']) {
        try {
          i++;
          SecondNewsModel precipiceModel = SecondNewsModel();
          precipiceModel = SecondNewsModel.fromMap(element);
          catModelList.add(precipiceModel);
          setState(() {
            if (catModelList.isEmpty){
              _articleExists = false;
            }
            else{
              _articleExists = true;
            }
            _loading = false;
            _retryBtnDisabled = false;
          });
        } catch (e) {

        }
      }
      Fluttertoast.showToast(
          msg: "News Feed Updated",fontSize: 12,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,textColor: Colors.black
      );
    });
  }

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
                  Navigator.of(context).pop(false);exit(0);
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
  void dispose() {
    scrollController.dispose();
    listScrollController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController listScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Color textColor = !isLightTheme?Colors.white:Colors.black;
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color baseColor = isLightTheme ? Colors.grey[300]! : const Color(0xff2c2c2c);
    Color highlightColor = isLightTheme ? Colors.grey[100]! : const Color(0xff373737);
    Color darkColor = isLightTheme?Colors.black.withOpacity(0.95):Colors.white.withOpacity(0.9);
    return WillPopScope(
      onWillPop: exitOverride,

      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: isLightTheme?Colors.grey.withOpacity(0.1):Colors.grey.shade900.withOpacity(0.9),
        drawer: const DrawerScreen(),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: darkColor,
        // bottomNavigationBar: const BottomNavBar("home"),
        appBar: AppBar(
          iconTheme: IconThemeData(color: darkColor),
          centerTitle: true,
          systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
              Text(
                'NewsVerse',
                style: TextStyle(color: darkColor,fontWeight: FontWeight.w700,fontSize: 21),
              ),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const InformationPage()));
              },
              color: darkColor,
              splashRadius: 20,
              icon: Icon(MdiIcons.informationSlabCircleOutline,color: darkColor,size: 24,),
            ),
          ],
          // toolbarHeight: MediaQuery.of(context).size.height*0.15,
        ),
        body: Container(
          padding:const EdgeInsets.only(top: 2.5),
          child: _loading ?
               Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics:const  BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal
              ),
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return const ShimmerNewsTile();
              },
            ),
          )
              : _articleExists ?
          EasyRefresh(
            // header: const ClassicHeader(position: IndicatorPosition.locator, triggerOffset: 80, clamping: false),
            footer: const ClassicFooter(),
            header: ClassicHeader(hapticFeedback: true,
              textStyle: TextStyle(color: isLightTheme?Colors.black:Colors.white,fontSize: 13.9,fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500),
              iconTheme: IconThemeData(color: isLightTheme?Colors.black:Colors.white,),
              messageStyle: TextStyle(color: isLightTheme?Colors.black:Colors.white,fontStyle: FontStyle.italic),
                messageText: "Last Updated: %T",showMessage: false,
              iconDimension: 18,
              processedText: "Refreshed",
              ),
            // color: isLightTheme?Colors.black:Colors.white,
            // backgroundColor: isLightTheme?Colors.white:Colors.black54,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              // physics:const  BouncingScrollPhysics(),
              itemCount: catModelList.length,
              itemBuilder: (context,index){
                // return NewsTile(
                //   image: articles[index].image,
                //   title: articles[index].title,
                //   content: articles[index].content,
                //   date: articles[index].publishedDate,
                //   fullArticle: articles[index].fullArticle,
                // );
                return SecondNewsTile(
                  index: index,title: catModelList[index].newsHead,
                  description: catModelList[index].newDes,
                  image: catModelList[index].newImage,
                  url: catModelList[index].newUrl,
                  date: catModelList[index].published,
                  content: catModelList[index].content
                );
              },
            ),
            onRefresh: () => getNewsByQuery(),
          )
             : !_articleExists? Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" No data available ",style: TextStyle(color: !isLightTheme? Colors.deepOrangeAccent.shade400:Colors.red,fontSize: 21,
                  decoration: TextDecoration.lineThrough,decorationColor: !isLightTheme?Colors.white:Colors.black),),
                  TextButton(
                    child: Text('Click Me to Retry!',style: TextStyle(color: isLightTheme? Colors.black:Colors.white,fontSize: 15,
                    decoration: TextDecoration.none,decorationColor: Colors.red.shade300,decorationStyle: TextDecorationStyle.solid)),
                    onPressed: () {
                      if (!_articleExists) {
                        if (mounted){
                          setState(() {
                            _retryBtnDisabled = true;
                          });
                        }
                        getNewsByQuery();
                      }
                    },
                  ),
                ],
              ),
            ),
          ):const Center(child: CircularProgressIndicator(color: Colors.red,),)
        ),

      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
