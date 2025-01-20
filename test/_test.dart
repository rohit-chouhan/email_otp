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

  group('Random OTP', () {
    test('getRandomOTP generates OTP of correct length', () {
      EmailOTP.config(otpLength: 6);

      String otp = EmailOTP.testableGetRandomOTP();

      EmailOTP.config(otpLength: 8);

      String otp2 = EmailOTP.testableGetRandomOTP();

      EmailOTP.config(otpLength: 12);

      String otp3 = EmailOTP.testableGetRandomOTP();

      expect(otp.length, 6);
      expect(otp2.length, 8);
      expect(otp3.length, 12);
    });

    test('getRandomOTP generates numeric OTP', () {
      EmailOTP.config(otpLength: 6);

      String otp = EmailOTP.testableGetRandomOTP();

      expect(int.tryParse(otp), isNotNull);
    });

    test('getRandomOTP generates different OTPs on subsequent calls', () {
      EmailOTP.config(otpLength: 6);

      String otp1 = EmailOTP.testableGetRandomOTP();
      String otp2 = EmailOTP.testableGetRandomOTP();

      expect(otp1, isNot(equals(otp2)));
    });
  });
}
