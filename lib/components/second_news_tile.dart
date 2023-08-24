import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/secondApiCall.dart';
import '../screens/image_screen.dart';

class SecondNewsTile extends StatefulWidget {
  int index;
  String title,description,image,url,date,content;
  SecondNewsTile({required this.index,required this.title,required this.description,
    required this.image,required this.url,required this.date,required this.content,super.key});

  @override
  State<SecondNewsTile> createState() => _SecondNewsTileState();
}

class _SecondNewsTileState extends State<SecondNewsTile> {

  List<SecondNewsModel> catModelList = [];
  bool isLoading  = false;

  getNewsByQuery()async {
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
            isLoading = true;
          });
          if (i == 25) break;
        } catch (e) {
          print("57, Categories $e");
        }
      }
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

  int? maxLines = 3;
  String secTitle = "";
  @override
  void initState() {
    getNewsByQuery();
    getTheme();
    super.initState();
    if (widget.title.length >= 70){
      secTitle = "${widget.title.substring(0,60)} ...";
    }
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

  bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    Color textColor = !isLightTheme?Colors.white:Colors.black;
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
                  tag: widget.image,
                  child: CachedNetworkImage(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover
                    ,
                    imageUrl: widget.image,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      imageUrl: widget.image,
                      headline: widget.title,
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
                    onTap: () => _launchURL(widget.url),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: textColor
                        ),
                      )
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(widget.url),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Text(
                        widget.description,
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
                          child: Text("Date:${widget.date.substring(0,10).split("-").reversed.join("-")}"
                              ,textAlign: TextAlign.left,
                              style:TextStyle(fontSize: 11.5,color:isLightTheme? Colors.black.withOpacity(0.6):Colors.white.withOpacity(0.8))),
                        ),
                        GestureDetector(
                          onTap: (){
                            _shareNews(widget.url);
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
}
