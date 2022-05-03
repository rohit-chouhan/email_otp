library email_otp;

import 'dart:convert';
import 'package:http/http.dart' as http;

/// A Email OTP Class
class Email_OTP {
  ///Name of your app, so user will receive mail from this name
  static String? app_name;

  ///Your email, from where you want to send mail
  static String? app_email;

  ///Email address of client, where you want to send OTP
  static String? user_email;

  ///Will save correct OTP
  static String? get_otp;

  ///Function use to config Email OTP
  setConfig({appName, appEmail, userEmail}) {
    app_name = appName;
    app_email = appEmail;
    user_email = userEmail;
  }

  ///Function will return true / false
  sendOTP() async {
    var url = Uri.parse(
      'https://flutter.rohitchouhan.com/email-otp?app_name=${app_name}&app_email=${app_email}&user_email=${user_email}',
    );
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        if (decodedData['status'] == true) {
          get_otp = decodedData['otp'].toString();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ///Function will return true / false
  verifyOTP({otp}) {
    if (get_otp == otp) {
      print("OTP has been verified! ✅");
      return true;
    } else {
      print("OTP is invalid ❌");
      return false;
    }
  }
}
