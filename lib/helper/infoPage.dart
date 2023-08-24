import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:transition/transition.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> with TickerProviderStateMixin {

  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: (){
            Navigator.of(context).pop();
          },
          color: Colors.black87,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:const  EdgeInsets.all(20),
          alignment: Alignment.center,
          child:Column(
            children: [
              Lottie.asset("assets/icons/read.json",repeat: false,reverse: true),
              const SizedBox(height: 20,),
              const  Text(
                '''Welcome to the news App! This app's goal is to provide you with the latest news and information from around the world, and to keep you updated in the matter of current affairs and general knowledge.

It is the most accurate and up-to-date news application from reliable sources, and it delivers the news in a timely and accessible manner.

The app features a variety of categories, including business, politics, sports, entertainment, and more. You can view news according to your preferences and choices. This app also has a search bar to search for the news you’re looking for.

The users do not need to worry about their privacy and data leaks as there will be none. This app is created in such a manner to keep your precious data to yourself only. 

It comes with dark and light mode feature and also readers can view the complete article in their web browser by clicking the news links.

Developing an application is not easy but I’m ready to serve the nation and to add any functionalities of yours choice. 

Kindly leave a feedback after using the application, Thank you for choosing this app as your go-to source for news and information.
I hope to make your user experience more easy and simplified.  ''',
                textAlign: TextAlign.justify,
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.w400,fontStyle: FontStyle.italic,color: Colors.black),
              ),
            ],
          )
        ),
      ),
    );
  }
}
