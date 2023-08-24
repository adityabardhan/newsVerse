
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/helper/navigation_bar.dart';
import 'package:newsverse/screen/account_page.dart';
import 'package:newsverse/screen/search_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/news_tile.dart';
import '../components/second_news_tile.dart';
import '../components/shimmer_news_tile.dart';
import '../helper/news.dart';
import '../helper/secondApiCall.dart';
import '../provider/theme_provider.dart';
import 'drawer_scren.dart';
import 'image_screen.dart';

class CategoricalNews extends StatefulWidget {
  final String category;
  CategoricalNews({required this.category});

  @override
  _CategoricalNewsState createState() => _CategoricalNewsState();
}

class _CategoricalNewsState extends State<CategoricalNews> {
  List articles = [];
  bool _loading = true;
  bool _showConnected = false;
  bool _articleExists = true;
  bool _retryBtnDisabled = false;
  bool isLightTheme = false;


  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });
    _loading = true;
    getNews();
    getTheme();
    getNewsByCategory();
  }

  List<SecondNewsModel> imageModelList = [];
  getNewsByCategory() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=${widget.category}&apiKey=8c02b3ba6e59447ea29c296741495fce";
    _loading = true;
    checkConnectivity();
    if (widget.category=="world"){
      url = "https://newsapi.org/v2/top-headlines?sources=cnn&apiKey=8c02b3ba6e59447ea29c296741495fce";
    }
    else if (widget.category=='general'){
      url = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=8c02b3ba6e59447ea29c296741495fce";
    }
    else{
      url=
      "https://newsapi.org/v2/top-headlines?country=in&category=${widget.category}&apiKey=8c02b3ba6e59447ea29c296741495fce";
    }
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
          imageModelList.add(precipiceModel);
          setState(() {
            if (imageModelList.isEmpty){
              _articleExists = false;
            }
            else{
              _articleExists = true;
            }
            _loading = false;
            _retryBtnDisabled = false;
          });
        } catch (e) {
          print("57, Categories $e");
        }
      }
      Fluttertoast.showToast(
          msg: "Showing Latest News",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,textColor: Colors.black
      );
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
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
      getNewsByCategory();
    }
  }

  getNews() async {
    _loading = true;
    checkConnectivity();
    News newsClass = News();
    await newsClass.getNews(category: widget.category);
    articles = newsClass.news;
    setState(() {
      if (articles.isEmpty) {
        _articleExists = false;
      } else {
        _articleExists = true;
      }
      _loading = false;
      _retryBtnDisabled = false;
    });
    Timer(const Duration(milliseconds: 1850),(){
      Fluttertoast.showToast(
          msg: "Showing Breaking News",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,textColor: Colors.black
      );
    });
  }

  // int _selectedIndex = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text('Home', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
  //   Text('Search', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
  //   Text('Profile', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
  // ];
  // final List<Widget> pages = [CategoricalNews(category: 'all'),DiscoveryPage(),AccountPage()];
  //
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     Navigator.push(
  //       context,
  //       Transition(
  //         child: pages[index],
  //         transitionEffect: TransitionEffect.FADE,
  //       ),
  //     );
  //   });
  // }

  _launchURL(inputUrl) async{
    final url = Uri.parse(inputUrl);
    if(await canLaunchUrl(url)){
      Fluttertoast.showToast(
          msg: "Opening News in Browser",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG
      );
      await launchUrl(url,mode: LaunchMode.externalApplication);
    }else{
      Fluttertoast.showToast(
          msg: "Unable to load the news",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,textColor: Colors.red
      );
    }
  }

  _shareNews(String inputUrl) async{
    final String appLink = inputUrl;
    final String message = 'Check out this news article: $appLink';
    await Share.share(message,subject: "Have you read this article? No? Read it here.");
  }

  @override
  Widget build(BuildContext context) {
    Color darkColor = !isLightTheme?Colors.white:Colors.black;
    Color baseColor = isLightTheme ? Colors.grey[300]! :const Color(0xff2c2c2c);
    Color highlightColor = isLightTheme ? Colors.grey[100]! :const  Color(0xff373737);
    return WillPopScope(
      onWillPop: () async=> true,
      child: Scaffold(
        backgroundColor: isLightTheme?Colors.white.withOpacity(1):Colors.grey.withOpacity(0.3),
        appBar: AppBar(
          systemOverlayStyle: isLightTheme
              ? const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
              : const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded,color: darkColor,
            ),iconSize: 24,
            splashRadius: 1,splashColor: Colors.black38,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title:  Container(
            margin: const EdgeInsets.only(left: 5),
            child:  Text(
              "NewsVerse: ${widget.category[0].toUpperCase()}${widget.category.substring(1,widget.category.length).toLowerCase()}",
              style: TextStyle(fontWeight: FontWeight.w600,color: darkColor,fontSize: 19),
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () {
                getNewsByCategory();
              },
              icon: Icon(Icons.refresh_sharp,size: 23.6,color: darkColor,),
            ),
          ],
        ),
        body: _loading
            ? Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return const ShimmerNewsTile();
            },
          ),
        )
            : _articleExists
            ?
        RefreshIndicator(
          onRefresh: () async=> getNewsByCategory(),
          color: isLightTheme?Colors.black:Colors.white,
          backgroundColor: isLightTheme?Colors.white:Colors.black54,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: imageModelList.length,
            itemBuilder: (context,index){
              try{
                return Container(
                  decoration:
                  const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.only(bottom: 24),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                              tag: imageModelList[index].newImage,
                              child: CachedNetworkImage(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover
                                ,
                                imageUrl: imageModelList[index].newImage,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageScreen(
                                  imageUrl: imageModelList[index].newImage,
                                  headline: imageModelList[index].newsHead,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () => _launchURL(imageModelList[index].newUrl),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8),
                                  child: Text(
                                    imageModelList[index].newsHead,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style:
                                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: !isLightTheme?Colors.white:Colors.black
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              GestureDetector(
                                onTap: () => _launchURL(imageModelList[index].newUrl),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                  child: Text(
                                    imageModelList[index].newDes,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(color: !isLightTheme?Colors.white:Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text("Date:${imageModelList[index].published.substring(0,10).split("-").reversed.join("-")}"
                                          ,textAlign: TextAlign.left,
                                          style:TextStyle(fontSize: 11.5,color: isLightTheme? Colors.black.withOpacity(0.6):Colors.white.withOpacity(0.8))),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _shareNews(imageModelList[index].newUrl);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.share_outlined,color: isLightTheme? Colors.black.withOpacity(0.6):Colors.white.withOpacity(0.8),size: 16),
                                          const SizedBox(width: 5,),
                                          Text("Share",style: TextStyle(fontSize: 12,color: isLightTheme? Colors.black.withOpacity(0.6):Colors.white.withOpacity(0.8)),)
                                        ],
                                      ),
                                    )
                                  ] )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              catch(e){print("227, Categories $e");return const SizedBox.shrink();}
            },
          ),
        )
            :Center(
          heightFactor: MediaQuery.of(context).size.height*0.015,
          child: CircularProgressIndicator(color: Colors.grey.shade400,backgroundColor: isLightTheme?Colors.black.withOpacity(0.6):
          Colors.grey.shade500),),
      ),
    );
  }
}
