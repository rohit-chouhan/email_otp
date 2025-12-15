library email_otp;

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
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
   // _otpResponse = _getRandomOTP(); // Don't generate on init, generate on send or explicit call
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
    _appEmail = appEmail ?? "email-otp@pub.dev";
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
    if (_host == null || _username == null || _password == null) {
      debugPrint("❌ Error: SMTP configuration is missing. Please call setSMTP() before sending OTP.");
      return false;
    }

    _otpResponse = _getRandomOTP();
    
    // Choose template
    String htmlBody;
    try {
      if (_template != null) {
        htmlBody = _template!;
      } else if (_emailTheme != null) {
         htmlBody = await _getThemeHtml(_emailTheme!);
      } else {
         htmlBody = _getDefaultTheme();
      }
    } catch (e) {
      debugPrint("⚠️ Error loading theme: $e. Using default theme.");
      htmlBody = _getDefaultTheme();
    }
    
    // Replace placeholders
    htmlBody = htmlBody.replaceAll('{{appName}}', _appName ?? "App Name")
                       .replaceAll('{{otp}}', _otpResponse!);

    // SMTP Server Config
    int port = 587; // default
    if (_emailPort == EmailPort.port25) port = 25;
    if (_emailPort == EmailPort.port465) port = 465;
    if (_emailPort == EmailPort.port587) port = 587;
    
    final smtpServer = SmtpServer(_host!,
      port: port,
      username: _username,
      password: _password,
      ssl: _secureType == SecureType.ssl,
      allowInsecure: _secureType == SecureType.none || _secureType == null, 
      ignoreBadCertificate: false,
    );

    final message = Message()
      ..from = Address(_appEmail ?? _username!, _appName)
      ..recipients.add(email)
      ..subject = 'Verification Code - ${_appName ?? "App Name"}'
      ..html = htmlBody;

    try {
      final verifySend = await send(message, smtpServer);
      debugPrint("✅️ OTP Sent to Email 📧 Successfully: ${verifySend.toString()}");
      
      if (_expiry != null && _expiry! > 0) {
        var rand = _getRandomOTP();
        _reassignOtpAfterDelay(
            Duration(milliseconds: _expiry!), rand.toString());
      }
      return true;
    } on MailerException catch (e) {
        debugPrint("❌ Mailer Error: ${e.toString()}");
        for (var p in e.problems) {
          debugPrint('Problem: ${p.code}: ${p.msg}');
        }
        return false;
    } on SocketException catch (e) {
        debugPrint("❌ Network Error: Connection to SMTP server failed. Check host, port, and internet connection.");
        debugPrint("Details: ${e.message}");
        return false;
    } on TlsException catch (e) {
        debugPrint("❌ Security Error: TLS/SSL handshake failed. Check your security settings (SSL vs TLS).");
        debugPrint("Details: ${e.message}");
        return false;
   } catch (e) {
      debugPrint("❌ Unexpected Error: $e");
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
    int length = _otpLength ?? 6;
    if(_otpType == OTPType.numeric) {
       int min = pow(10, length - 1).toInt();
       int max = pow(10, length).toInt() - 1;
       return (Random().nextInt(max - min) + min).toString();
    } else if (_otpType == OTPType.alpha) {
       const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       return List.generate(length, (index) => chars[Random().nextInt(chars.length)]).join();
    } else {
       const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
       return List.generate(length, (index) => chars[Random().nextInt(chars.length)]).join();
    }
  }
  
  static Future<String> _getThemeHtml(EmailTheme theme) async {
    // Fetch the HTML template corresponding to the theme (e.g., v1.html, v2.html)
    // from the GitHub repository via jsdelivr.
    String themeName = theme.name; // v1, v2, etc.
    String url = "https://cdn.jsdelivr.net/gh/rohit-chouhan/email_otp@main/templates/$themeName.html";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body; 
        // The calling function (sendOTP) will replace {{appName}} and {{otp}} placeholders 
        // in this returned HTML.
      } else {
        debugPrint("⚠️ Failed to fetch template from $url (Status: ${response.statusCode}). Using fallback.");
        return _getDefaultTheme(theme);
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching template: $e. Using fallback.");
      return _getDefaultTheme(theme);
    }
  }

  static String _getDefaultTheme([EmailTheme? theme]) {
      String color = "#3366FF"; // v1/default color
      if (theme != null) {
        switch(theme) {
           case EmailTheme.v1: color = "#FF5733"; break; 
           case EmailTheme.v2: color = "#33FF57"; break;
           case EmailTheme.v3: color = "#3357FF"; break;
           case EmailTheme.v4: color = "#FF33A1"; break;
           case EmailTheme.v5: color = "#33FFF6"; break;
           case EmailTheme.v6: color = "#F6FF33"; break;
        }
      }
      
      return """
<!DOCTYPE html>
<html>
<head>
<style>
  .container { max-width: 600px; margin: auto; font-family: Arial, sans-serif; padding: 20px; border: 1px solid #eee; border-radius: 10px; }
  .header { text-align: center; padding: 20px 0; background-color: $color; color: white; border-radius: 10px 10px 0 0; }
  .content { padding: 30px; text-align: center; }
  .otp-code { font-size: 32px; font-weight: bold; letter-spacing: 5px; color: $color; margin: 20px 0; }
  .footer { text-align: center; font-size: 12px; color: #888; margin-top: 20px; }
</style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Verification Code</h1>
    </div>
    <div class="content">
      <p>Hello,</p>
      <p>Your verification code for <strong>{{appName}}</strong> is:</p>
      <div class="otp-code">{{otp}}</div>
      <p>Please do not share this code with anyone.</p>
    </div>
    <div class="footer">
      &copy; {{appName}}
    </div>
  </div>
</body>
</html>
      """;
  }
}
