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

  //SMTP Host Name
  String? _host;

  //SMTP Auth
  bool? _auth;

  //SMTP Username
  String? _username;

  //SMTP Password
  String? _password;

  //SMTP Secure
  String? _secure;

  //SMTP Port
  int? _port;

  //Custom HTML Template
  String? _template;

  //Customize Theme
  String? _theme;

  //Function to set custom SMTP Configuration
  setSMTP({host, auth, username, password, secure, port}) {
    _host = host;
    _auth = auth;
    _username = username;
    _password = password;
    _secure = secure;
    _port = port;
  }

  //Function to set custom theme
  setTheme({theme}) {
    _theme = theme;
  }

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

  ///Function use to use custom html template
  setTemplate({render}) {
    _template = render;
  }

  ///Function will return true / false
  sendOTP() async {
    var url = Uri.parse('https://flutter.rohitchouhan.com/email-otpV2/v2.php');
    Map<String, dynamic> body = {
      "app_name": _appName,
      "app_email": _appEmail,
      "user_email": _userEmail,
      "otp_length": _otpLength,
      "type": _type,
      "template": _template,
      "theme": _theme,
      "smtp_host": _host,
      "smtp_auth": _auth,
      "smtp_username": _username,
      "smtp_password": _password,
      "smtp_secure": _secure,
      "smtp_port": _port
    };
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        if (decodedData['status'] == true) {
          _getOTP = decodedData['otp'].toString();
          return true;
        } else {
          String errorMessage = decodedData[
              'message']; // Assuming the error message key is 'message'
          throw Exception(
              errorMessage); // Throwing an error with the response message
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      return false;
    }
  }

  ///Function will return true / false
  verifyOTP({otp}) {
    if (_getOTP == otp) {
      return true;
    } else {
      return false;
    }
  }
}
