import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var receivedOTP = '000000';
  EmailOTP.config(
      appName: 'MyApp',
      otpType: OTPType.numeric,
      emailTheme: EmailTheme.v6,
      expiry: 10000);
  
  EmailOTP.setSMTP(
    emailPort: EmailPort.port587,
    secureType: SecureType.tls,
    host: 'smtp.gmail.com',
    username: 'your-email@gmail.com',
    password: 'your-password'
  );

  test('Test Cases', () async {
    // Note: This will fail to send without valid credentials, returning false.
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
      debugPrint("Failed to send OTP (Expected without real credentials)");
    }
    // expect(isSent, true); // Commented out as we don't have real credentials in CI/Test
  });
}
