library email_otp;

import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailOTP {
  /// Name of your application.
  static String? appName;

  /// Your email address.
  static String? appEmail;

  ///Email address of client, where you want to send OTP
  static String? userEmail;

  ///Will save correct OTP
  static String? getOTP;

  //Custom length for otp digits
  static int? otpLength;

  ///Function use to config Email OTP
  setConfig({appName, appEmail, userEmail, otpLength}) {
    appName = appName;
    appEmail = appEmail;
    userEmail = userEmail;
    otpLength = otpLength;
  }

  ///Function will return true / false
  sendOTP() async {
    var url = Uri.parse(
      'https://flutter.rohitchouhan.com/email-otp/v2.php?app_name=$appName&app_email=$appEmail&user_email=$userEmail&otp_length=$otpLength',
    );
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        if (decodedData['status'] == true) {
          getOTP = decodedData['otp'].toString();
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
    if (getOTP == otp) {
      print("OTP has been verified! ✅");
      return true;
    } else {
      print("OTP is invalid ❌");
      return false;
    }
  }
}
