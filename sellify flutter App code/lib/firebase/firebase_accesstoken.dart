import 'package:googleapis_auth/auth_io.dart';

import '../api_config/config.dart';

class FirebaseAccesstoken {
  static String firebaseMessageScope = "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final credentials = ServiceAccountCredentials.fromJson({
      
    });

    final client = await clientViaServiceAccount(credentials, [firebaseMessageScope]);

    final accessToken = client.credentials.accessToken.data;
    Config.firebaseKey = accessToken;
    print("+++++++++++++++++:---- ${Config.firebaseKey}");
    return accessToken;
  }

}