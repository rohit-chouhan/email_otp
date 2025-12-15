import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() {
  var receivedOTP = '000000';
  EmailOTP.config(
      appName: 'MyApp',
      otpType: OTPType.numeric,
      emailTheme: EmailTheme.v6,
      expiry: 10000);
  
  EmailOTP.setSMTP(
    emailPort: EmailPort.port465,
    secureType: SecureType.ssl,
    host: 'mail.rohitchouhan.com',
    username: 'me@rohitchouhan.com',
    password: '***********'
  );

  // Mock the send function to avoid network calls
  EmailOTP.setSendFunction((message, smtpServer) async {
    // Verify arguments if needed
    debugPrint("Mock Send: Sending email to ${message.recipients.first}");
    return true; // Return success
  });

  test('Test Cases', () async {
    // This will now use the mock, so it should return true and not hit the network
    var isSent = await EmailOTP.sendOTP(email: "itsrohitofficial@gmail.com");
    if (isSent) {
      receivedOTP = EmailOTP.getOTP()!;
      debugPrint('Received OTP: $receivedOTP');
      if (EmailOTP.verifyOTP(otp: EmailOTP.getOTP().toString())) {
        debugPrint("OTP is valid");
      } else {
        debugPrint("OTP is invalid");
      }
      debugPrint("OTP has been sent");
    } else {
      debugPrint("Failed to send OTP (Unexpected failure with mock)");
    }
    expect(isSent, true); 
  });
}
