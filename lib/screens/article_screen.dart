// import 'package:flutter/material.dart';
//
// class LaunchURL extends StatefulWidget {
//   final String url;
//   const LaunchURL({required this.url,super.key});
//
//   @override
//   State<LaunchURL> createState() => _LaunchURLState();
// }
//
// class _LaunchURLState extends State<LaunchURL> {
//
//   _launchURL(String url) async{
//     final Uri url = Uri.parse(widget.url);
//     if(!await _launchURL(widget.url)){
//       throw Exception('Could not launch $url');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _launchURL(widget.url),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import 'article_screen_second.dart';
//
// class WebViewApp extends StatefulWidget {
//   const WebViewApp({super.key});
//
//   @override
//   State<WebViewApp> createState() => _WebViewAppState();
// }
//
// class _WebViewAppState extends State<WebViewApp> {
//   late final WebViewController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..loadRequest(
//         Uri.parse('https://flutter.dev'),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter WebView'),
//         actions: [
//           NavigationControls(controller: controller),
//           Menu(controller: controller),               // ADD
//         ],
//       ),
//       body: WebViewStack(controller: controller),
//     );
//   }
// }
//
// class NavigationControls extends StatelessWidget {
//   const NavigationControls({required this.controller, super.key});
//
//   final WebViewController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             final messenger = ScaffoldMessenger.of(context);
//             if (await controller.canGoBack()) {
//               await controller.goBack();
//             } else {
//               messenger.showSnackBar(
//                 const SnackBar(content: Text('No back history item')),
//               );
//               return;
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () async {
//             final messenger = ScaffoldMessenger.of(context);
//             if (await controller.canGoForward()) {
//               await controller.goForward();
//             } else {
//               messenger.showSnackBar(
//                 const SnackBar(content: Text('No forward history item')),
//               );
//               return;
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.replay),
//           onPressed: () {
//             controller.reload();
//           },
//         ),
//       ],
//     );
//   }
// }


// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive/hive.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../helper/menu_items.dart';
//
// class ArticleScreen extends StatefulWidget {
//   final String articleUrl;
//   ArticleScreen({required this.articleUrl});
//
//   @override
//   _ArticleScreenState createState() => _ArticleScreenState();
// }
//
// class _ArticleScreenState extends State<ArticleScreen> {
//   final Completer<WebViewController> _controller =
//   Completer<WebViewController>();
//   int position = 1;
//   bool _showConnected = false;
//   bool isLightTheme = true;
//
//   late final WebViewController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     Connectivity().onConnectivityChanged.listen((event) {
//       checkConnectivity();
//     });
//     controller = WebViewController()
//       ..loadRequest(
//         Uri.parse(widget.articleUrl),
//       );
//     getTheme();
//   }
//
//   getTheme() async {
//     final settings = await Hive.openBox('settings');
//     setState(() {
//       isLightTheme = settings.get('isLightTheme') ?? false;
//     });
//   }
//
//   checkConnectivity() async {
//     var result = await Connectivity().checkConnectivity();
//     showConnectivitySnackBar(result);
//   }
//
//   void showConnectivitySnackBar(ConnectivityResult result) {
//     var isConnected = result != ConnectivityResult.none;
//     if (!isConnected) {
//       _showConnected = true;
//       Fluttertoast.showToast(
//           msg: "You are Offline",
//           gravity: ToastGravity.BOTTOM,
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Colors.white70,textColor: Colors.red
//       );
//     }
//
//     if (isConnected && _showConnected) {
//       _showConnected = false;
//       Fluttertoast.showToast(
//           msg: "You are Online",
//           gravity: ToastGravity.BOTTOM,
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Colors.white70,textColor: Colors.green
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: isLightTheme
//             ? const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
//             : const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon:const Icon(
//             Icons.close,
//             size: 30,
//           ),
//         ),
//         title:const  Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'News',
//               style: TextStyle(color: Color(0xff50A3A4)),
//             ),
//             Text(
//               'Wipe',
//               style: TextStyle(color: Color(0xffFCAF38)),
//             ),
//             SizedBox(width: 20),
//           ],
//         ),
//         actions: <Widget>[
//           PopupMenuButton(
//             itemBuilder: (BuildContext context) {
//               return MenuItems.choices.map((String choice) {
//                 return PopupMenuItem(
//                   child: Text(choice),
//                   value: choice,
//                 );
//               }).toList();
//             },
//             onSelected: choiceAction,
//           )
//         ],
//       ),
//       body: IndexedStack(
//         index: position,
//         children: [
//           WebView(
//             initialUrl: widget.articleUrl,
//             javascriptMode: JavascriptMode.unrestricted,
//             onPageStarted: (value) {
//               setState(() {
//                 position = 1;
//               });
//             },
//             onPageFinished: (value) {
//               setState(() {
//                 position = 0;
//               });
//             },
//             onWebViewCreated: ((WebViewController webViewController) {
//               _controller.complete(webViewController);
//             }),
//           ),
//           Container(
//             child: Center(child: CircularProgressIndicator()),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void choiceAction(String choice) {
//     if (choice == MenuItems.Copy) {
//       Clipboard.setData(ClipboardData(text: widget.articleUrl));
//       Fluttertoast.showToast(
//         msg: "Link Copied",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         fontSize: 16.0,
//       );
//     } else if (choice == MenuItems.Open_In_Browser) {
//       launch(widget.articleUrl);
//     } else if (choice == MenuItems.Share) {
//       Share.share(widget.articleUrl);
//     }
//   }
// }
