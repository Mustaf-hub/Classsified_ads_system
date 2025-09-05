import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/screens/payment_gateway/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPaymentController extends GetxController implements GetxService {

  String url = "";
  bool isLoading = true;
  Future getPaymentUrl({required Map body, required String url, String? paymentGateway}) async {

    var response = await http.post(Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      if(result["Result"] == "true"){
        url = result["url"] ?? result["payment_url"];
        isLoading = false;
        update();
        if (paymentGateway == "Stripe" || paymentGateway == "SenangPay" || paymentGateway == "Payfast" || paymentGateway == "Khalti Payment" || paymentGateway == "Paypal") {
          if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false, forceWebView: true, webOnlyWindowName: '_self');
          } else {
            throw 'Could not launch $url';
          }
        } else {
          Get.to(PaymentWebVIew(initialUrl: url), transition: Transition.noTransition);
        }
      }
    }
  }
}