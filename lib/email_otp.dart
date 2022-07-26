library email_otp;

import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailOTP {
  /// Name of your application.
  String? _appName;

  /// Your email address.
  String? _appEmail;

  ///Email address of client, where you want to send OTP
  String? _userEmail;

  ///Will save correct OTP
  String? _getOTP;

  //Custom length for otp digits
  int? _otpLength;

  ///Function use to config Email OTP
  setConfig({appName, appEmail, userEmail, otpLength}) {
    _appName = appName;
    _appEmail = appEmail;
    _userEmail = userEmail;
    _otpLength = otpLength;
  }

  ///Function will return true / false
  sendOTP() async {
    var url = Uri.parse(
      'https://flutter.rohitchouhan.com/email-otp/v2.php?app_name=$_appName&app_email=$_appEmail&user_email=$_userEmail&otp_length=$_otpLength',
    );
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        if (decodedData['status'] == true) {
          _getOTP = decodedData['otp'].toString();
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
    if (_getOTP == otp) {
      print("OTP has been verified! ✅");
      return true;
    } else {
      print("OTP is invalid ❌");
      return false;
    }
  }
}
