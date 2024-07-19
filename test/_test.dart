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

  test('Test Cases', () async {
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
      debugPrint("Failed to send OTP");
    }
    expect(isSent, true);
  });
}
