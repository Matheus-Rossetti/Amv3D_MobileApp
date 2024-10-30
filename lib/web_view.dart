import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.url});

  // final String token;
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
      ..loadRequest(Uri.parse(widget.url), headers: {
        // 'authorization': 'Bearer ${widget.token}',
        // 'cookie': 'authn=${widget.token}'
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OrientationBuilder(builder: (context, orientation) {
        // verifica orientação
        orientation == Orientation.portrait // se for landscape, desliga UI
            ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values)
            : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: []);
        return Column(
          children: [
            Container(
                child: WebViewWidget(controller: controller),
                width: double.infinity,
                height: 800),
          ],
        );
      }),
    );
  }
}
