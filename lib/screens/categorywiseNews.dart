import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:newsverse/components/news_tile.dart';
import 'package:newsverse/screens/article_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/shimmer_news_tile.dart';
import '../helper/secondApiCall.dart';
import 'image_screen.dart';
class CategoriesPage extends StatefulWidget {
  String query;
  CategoriesPage({super.key, required this.query});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  List<SecondNewsModel> catModelList = [];
  bool isLoading  = false;

  getNewsByQuery(String query)async {
    String url=
        "https://newsapi.org/v2/everything?q=$query&apiKey=8c02b3ba6e59447ea29c296741495fce";

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
            isLoading = true;
          });
          if (i == 25) break;
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
  bool _showConnected = false;

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
    }
  }


  @override
  void initState() {
    getNewsByQuery(widget.query);
    getTheme();
    super.initState();
  }

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
    Color iconColor = !isLightTheme?Colors.white.withOpacity(0.95):Colors.black.withOpacity(0.9);
    Color textColor = !isLightTheme?Colors.white:Colors.black;
    Color contentColor = isLightTheme?Colors.white:Colors.black;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            getNewsByQuery(widget.query);
          }, icon: Icon(Icons.refresh_rounded,color: iconColor,),
            splashRadius: 20,
            splashColor: Colors.white70,
            style: const ButtonStyle(
                alignment: Alignment.topRight
            ),
          ),
        ],
        // toolbarHeight: 40,
        // shape: const StadiumBorder(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,color: iconColor,),
          splashRadius: 22,splashColor: Colors.grey.shade300,
          style: const ButtonStyle(
            alignment: Alignment.topLeft
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title:   Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Search Results for '${widget.query}'"
            ,style: TextStyle(color: textColor,
                fontWeight: FontWeight.w500,fontSize: 18.5,fontFamily: 'RobotNormal'),maxLines: 2
            ,textAlign: TextAlign.center,),
        ),
        backgroundColor: isLightTheme?Colors.white.withOpacity(0.9):Colors.grey.withOpacity(0.02),
        elevation: 0,centerTitle: true,
      ),
      backgroundColor: isLightTheme?Colors.white.withOpacity(1):Colors.grey.withOpacity(0.2),
      body:
      isLoading?
      RefreshIndicator(
        onRefresh: () async=> getNewsByQuery(widget.query),
        color: isLightTheme?Colors.black:Colors.white,
        backgroundColor: isLightTheme?Colors.white:Colors.black54,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: catModelList.length,
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
                            tag: catModelList[index].newImage,
                            child: CachedNetworkImage(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover
                              ,
                              imageUrl: catModelList[index].newImage,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageScreen(
                                imageUrl: catModelList[index].newImage,
                                headline: catModelList[index].newsHead,
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
                              onTap: () => _launchURL(catModelList[index].newUrl),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8,right: 8),
                                child: Text(
                                  catModelList[index].newsHead,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: textColor
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(catModelList[index].newUrl),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: Text(
                                  catModelList[index].newDes,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(color: textColor,
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
                              child: Text("Date:${catModelList[index].published.substring(0,10).split("-").reversed.join("-")}"
                                  ,textAlign: TextAlign.left,
                                  style:TextStyle(fontSize: 11.5,color: isLightTheme? Colors.black.withOpacity(0.6):Colors.white.withOpacity(0.8))),
                            ),
                            GestureDetector(
                              onTap: (){
                                _shareNews(catModelList[index].newUrl);
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
    );

  }
}

