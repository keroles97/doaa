import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  final String _url = 'https://do3a.net';
  late WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  bool _isLoading = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0.0, 0.0),
        child: Container(),
      ),
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () => _handleBack(context),
            child: WebView(
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controllerCompleter.future
                    .then((value) => _controller = value);
                _controllerCompleter.complete(webViewController);
              },
              gestureNavigationEnabled: false,
              navigationDelegate: (NavigationRequest request) {
                if (kDebugMode) {
                  print('url: ${request.url}');
                }
                if (request.url.contains("mailto:") ||
                    request.url.contains("tel:") ||
                    request.url.contains("messenger") ||
                    request.url.contains("instagram") ||
                    request.url.contains("twitter") ||
                    request.url.contains("snap") ||
                    request.url.contains("whats") ||
                    request.url.contains("facebook") ||
                    request.url.contains("intent") ||
                    request.url.contains("telegram") ||
                    request.url.contains("apk") ||
                    request.url.contains("media") ||
                    request.url.contains("sms")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _isOnline = false;
                  _isLoading = false;
                });
                if (kDebugMode) {
                  print("WebView is error (error : $error%)");
                }
              },
              onProgress: (int progress) {
                if (progress == 100) {
                  setState(() {
                    _isLoading = false;
                  });
                } else {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (kDebugMode) {
                  print("WebView is loading (progress : $progress%)");
                }
              },
              onPageStarted: (String url) async {
                _checkInternet();
                if (kDebugMode) {
                  print('Page started callback');
                }
              },
              onPageFinished: (String url) async {
                setState(() {
                  _isLoading = false;
                });
                if (kDebugMode) {
                  print('Page finished loading: $url');
                }
              },
              // gestureRecognizers: Set()
              //   ..add(Factory<VerticalDragGestureRecognizer>(
              //       () => VerticalDragGestureRecognizer()
              //         ..onDown = (DragDownDetails dragDownDetails) {
              //           _controller.getScrollY().then((y) {
              //             if (kDebugMode) {
              //               print('y value: $y');
              //               print('globalPosition: ${dragDownDetails.globalPosition}');
              //               print('dx: ${dragDownDetails.globalPosition.dx}');
              //               print('dy: ${dragDownDetails.globalPosition.dy}');
              //               print(
              //                   'direction: ${dragDownDetails.globalPosition.direction}');
              //               print(
              //                   'localPosition: ${dragDownDetails.localPosition}');
              //             }
              //             if (y == 0 &&
              //                 dragDownDetails.globalPosition.direction < 1 &&
              //                 dragDownDetails.globalPosition.direction > 0.7 &&
              //                 dragDownDetails.globalPosition.dy < 400
              //             ) {
              //               _controller.reload();
              //             }
              //           });
              //         })),
            ),
          ),
          Positioned(
            top: 0,
            right: 1,
            left: 1,
            child: Center(
              child: SizedBox(
                height: size.height * .13,
                width: size.width * .5,
                child: RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () async {
                    if (kDebugMode) {
                      print('refreshing');
                    }
                    _controller.reload();
                    return Future.delayed(
                        const Duration(milliseconds: 1), () {});
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: size.height * .2,
                      width: size.width * .5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                      child: const CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )))
              : Stack(),
          _isOnline
              ? Stack()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: RefreshIndicator(
                    color: Colors.black,
                    onRefresh: () async {
                      if (kDebugMode) {
                        print('refreshing');
                      }
                      _controller.reload();
                      return Future.delayed(const Duration(seconds: 2), () {});
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: const Text(
                            "تاكد من الاتصال بالانترنت تم اسحب لاسفل",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _checkInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == true) {
      Timer(const Duration(microseconds: 1000), () {
        setState(() {
          _isOnline = true;
        });
      });
    } else {
      setState(() {
        _isOnline = false;
        _isLoading = false;
      });
    }
  }

  Future<bool> _handleBack(context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'هل تريد اغلاق التطبيق',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('عودة',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('اغلاق',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ));
      return false;
    }
  }
}
