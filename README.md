Email OTP is a Flutter package designed to simplify email authentication using one-time passwords (OTPs). With Email OTP, you can effortlessly generate OTPs and send them to users' email addresses, ensuring secure identity verification. This package offers an efficient and secure method for incorporating email-based OTP authentication into your Flutter applications.

![Email OTP Banner](https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/banner.png)

[![GitHub](https://img.shields.io/badge/Rohit_Chouhan-GitHub-black?logo=github)](https://www.github.com/rohit-chouhan)
_[![Sponsor](https://img.shields.io/badge/Sponsor-Become_A_Sponsor-blue?logo=githubsponsors)](https://github.com/sponsors/rohit-chouhan)_

## Table of Contents

- [Configuration](#configuration)
  - [Advanced Configuration](#advanced-configuration)
- [SMTP (Optional)](#smtp-optional)
- [Template (Optional)](#template-optional)
- [Sending OTP](#sending-otp)
- [Verifying OTP](#verifying-otp)
- [Get OTP](#get-otp)
- [OTP Expiry Validation](#is-expired)
- [Example](#example)
- [Report bugs or issues](#report-bugs-or-issues)
- [Contributors](#contributors)

## Configuration

The simplest way to 🛠️ configure the EmailOTP package is by calling the `config` method without any parameters. This sets up the default configuration for generating OTPs.

```dart
void main() {
  EmailOTP.config();
}
```

#### Advanced Configuration

For more control over the OTP generation and email settings, you can pass various parameters to the `config` method. Below is an example demonstrating how to customize the configuration.

```dart
void main() {
  EmailOTP.config(
    appName: 'App Name',
    otpType: OTPType.numeric,
    expiry : 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'me@rohitchouhan.com',
    otpLength: 6,
  );
}
```

Parameters

1. `appName`: A string representing the name of your application.
2. `otpType`: Specifies the type of OTP to be generated. It supports three
   types:
   - `OTPType.numeric`: OTP will consist only of numbers.
   - `OTPType.alpha`: OTP will consist only of alphabetic characters.
   - `OTPType.alphaNumeric`: OTP will consist of both alphabetic characters and numbers.
3. `expiry`: OTP expiry time in milliseconds
4. `emailTheme`: Defines the theme for the OTP email. The package currently supports five themes:
   - | Theme           | Theme Preview                                                                                           |
     | --------------- | ------------------------------------------------------------------------------------------------------- |
     | `EmailTheme.v1` | <img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v1.PNG" width="500px;"> |
     | `EmailTheme.v2` | <img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v2.PNG" width="500px;"> |
     | `EmailTheme.v3` | <img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v3.PNG" width="500px;"> |
     | `EmailTheme.v4` | <img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v4.png" width="500px;"> |
     | `EmailTheme.v5` | <img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v5.png" width="500px;"> |
     | `EmailTheme.v6` | <img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v6.PNG" width="500px;"> |
5. `appEmail`: The email address from which the OTP emails will be sent.
6. `otpLength`: An integer specifying the length of the OTP. In this example, the OTP will be 6 digits long.

By configuring these parameters, you can tailor the OTP generation and email sending process to suit your application's requirements.

## SMTP (Optional)

To send OTPs from a custom email address, configure your SMTP settings using the `setSMTP` method. Ensure that your SMTP credentials are accurate.

```dart
void main() {
  EmailOTP.config();
  EmailOTP.setSMTP(
    host: 'mail.rohitchouhan.com',
    emailPort: EmailPort.port25,
    secureType: SecureType.tls,
    username: 'test@rohitchouhan.com',
    password: 'm9eFxuBQ4hbD5XGP3TEdWN',
  );
}
```

Parameters

1. `host`: The hostname of your SMTP server.
2. `emailPort`: The port number used by the SMTP server. Supported values include:
   - `EmailPort.port25`
   - `EmailPort.port465`
   - `EmailPort.port587`
3. `secureType:` The type of security used by the SMTP server. Supported values include:
   - `SecureType.none`
   - `SecureType.tls`
   - `SecureType.ssl`
4. `username`: The username for your SMTP server account.
5. `password`: The password for your SMTP server account.

By configuring these parameters, you can ensure that your application is able to send OTP emails securely and efficiently.

## Template (Optional)

You can also customize the email 🌐 template used to send the OTP. Use the `setTemplate` method to provide your own HTML template.

```dart
void main() {
  EmailOTP.config();
  EmailOTP.setTemplate(
    template: '''
    <div style="background-color: #f4f4f4; padding: 20px; font-family: Arial, sans-serif;">
      <div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
        <h1 style="color: #333;">{{appName}}</h1>
        <p style="color: #333;">Your OTP is <strong>{{otp}}</strong></p>
        <p style="color: #333;">This OTP is valid for 5 minutes.</p>
        <p style="color: #333;">Thank you for using our service.</p>
      </div>
    </div>
    ''',
  );
}
```

Parameters

- `template`: A string containing the HTML content of your custom email template. Use placeholders such as `{{appName}}` and `{{otp}}` to dynamically insert the application name and OTP respectively.

By configuring these parameters and using a custom template, you can ensure that your OTP emails are tailored to match your application's branding and style.

## Sending OTP

To 📧 send an 🔐 OTP to a user's email address, use the `sendOTP` method. This method takes the recipient's email address as a parameter.

```dart
  EmailOTP.sendOTP(email: emailController.text)
```

Parameters

- `email`: The recipient's email address where the OTP will be sent.

## Verifying OTP

To verify an 🔐 OTP entered by the user, use the `verifyOTP` method. This method takes the OTP entered by the user as a parameter and returns a boolean indicating whether the OTP is correct.

```dart
  EmailOTP.verifyOTP(otp: otpController.text)
```

Parameters

- `otp`: The OTP entered by the user.

## Get OTP

This code will print the OTP generated by the `getOTP()` method.

```dart
  print(EmailOTP.getOTP());
```

## Is Expired

This method will helps you to validate your otp expiry time.

```dart
  print(EmailOTP.isExpired());
```

## Example

👉 For a complete example, refer to the [Email OTP package documentation](https://pub.dev/packages/email_otp/example).

## Report bugs or issues

You are welcome to open a _[ticket](https://github.com/rohit-chouhan/email_otp/issues)_ on github if any 🐞 problems arise. New ideas are always welcome.

## Contributors

<a href="https://github.com/chouhan-rahul"><img src="https://avatars.githubusercontent.com/u/82075108" width="60px;" alt="Rahul Chouhan" style="border-radius:50%"><br/><sub><b>Chouhan Rahul</b></sub></a>

> Copyright © 2024 **[Rohit Chouhan](https://rohitchouhan.com)**. Licensed under the _[MIT LICENSE](https://github.com/rohit-chouhan/email_otp/blob/main/LICENSE)_
