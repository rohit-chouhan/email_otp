
# Welcome to Email OTP: Your Fast and Simple Email Authentication OTP Solution!

Email OTP is a Flutter package designed to simplify email authentication through one-time passwords (OTPs). With Email OTP, you can effortlessly generate OTPs and send them to your users' email addresses, ensuring secure identity verification.

![Email OTP Banner](https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/banner.jpg)

[![rohit-chouhan](https://user-images.githubusercontent.com/82075108/182797964-a92e0c59-b9ef-432d-92af-63b6475a4b1c.svg)](https://www.github.com/rohit-chouhan)
[![sponsor](https://user-images.githubusercontent.com/82075108/182797969-11208ddc-b84c-4618-8534-18388d24ac18.svg)](https://github.com/sponsors/rohit-chouhan)

## Table of Contents
- [Getting Started](#-getting-started)
- [Usage](#-usage)
- [Configuration](#-configuration)
   * [Customizing Email Templates (Optional)](#-customizing-email-templates-optional)
   * [Configuring Custom SMTP (Optional)](#-configuring-custom-smtp-optional)
   * [Email Theme](#-email-theme)
- [Sending and Verifying OTPs](#-sending-and-verifying-otps)
   * [Sending OTP](#-sending-otp)
   * [Verifying OTP](#-verifying-otp)
- [Complete Example](#-complete-example)
- [Reporting Bugs or Issues](#-reporting-bugs-or-issues)
- [Copyright and License](#-copyright-and-license)

## ‣ Getting Started

To get started, import the `email_otp` package in your Flutter project:

```dart
import 'package:email_otp/email_otp.dart';
```

## ‣ Usage

Initialize the EmailOTP class:

```dart
EmailOTP myAuth = EmailOTP();
```

## ‣ Configuration

Configure your OTP authentication settings using the `setConfig` method:

```dart
myAuth.setConfig(
    appEmail: "me@rohitchouhan.com",
    appName: "Email OTP",
    userEmail: email.text,
    otpLength: 6,
    otpType: OTPType.digitsOnly
);
```

1. `appEmail`: Your personal or company email address, visible to clients when they receive OTPs.
2. `appName`: Your app's name, displayed to clients in the email.
3. `userEmail`: The recipient's email address where the OTP needs to be sent.
4. `otpLength`: The length of the OTP (e.g., 6 digits).
5. `otpType`: Choose from `OTPType.digitsOnly`, `OTPType.stringOnly`, or `OTPType.mixed` for different OTP formats.

### ‣ Customizing Email Templates (Optional)

You can customize your email template using the `setTemplate` method. If not used, the default template provided by Email OTP will be used.

```dart
var template = 'YOUR HTML CODE HERE';
myAuth.setTemplate(
    render: template 
);
```

In your HTML, use placeholders like `{{app_name}}` and `{{otp}}` to display the app name and OTP. For example:

```
Thank you for choosing {{app_name}}. Your OTP is {{otp}}.
```

### ‣ Configuring Custom SMTP (Optional)

Configure your SMTP settings using the `setSMTP` method if you want to send OTPs from a custom email address. Make sure your SMTP credentials are correct. Test your SMTP configuration at [smtper.net](https://www.smtper.net).

```dart
myAuth.setSMTP(
    host: "smtp.rohitchouhan.com",
    auth: true,
    username: "email-otp@rohitchouhan.com",
    password: "*************",
    secure: "TLS",
    port: 576
);
```

1. `host`: Your SMTP hostname.
2. `auth`: Boolean (true/false) indicating if SMTP authentication is required.
3. `username`: Your SMTP email address.
4. `password`: Your SMTP email password.
5. `secure`: Choose from "TLS" or "SSL" for secure connections.
6. `port`: Port number of your SMTP email server.

### ‣ Email Theme
We already have a few good and beautiful email templates. To assign a theme, you need to use the `setTheme`` method with the parameter of the theme version. If you do not use this function, it will automatically take the latest theme.

```dart
myAuth.setTheme(
    theme:"v3"
);
```

|  Theme Parameter | Theme Design  |
| ------------ | ------------ |
|  v1  |  ![](https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v1.PNG) |
|  v2  |  ![](https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v2.PNG) |
|  v3  |  ![](https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/themes/v3.PNG) |

## ‣ Sending and Verifying OTPs

Use the following methods to send and verify OTPs:

### ‣ Sending OTP

```dart
await myAuth.sendOTP();
```

### ‣ Verifying OTP

```dart
var inputOTP = 987654; // OTP entered by the client after receiving the email
await myAuth.verifyOTP(
    otp: inputOTP
);
```

## ‣ Complete Example

Find a complete example in the [Email OTP package documentation](https://pub.dev/packages/email_otp/example).

## ‣ Reporting Bugs or Issues

Feel free to open a [ticket](https://github.com/rohit-chouhan/email_otp/issues) on GitHub if you encounter any problems. We also welcome new ideas and suggestions.

## ‣ Copyright and License

Copyright © 2023 [Rohit Chouhan](https://rohitchouhan.com). Licensed under the [MIT LICENSE](https://github.com/rohit-chouhan/otp/blob/main/LICENSE).