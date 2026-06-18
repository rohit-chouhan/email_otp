import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:email_otp/email_otp.dart';

Map<String, String> loadEnv() {
  var env = <String, String>{};
  try {
    var file = File('.env');
    if (file.existsSync()) {
      var lines = file.readAsLinesSync();
      for (var line in lines) {
        if (line.isNotEmpty && !line.startsWith('#')) {
          var parts = line.split('=');
          if (parts.length >= 2) {
            env[parts[0].trim()] = parts.sublist(1).join('=').trim();
          }
        }
      }
    }
  } catch (e) {
    // ignore
  }
  return env;
}

void main() {
  final env = loadEnv();

  group('EmailOTP Package Tests', () {

    test('1. Initial State & Configuration', () {
      expect(EmailOTP.getOTP(), isNull);
      expect(EmailOTP.isOtpExpired(), isFalse);

      EmailOTP.config(
        appName: 'TestApp',
        appEmail: 'test@example.com',
        otpLength: 6,
        otpType: OTPType.numeric,
      );
      
      EmailPort testPort = EmailPort.port587;
      if (env['SMTP_PORT'] == '1025') testPort = EmailPort.port1025;
      if (env['SMTP_PORT'] == '25') testPort = EmailPort.port25;
      if (env['SMTP_PORT'] == '465') testPort = EmailPort.port465;

      SecureType testSecure = SecureType.tls;
      if (env['SMTP_SECURE'] == 'none') testSecure = SecureType.none;
      if (env['SMTP_SECURE'] == 'ssl') testSecure = SecureType.ssl;

      EmailOTP.setSMTP(
        host: env['SMTP_HOST'] ?? 'invalid.host',
        emailPort: testPort,
        secureType: testSecure,
        username: env['SMTP_USERNAME'] ?? '',
        password: env['SMTP_PASSWORD'] ?? '',
      );
    });

    test('2. OTP Generation - Numeric', () async {
      EmailOTP.config(otpLength: 6, otpType: OTPType.numeric);
      await EmailOTP.sendOTP(email: 'user@example.com');
      
      final otp = EmailOTP.getOTP();
      expect(otp, isNotNull);
      expect(otp!.length, 6);
      expect(RegExp(r'^[0-9]+$').hasMatch(otp), isTrue);
    });

    test('3. OTP Generation - Alpha', () async {
      EmailOTP.config(otpLength: 8, otpType: OTPType.alpha);
      await EmailOTP.sendOTP(email: 'user@example.com');
      
      final otp = EmailOTP.getOTP();
      expect(otp, isNotNull);
      expect(otp!.length, 8);
      expect(RegExp(r'^[A-Z]+$').hasMatch(otp), isTrue);
    });

    test('4. OTP Generation - AlphaNumeric', () async {
      EmailOTP.config(otpLength: 10, otpType: OTPType.alphaNumeric);
      await EmailOTP.sendOTP(email: 'user@example.com');
      
      final otp = EmailOTP.getOTP();
      expect(otp, isNotNull);
      expect(otp!.length, 10);
      expect(RegExp(r'^[A-Z0-9]+$').hasMatch(otp), isTrue);
    });

    test('5. Verification Logic (Valid, Invalid, Whitespace)', () async {
      EmailOTP.config(otpLength: 6, otpType: OTPType.numeric);
      await EmailOTP.sendOTP(email: 'user@example.com');
      
      final otp = EmailOTP.getOTP()!;
      
      // Valid Match
      expect(EmailOTP.verifyOTP(otp: otp), isTrue);
      
      // Invalid Match
      expect(EmailOTP.verifyOTP(otp: '000000'), isFalse);
      
      // Whitespace Tolerance
      await EmailOTP.sendOTP(email: 'user@example.com');
      final newOtp = EmailOTP.getOTP()!;
      expect(EmailOTP.verifyOTP(otp: '  $newOtp  '), isTrue);
    });

    test('6. Resend OTP Logic', () async {
      EmailOTP.config(otpLength: 6, otpType: OTPType.numeric);
      await EmailOTP.sendOTP(email: 'user@example.com');
      
      final originalOtp = EmailOTP.getOTP();
      
      await EmailOTP.resendOTP(email: 'user@example.com');
      final resentOtp = EmailOTP.getOTP();
      
      expect(resentOtp, equals(originalOtp));
    });

    test('7. Error Handling', () async {
      EmailOTP.config(appEmail: 'test@example.com');
      EmailOTP.setSMTP(
        host: 'invalid.domain.that.does.not.exist.com',
        emailPort: EmailPort.port587,
        secureType: SecureType.tls,
        username: 'test',
        password: 'password',
      );
      
      final success = await EmailOTP.sendOTP(email: 'test@example.com');
      expect(success, isFalse);
      expect(EmailOTP.lastError, isNotNull);
    });
  });
}
