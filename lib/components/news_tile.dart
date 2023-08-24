import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/article_screen.dart';
import '../screens/image_screen.dart';


class NewsTile extends StatefulWidget {
  final String image, title, content, date, fullArticle;
  const NewsTile({super.key,
    required this.content,
    required this.date,
    required this.image,
    required this.title,
    required this.fullArticle,
  });

  @override
  State<NewsTile> createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  @override
  void initState() {
    setState(() {
      getTheme();
    });
    super.initState();
  }

  _launchURL(inputUrl) async{
    // var uri = Uri.parse(inputUrl);
    // Fluttertoast.showToast(
    //     msg: "Opening News in Browser",
    //     gravity: ToastGravity.BOTTOM,
    //     toastLength: Toast.LENGTH_LONG
    // );
    // await launchUrl(uri);
    final url = Uri.parse(inputUrl);
    if(await canLaunchUrl(url)){
      Fluttertoast.showToast(
          msg: "Opening News in Browser",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG
      );
      await launchUrl(url,mode: LaunchMode.externalApplication);
    }else{
      print("URL can't be launched.");
    }
  }

  _shareContent() async{
    final String appLink = widget.fullArticle;
    final String message = 'Check out this news article: $appLink';
    await Share.share(message,subject: "Have you read this article? No? Read it here.");
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = isLightTheme?Colors.black:Colors.white;
    return Container(

      decoration:
          const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  tag: 'image-${widget.image}',
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
                    onTap: () {
                      _launchURL(widget.fullArticle);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Text(
                        widget.title,
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
                    onTap: () {
                      _launchURL(widget.fullArticle);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Text(
                        widget.content,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  Container(
                    // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),
                    child: Text("Date: ${widget.date}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
                  ),
                  GestureDetector(
                    onTap: (){
                      _shareContent();
                    },
                    // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.6),
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined,color: Colors.grey.shade600,size: 16,),
                        const SizedBox(width: 4,),
                        Text("Share",style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0))
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
