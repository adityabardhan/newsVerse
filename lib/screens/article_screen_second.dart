// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewStack extends StatefulWidget {
//   const WebViewStack({required this.controller, super.key});
//
//   final WebViewController controller;
//
//   @override
//   State<WebViewStack> createState() => _WebViewStackState();
// }
//
// class _WebViewStackState extends State<WebViewStack> {
//   var loadingPercentage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.controller
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             setState(() {
//               loadingPercentage = 0;
//             });
//           },
//           onProgress: (progress) {
//             setState(() {
//               loadingPercentage = progress;
//             });
//           },
//           onPageFinished: (url) {
//             setState(() {
//               loadingPercentage = 100;
//             });
//           },
//           onNavigationRequest: (navigation) {
//             final host = Uri.parse(navigation.url).host;
//             if (host.contains('youtube.com')) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'Blocking navigation to $host',
//                   ),
//                 ),
//               );
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//     // Modify from here...
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel(
//         'SnackBar',
//         onMessageReceived: (message) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(message.message)));
//         },
//       );
//     // ...to here.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         WebViewWidget(
//           controller: widget.controller,
//         ),
//         if (loadingPercentage < 100)
//           LinearProgressIndicator(
//             value: loadingPercentage / 100.0,
//           ),
//       ],
//     );
//   }
// }
//
// enum _MenuOptions {
//   navigationDelegate,
//   userAgent,
//   javascriptChannel,
// }
//
// class Menu extends StatefulWidget {
//   const Menu({required this.controller, super.key});
//
//   final WebViewController controller;
//
//   @override
//   State<Menu> createState() => _MenuState();
// }
//
// class _MenuState extends State<Menu> {
//   final cookieManager = WebViewCookieManager();
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<_MenuOptions>(
//       onSelected: (value) async {
//         switch (value) {
//           case _MenuOptions.navigationDelegate:
//             await widget.controller
//                 .loadRequest(Uri.parse('https://youtube.com'));
//             break;
//           case _MenuOptions.userAgent:
//             final userAgent = await widget.controller
//                 .runJavaScriptReturningResult('navigator.userAgent');
//             if (!mounted) return;
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text('$userAgent'),
//             ));
//             break;
//           case _MenuOptions.javascriptChannel:
//             await widget.controller.runJavaScript('''
// var req = new XMLHttpRequest();
// req.open('GET', "https://api.ipify.org/?format=json");
// req.onload = function() {
//   if (req.status == 200) {
//     let response = JSON.parse(req.responseText);
//     SnackBar.postMessage("IP Address: " + response.ip);
//   } else {
//     SnackBar.postMessage("Error: " + req.status);
//   }
// }
// req.send();''');
//             break;
//         }
//       },
//       itemBuilder: (context) => [
//         const PopupMenuItem<_MenuOptions>(
//           value: _MenuOptions.navigationDelegate,
//           child: Text('Navigate to YouTube'),
//         ),
//         const PopupMenuItem<_MenuOptions>(
//           value: _MenuOptions.userAgent,
//           child: Text('Show user-agent'),
//         ),
//         const PopupMenuItem<_MenuOptions>(
//           value: _MenuOptions.javascriptChannel,
//           child: Text('Lookup IP Address'),
//         ),
//       ],
//     );
//   }
// }
//
// /*var req = new XMLHttpRequest();
// req.open('GET', "https://api.ipify.org/?format=json");
// req.onload = function() {
// if (req.status == 200) {
// SnackBar.postMessage(req.responseText);
// } else {
// SnackBar.postMessage("Error: " + req.status);
// }
// }
// req.send();*/
