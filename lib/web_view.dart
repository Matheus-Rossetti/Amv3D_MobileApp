import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.url, required this.token});

  final String token;
  final String url;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    WebViewCookieManager().clearCookies();

    controller = WebViewController()
      ..clearLocalStorage()
      ..clearCache()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
      // * ensures the token is in the cookies for every subsequent request
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            controller
                .runJavaScript("document.cookie = 'authn=${widget.token}';");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url), headers: {
        // 'authorization': 'Bearer ${widget.token}',
        'cookie': 'authn=${widget.token}'
      });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      // verifica orientação
      orientation == Orientation.portrait // se for landscape, desliga UI
          ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values)
          : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
      return WebViewWidget(controller: controller);
    });
  }
}
