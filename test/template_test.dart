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

  setUpAll(() {
    EmailOTP.config(
      appName: 'Email OTP',
      appEmail: 'me@rohitchouhan.com',
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
      host: env['SMTP_HOST'] ?? '127.0.0.1',
      emailPort: testPort,
      secureType: testSecure,
      username: env['SMTP_USERNAME'] ?? '',
      password: env['SMTP_PASSWORD'] ?? '',
    );
  });

  group('Template Rendering Tests', () {
    for (int i = 1; i <= 10; i++) {
      test('Test Template v$i', () async {
        final file = File('templates/v$i.html');
        expect(file.existsSync(), isTrue, reason: 'Template v$i does not exist locally');
        
        final templateContent = file.readAsStringSync();
        EmailOTP.setTemplate(template: templateContent);
        
        bool isSent = await EmailOTP.sendOTP(email: 'test_v$i@emailotp.com');
        
        if (!isSent) {
          print('Failed to send email for v$i: ${EmailOTP.lastError}');
        }
        
        expect(isSent, isTrue, reason: 'Failed to dispatch email using v$i template');
      });
    }
  });
}
