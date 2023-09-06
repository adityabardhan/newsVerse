import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AnewPage/loginPage.dart';
import 'package:newsverse/AnewPage/registerPage.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

// OnBoarding content list
final List<OnBoard> demoData = [
  OnBoard(
    image: "https://i.ibb.co/J5VYPgp/read1.png",
    // image: "https://i.ibb.co/sbFFHp8/man-holding-newspaper-reading-daily-news-press-mass-media-concept-businessman-sitting-armchair-48369.png",
    title: "Bored of Reading NewsPaper?",
    description:
    "Get rid of reading news traditional & old ways, just download the app and read it digitally",
  ),
  OnBoard(
    image: "https://i.ibb.co/mRgN3jZ/read.png",
    // image: "https://i.ibb.co/sqjskXb/read3.png",
    // image: "https://i.ibb.co/SKsxXw6/read2.png", 3d sit
    // image: "https://i.ibb.co/PDCbDjQ/mobil-use.png",
    // image: "https://i.ibb.co/nDq2WnT/man-is-sitting-chatting-mobile-phone-294791-204-removebg-preview.png",
    // image: "https://img.freepik.com/free-vector/people-watching-breaking-"
    //     "news-phone_23-2148608054.jpg?size=626&ext=jpg&ga=GA1.2.1431409367.1693049691&semt=ais",
    title: "Anyone-Anywhere-Anytime",
    description:
    "Switch to the latest mode of News Reading with 'NewsVerse' and enjoy latest news articles",
  ),
  OnBoard(
    image: "https://i.ibb.co/Pt5kPhj/read7.png",
    // image: "https://i.ibb.co/2snYfKL/third.png
    //https://i.ibb.co/PDCbDjQ/mobil-use.png",
    // image: "https://img.freepik.com/free-vector/waiter-serving-gold-quality-star-vip-customers-funny-person-holding-tray-with-premium-gift-bonus-working-restaurant-service-flat-vector-illustration-advertisement-"
    //     "hospitality-concept_74855-22596.jpg?size=626&ext=jpg&ga=GA1.1.1431409367.1693049691&semt=sph",
    title: "Convenient Customer Support",
    description:
    "Report any Malicious, Fake or Inaccurate news in the 'Contact Us' Section of the App",
  ),
];

// OnBoardingScreen
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Variables
  late PageController _pageController;
  int _pageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialize page controller
    _pageController = PageController(initialPage: 0);
    // Automatic scroll behaviour
    _timer = Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_pageIndex < 3) {
        _pageIndex++;
      } else {
        _pageIndex = 0;
      }
      _pageController.animateToPage(
        _pageIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    // Dispose everything
    _pageController.dispose();
    _timer!.cancel();
    super.dispose();
  }

  bool switch1 = false;
  bool switch2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Background gradient
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              // Color(0xff1f005c),
              // Color(0xff5b0060),
              // Color(0xff870160),
              // Color(0xffac255e),
              // Color(0xffca485c),
              // Color(0xffe16b5c),
              // Color(0xfff39060),
              // Color(0xffffb56b),
              Colors.green.shade500,
              Colors.green.shade400,
              Colors.green.shade200,
              Colors.greenAccent.shade400,
              Colors.greenAccent.shade200
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          children: [
            // Carousel area
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemCount: demoData.length,
                controller: _pageController,
                itemBuilder: (context, index) => OnBoardContent(
                  title: demoData[index].title,
                  description: demoData[index].description,
                  image: demoData[index].image,
                ),
              ),
            ),
            // Indicator area
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    demoData.length,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DotIndicator(
                        isActive: index == _pageIndex,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            // Privacy policy area
            const Text("This app will build the future and will change people’s lives",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
            // White space
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              // height: Get.height * 0.075,
              // width: Get.width,
              // decoration: BoxDecoration(
              //   color: Colors.purple,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(onPressed: (){},
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.indigoAccent.shade700.withOpacity(0.75),
                    //     elevation: 2.5,
                    //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)),
                    //     side: BorderSide(color: Colors.white38)),
                    //     fixedSize: Size(MediaQuery.of(context).size.width*0.35, MediaQuery.of(context).size.height*0.065)
                    //   ), child: const Text(
                    //   "Login",
                    //   style: TextStyle(
                    //     fontFamily: "HappyMonkey",
                    //     color: Colors.white,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    // ),
                    // LiteRollingSwitch(
                    //   onTap: (){
                    //     Fluttertoast.showToast(
                    //         msg: "Swipe Me to Login",
                    //         toastLength: Toast.LENGTH_LONG,
                    //         backgroundColor: Colors.white,
                    //         textColor: Colors.red.shade900);
                    //   },
                    //   width: 160,
                    //   textSize: 16,
                    //   value: false,
                    //   textOn: "      Swipe Me      ",
                    //   textOff: 'LOGIN',
                    //   textOnColor: Colors.white,
                    //   // colorOn: Colors.blueGrey.shade800,
                    //   colorOn:Colors.blueGrey.shade800.withOpacity(0.7),
                    //   colorOff: Colors.blueGrey.shade800.withOpacity(0.7),
                    //   iconOn: Icons.error_outline_rounded,
                    //   iconOff: Icons.keyboard_double_arrow_right_outlined,
                    //   onChanged: (bool state) {
                    //
                    //   }, onDoubleTap: (){
                    //   Fluttertoast.showToast(
                    //       msg: "Swipe Me to Login",
                    //       toastLength: Toast.LENGTH_LONG,
                    //       backgroundColor: Colors.white,
                    //       textColor: Colors.red.shade900);
                    // }, onSwipe: (){
                    //     Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                    // },
                    // ),
                    // LiteRollingSwitch(
                    //   onTap: (){
                    //     Fluttertoast.showToast(
                    //         msg: "Swipe Me to Signup",
                    //         toastLength: Toast.LENGTH_LONG,
                    //         backgroundColor: Colors.white,
                    //         textColor: Colors.red.shade900);
                    //   },
                    //   width: 160,
                    //   textSize: 16,
                    //   value: false,
                    //   textOn: "      Swipe Me      ",
                    //   textOff: 'SIGNUP',
                    //   textOnColor: Colors.white,
                    //   colorOn: Colors.blueGrey.shade800.withOpacity(0.7),
                    //   colorOff: Colors.blueGrey.shade800.withOpacity(0.7),
                    //   iconOn: Icons.error_outline_rounded,
                    //   iconOff: Icons.keyboard_double_arrow_right_outlined,
                    //   onChanged: (bool state) {
                    //
                    //   }, onDoubleTap: (){
                    //   Fluttertoast.showToast(
                    //       msg: "Swipe Me to Signup",
                    //       toastLength: Toast.LENGTH_LONG,
                    //       backgroundColor: Colors.white,
                    //       textColor: Colors.red.shade900);
                    // }, onSwipe: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                    // },
                    // ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
                        child: SwipeableButtonView(
                          buttonText: "     LOGIN",
                          buttonColor: Colors.white70,
                          buttontextstyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                          fontSize: 14.5,fontStyle: FontStyle.italic,leadingDistribution: TextLeadingDistribution.even,
                          letterSpacing: 1.2),
                          buttonWidget: Container(
                            child: const Icon(Icons.keyboard_double_arrow_right_outlined,color: Colors.black,size: 26,),
                          ),
                          activeColor: Colors.blueGrey.shade800.withOpacity(0.68),
                          isFinished: switch1,
                          onWaitingProcess: (){
                            Future.delayed(const Duration(milliseconds: 1350),(){
                              setState(() {
                                switch1 = true;
                              });
                            });
                          },
                          onFinish: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                            setState(() {
                              switch1 = false;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
                        child: SwipeableButtonView(
                          buttonText: "       SIGNUP",
                          buttonColor: Colors.white70,
                          buttontextstyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                              fontSize: 14.5,fontStyle: FontStyle.italic,leadingDistribution: TextLeadingDistribution.even,
                          letterSpacing: 1.2),
                          buttonWidget: Container(
                            child: const Icon(Icons.keyboard_double_arrow_right_outlined,color: Colors.black,size: 26,),
                          ),
                          activeColor: Colors.blueGrey.shade800.withOpacity(0.68),
                          isFinished: switch2,
                          onWaitingProcess: (){
                            Future.delayed(const Duration(milliseconds: 1350),(){
                              setState(() {
                                switch2 = true;
                              });
                            });
                          },
                          onFinish: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                            setState(() {
                              switch2 = false;
                            });
                          },
                        ),
                      ),
                    ),
                    // ElevatedButton(onPressed: (){},
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.indigoAccent.shade700.withOpacity(0.75),
                    //       elevation: 2.5,
                    //       shape: StadiumBorder(),
                    //       fixedSize: Size(MediaQuery.of(context).size.width*0.35, MediaQuery.of(context).size.height*0.065)
                    //   ),
                    //   child: const Text(
                    //   "Signup",
                    //   style: TextStyle(
                    //     fontFamily: "HappyMonkey",
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 17.5,
                    //   ),
                    // ),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// OnBoarding area widget
class OnBoardContent extends StatelessWidget {
  OnBoardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  String image;
  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        // const Spacer(),
        const SizedBox(height: 20,),
        Image.network(image),
        const Spacer(),
      ],
    );
  }
}

// Dot indicator widget
class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.red.shade400.withOpacity(0.6) : Colors.white,
        border: isActive ? null : Border.all(color: Colors.orangeAccent.shade700),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}