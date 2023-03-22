library email_otp;

import 'dart:convert';
import 'package:http/http.dart' as http;

enum OTPType { digitsOnly, stringOnly, mixed }

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

  //Custom OTP Type
  String? _type;

  ///Function use to config Email OTP
  setConfig({appName, appEmail, userEmail, otpLength, otpType}) {
    _appName = appName;
    _appEmail = appEmail;
    _userEmail = userEmail;
    _otpLength = otpLength;
    switch (otpType) {
      case OTPType.digitsOnly:
        _type = "digits";
        break;
      case OTPType.stringOnly:
        _type = "string";
        break;
      case OTPType.mixed:
        _type = "mixed";
        break;
    }
  }

  ///Function will return true / false
  sendOTP() async {
    var url = Uri.parse(
      'https://flutter.rohitchouhan.com/email-otp/v3.php?app_name=$_appName&app_email=$_appEmail&user_email=$_userEmail&otp_length=$_otpLength&type=$_type',
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
