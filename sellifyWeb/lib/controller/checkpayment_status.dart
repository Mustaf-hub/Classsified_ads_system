// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CheckpaymentStatus extends GetxController implements GetxService {
//
//   String paymentStatus = "";
//   Future verifyPayment(String token, String status) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final clientId = prefs.getString("clientId");
//     final secret = prefs.getString("secretId");
//     print("PAYMENT CHECK 2 $clientId $secret");
//
//     final authResponse = await http.post(
//       Uri.parse('${status == "0" ? "https://api-m.sandbox.paypal.com" : "https://api-m.paypal.com"}/v1/oauth2/token'),
//       headers: {
//         'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$secret')),
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: 'grant_type=client_credentials',
//     );
//
//     print("PAYMENT CHECK 3");
//
//     if (authResponse.statusCode != 200) {
//
//         paymentStatus = 'Failed to get PayPal token';
//         update();
//       return;
//     }
//     final authData = jsonDecode(authResponse.body);
//     print("FIRST VERIFICATION FOR $authData");
//     final accessToken = authData['access_token'];
//     // Verify Order Status
//     final orderResponse = await http.get(
//       Uri.parse('${status == "0" ? "https://api-m.sandbox.paypal.com" : "https://api-m.paypal.com"}/v2/checkout/orders/$token'),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//         'Content-Type': 'application/json',
//       },
//     );
//     if (orderResponse.statusCode == 200) {
//       final orderData = jsonDecode(orderResponse.body);
//       final orderStatus = orderData['status'];
//
//       String? transactionId;
//       if (orderStatus == 'COMPLETED') {
//         final captures = orderData['purchase_units'][0]['payments']['captures'];
//         if (captures != null && captures.isNotEmpty) {
//           transactionId = captures[0]['id'];
//         }
//       }
//         paymentStatus = orderStatus == 'COMPLETED'
//             ? 'Payment Successful :white_check_mark:\nTransaction ID: $transactionId'
//             : 'Payment Not Completed :x:';
//       update();
//       return orderData;
//     } else {
//         paymentStatus = 'Payment verification failed!';
//         update();
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:sellify/helper/c_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckpaymentStatus extends GetxController implements GetxService {


  Future verifyPaypalPayment(String orderId, String status) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final clientId = prefs.getString("clientId");
  final secret = prefs.getString("secretId");
    final String credentials = base64Encode(utf8.encode('$clientId:$secret'));
    final Uri url = Uri.parse('https://api-m.sandbox.paypal.com/v2/checkout/orders/$orderId/capture');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic>? captures = responseData['purchase_units'][0]['payments']['captures'];
      if (captures != null && captures.isNotEmpty) {
        return {
          "status" : captures[0]["status"],
          "id" : captures[0]['id']
        };
      }
      return ':white_check_mark: Payment Captured, but no Transaction ID found.';
    } else {
      return ':x: Payment Capture Failed!';
    }
  }

  Future verifyPaystackPayment(String reference) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String paystackSecretKey = prefs.getString("secretKey")!;
    update();
    final String url = 'https://api.paystack.co/transaction/verify/$reference';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $paystackSecretKey',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data']['status'] == 'success') {
        String transactionId = data['data']['id'].toString();

        return {
          "status" : data["data"]["status"],
          "id" : transactionId
        };
      } else {
      }
    } else {
    }
  }

  Future verifyStripePayment(sessionId) async {
    // Get the session_id from URL

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final secretKey = prefs.getString("secretKey");

    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/checkout/sessions/$sessionId'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String paymentStatus = data['payment_status'];


      if (paymentStatus == 'paid') {
        return data;
      } else {
        showToastMessage(data['payment_status']);
        return data;
      }
    } else {
    }
  }

  // Future verifyStripePayment(sessionId) async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   final secretKey = prefs.getString("secretId");
  //   final response = await http.get(
  //     Uri.parse('https://api.stripe.com/v1/checkout/sessions/$sessionId'),
  //     headers: {
  //       'Authorization': 'Bearer $secretKey',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print("DATA STRIPE $data");
  //     String paymentStatus = data['payment_status'];
  //     String transactionId = data['payment_intent'];
  //     print('Payment Status: $paymentStatus');
  //     print('Transaction ID: $transactionId');
  //     if (paymentStatus == 'paid') {
  //       print(':white_check_mark: Payment Successful!');
  //     } else {
  //       print(':x: Payment Not Completed!');
  //     }
  //   } else {
  //     print('Failed to verify payment. Error: ${response.body}');
  //   }
  // }
}