library email_otp;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Enumerations for [OTPType]
enum OTPType { numeric, alpha, alphaNumeric }

/// Enumerations for [EmailPort]
enum SecureType { ssl, tls, none }

/// Enumerations for [EmailPort]
enum EmailPort { port25, port587, port465 }

/// Enumerations for [EmailTheme]
enum EmailTheme { v1, v2, v3, v4, v5 }

/// Email OTP
class EmailOTP {
  // OTP response
  static late String _otpResponse;

  // App Name
  static String? _appName;

  // Developer's Email
  static String? _appEmail;

  // OTP Length
  static int? _otpLength;

  // OTP Type
  static OTPType? _otpType;

  // Email Theme
  static EmailTheme? _emailTheme;

  // Email Port
  static EmailPort? _emailPort;

  // Secure Type
  static SecureType? _secureType;

  // SMTP Host
  static String? _host;

  // SMTP Username
  static String? _username;

  // SMTP Password
  static String? _password;

  // Email Template
  static String? _template;

  /// Configure the EmailOTP package is by calling the [config] method
  /// * [appName] representing the name of your application
  /// * [appEmail] The email address from which the OTP emails will be sent.
  /// * [otpLength] An integer specifying the length of the OTP. The default is 6.
  /// * [otpType] Specifies the type of OTP to be generated. The default is [OTPType.numeric]
  ///   *[OTPType.numeric] : OTP will consist only of numbers.
  ///   *[OTPType.alpha] : OTP will consist only of alphabetic characters.
  ///   *[OTPType.alphaNumeric] : OTP will consist of both alphabetic characters and numbers.
  /// * [emailTheme] Defines the theme for the OTP email. The default is [EmailTheme.v5].
  /// The package currently supports five themes: [EmailTheme.v1], [EmailTheme.v2], [EmailTheme.v3], [EmailTheme.v4], and [EmailTheme.v5].
  static config({
    String? appName,
    String? appEmail,
    int? otpLength,
    OTPType? otpType,
    EmailTheme? emailTheme,
  }) {
    _appName = appName ?? "Email OTP";
    _appEmail = appEmail ?? "noreply@email-otp.rohitchouhan.com";
    _otpLength = otpLength ?? 6;
    _otpType = otpType ?? OTPType.numeric;
    _emailTheme = emailTheme ?? EmailTheme.v5;
  }

  /// Use the [setSMTP] method to provide the necessary SMTP server details.
  /// * [host] : The hostname of your SMTP server.
  /// * [emailPort] : The port number used by the SMTP server.
  ///   * [EmailPort.port25]
  ///   * [EmailPort.port465]
  ///   * [EmailPort.port587]
  /// * [secureType] The type of security used by the SMTP server.
  ///   * [SecureType.none]
  ///   * [SecureType.tls]
  ///   * [SecureType.ssl]
  /// * The [username] for your SMTP server account.
  /// * The [password] for your SMTP server account.
  static setSMTP({
    required EmailPort emailPort,
    required SecureType secureType,
    required String host,
    required String username,
    required String password,
  }) {
    _emailPort = emailPort;
    _secureType = secureType;
    _host = host;
    _username = username;
    _password = password;
  }

  /// You can also customize the email template used to send the OTP. Use the [setTemplate] method to provide your own HTML template.
  /// * [template] : A string containing the HTML template for the email.
  static setTemplate({required String? template}) {
    _template = template;
  }

  /// To send an OTP to a user's email address, use the [sendOTP] method. This method takes the recipient's email address as a parameter.
  /// * [email] : The email address to which the OTP will be sent.
  static Future<bool> sendOTP({required String email}) async {
    // Base URL
    String baseUrl = "https://email-otp.rohitchouhan.com";
    Uri uri = Uri.parse("$baseUrl/v3");
    // Headers
    Map<String, String>? headers = {
      "Content-Type": "application/json",
      'X-Flutter-Request': "true"
    };
    // Body
    Map<String, dynamic>? body = {
      "app_name": _appName,
      "app_email": _appEmail,
      "user_email": email,
      "otp_length": _otpLength,
      "type": _otpType?.name,
      "theme": _emailTheme?.name,
      // SMTP Configuration
      if (_emailPort != null)
        "smtp_port": int.parse(
          _emailPort.toString().replaceAll('EmailPort.port', '').trim(),
        ),
      if (_secureType != null) "smtp_secure": _secureType?.name,
      if (_host != null) "smtp_host": _host,
      if (_username != null) "smtp_username": _username,
      if (_password != null) "smtp_password": _password,
      // Email Template
      if (_template != null) "template": _template,
    };
    debugPrint(body.toString());
    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          _otpResponse = responseJson['otp'];
          debugPrint("✅️ OTP Sent to Email 📧 Successfully");
          return true;
        } else {
          debugPrint(
              "❌ Error: ${response.statusCode}, Error Message: ${responseJson['messages']['message']}");
          return false;
        }
      } else {
        debugPrint(
            "❌ Error: ${response.statusCode}, Error Message: ${responseJson['messages']['message']}");
        return false;
      }
    } on SocketException catch (e) {
      debugPrint("Network Error: ${e.message}");
      return false;
    } on HttpException catch (e) {
      debugPrint("Http Error: ${e.message}");
      return false;
    } on FormatException catch (e) {
      debugPrint("Formatting Error: ${e.message}");
      return false;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return false;
    }
  }

  /// Get Sent OTP, use the [getOTP] method.
  static String get getOTP {
    return _otpResponse;
  }

  /// To verify an  OTP entered by the user, use the [verifyOTP] method.
  /// This method takes the OTP entered by the user as a parameter and returns a boolean indicating whether the OTP is correct.
  /// * [otp] : The OTP entered by the user.
  static verifyOTP({required String otp}) {
    if (_otpResponse == otp) {
      debugPrint("✅️ OTP 🔑 Validate Successfully");
      return true;
    } else {
      debugPrint("❌ Invalid 🔑 OTP");
      return false;
    }
  }
}
