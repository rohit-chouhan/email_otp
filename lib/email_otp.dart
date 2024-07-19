library email_otp;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Enumerations for [OTPType]
enum OTPType { numeric, alpha, alphaNumeric }

/// Enumerations for [EmailPort]
enum SecureType { ssl, tls, none }

/// Enumerations for [EmailPort]
enum EmailPort { port25, port587, port465 }

/// Enumerations for [EmailTheme]
enum EmailTheme { v1, v2, v3, v4, v5, v6 }

/// Email OTP
class EmailOTP {
  /// OTP response
  static String? _otpResponse;

  /// App Name
  static String? _appName;

  /// Developer's Email
  static String? _appEmail;

  /// OTP Length
  static int? _otpLength;

  /// OTP Type
  static OTPType? _otpType;

  /// Expiry Time in milliseconds
  static int? _expiry;

  /// Email Theme
  static EmailTheme? _emailTheme;

  /// Email Port
  static EmailPort? _emailPort;

  /// Secure Type
  static SecureType? _secureType;

  /// SMTP Host
  static String? _host;

  /// SMTP Username
  static String? _username;

  /// SMTP Password
  static String? _password;

  /// Email Template
  static String? _template;

  /// Validate Expiry Time
  static bool? _isExpired;

  EmailOTP() {
    _otpResponse = _getRandomOTP();
    _isExpired = false;
  }

  /// Configure the EmailOTP package is by calling the [config] method
  static config({
    String? appName,
    String? appEmail,
    int? otpLength,
    OTPType? otpType,
    int? expiry,
    EmailTheme? emailTheme,
  }) {
    _appName = appName ?? "Email OTP";
    _appEmail = appEmail ?? "noreply@email-otp.rohitchouhan.com";
    _otpLength = otpLength ?? 6;
    _expiry = expiry ?? 0; // No expiry by default.
    _otpType = otpType ?? OTPType.numeric;
    _emailTheme = emailTheme ?? EmailTheme.v5;
  }

  /// Use the [setSMTP] method to provide the necessary SMTP server details.
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

  /// Use the [setTemplate] method to provide your own HTML template.
  static setTemplate({required String? template}) {
    _template = template;
  }

  /// To send an OTP to a user's email address, use the [sendOTP] method.
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
      "expiry": _expiry,
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
      if (_template != null) "template": _template,
    };
    try {
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          _otpResponse = responseJson['otp'];
          debugPrint("✅️ OTP Sent to Email 📧 Successfully");
          if (_expiry != null && _expiry! > 0) {
            var rand = _getRandomOTP();
            _reassignOtpAfterDelay(
                Duration(milliseconds: _expiry!), rand.toString());
          }
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
  static String? getOTP() {
    debugPrint("Retrieved OTP: $_otpResponse");
    return _otpResponse;
  }

  /// To verify an OTP entered by the user, use the [verifyOTP] method.
  static bool verifyOTP({required String otp}) {
    if (_otpResponse == otp) {
      debugPrint("✅️ OTP 🔑 Validate Successfully");
      _expiry = null; // Expiry time reset after successful verification.
      return true;
    } else {
      debugPrint("❌ Invalid 🔑 OTP");
      return false;
    }
  }

  /// To check if the OTP has expired, use the [isOtpExpired] method.
  static bool isOtpExpired() {
    return _isExpired ?? false;
  }

  static void _reassignOtpAfterDelay(Duration delay, String newValue) {
    Future.delayed(delay, () {
      _otpResponse = newValue;
      _isExpired = true;
      debugPrint("OTP reassigned: $_otpResponse");
    });
  }

  static String _getRandomOTP() {
    return (Random().nextInt(900000) + 100000).toString();
  }
}
