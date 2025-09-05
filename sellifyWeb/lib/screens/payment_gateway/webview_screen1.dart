import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView1 extends StatefulWidget {
  final String initialUrl;
  const PaymentWebView1({super.key, required this.initialUrl});

  @override
  State<PaymentWebView1> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView1> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          print("🔄 Navigating to: ${request.url}");

          // Prevent opening in a new tab
          if (!request.isMainFrame) {
            _controller.loadRequest(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) {
          print("✅ Page loaded: $url");

          // Detect payment success or failure
          if (url.contains("status=successful")) {
            print("🎉 Payment Successful!");
            Navigator.pop(context, "Payment Successful");
          } else if (url.contains("status=failed")) {
            print("❌ Payment Failed!");
            Navigator.pop(context, "Payment Failed");
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
