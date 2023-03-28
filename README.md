A fast & simple email authentication OTP sender and verification flutter package. It generates an OTP on the recipient's email which can be used to verify their identity. 

<p align="center"><img src="https://raw.githubusercontent.com/rohit-chouhan/email_otp/main/banner.jpg"/></p>

[![rohit-chouhan](https://user-images.githubusercontent.com/82075108/182797964-a92e0c59-b9ef-432d-92af-63b6475a4b1c.svg)](https://www.github.com/rohit-chouhan)
_[![sponsor](https://user-images.githubusercontent.com/82075108/182797969-11208ddc-b84c-4618-8534-18388d24ac18.svg)](https://github.com/sponsors/rohit-chouhan)


#### Usage
```
import 'package:email_otp/email_otp.dart';
```
#### Methods
⭐ **Class Initialization**
```dart
 EmailOTP myauth = EmailOTP();
```
⭐ **setConfig()**
this function will config your OTP authentication.

```dart
myauth.setConfig(
    appEmail: "me@rohitchouhan.com",
    appName: "Email OTP",
    userEmail: email.text,
    otpLength: 6,
    otpType: OTPType.digitsOnly
);
```
1. `appEmail` is your personal or company email, so client we see this mail when they receive OTP.
2. `appName` is your app name, client will received mail with this name.
3. `userEmail` property where OTP need to sent.
4. `otpLength` is the length of OTP.
5. `otpType` OTPType.digitsOnly, OTPType.stringOnly, OTPType.mixed

⭐ **setSMTP()** (new)

this function will config your SMTP to send OTP from custom email address, make sure your SMTP credentials are correct, test your SMTP from www.smtper.net

```dart
myauth.setConfig(
    host: "smtp.rohitchouhan.com",
    auth: true,
    username: "email-otp@rohitchouhan.com",
    password: "*************",
    secure: "TLS",
    port: 576
);
```
1. `host` is your SMTP Hostname
2. `auth` is your SMTP Email authetication required or not
3. `username` is your SMTP Email Address
4. `password` is your SMTP Email Password
5. `secure` TLS or SSL
6. `port` is port number of your SMTP Email Server

⭐ **sendOTP()**
this function will send OTP, and return boolean
```dart
await myauth.sendOTP();
```
⭐ **verifyOTP()**
this function will verify OTP, and return boolean. this method must have one parameter for OTP, which is enter by client.
```dart
var inputOTP = 987654; //which is entered by client, after receive mail
await myauth.verifyOTP(
  otp: inputOTP
);
```
#### See Complete Example
Code : [https://pub.dev/packages/email_otp/example](https://pub.dev/packages/email_otp/example "https://pub.dev/packages/email_otp/example")

# Report bugs or issues

You are welcome to open a _[ticket](https://github.com/rohit-chouhan/email_otp/issues)_ on github if any problems arise. New ideas are always welcome.

# Copyright and License

> Copyright © 2023 **[Rohit Chouhan](https://rohitchouhan.com)**. Licensed under the _[MIT LICENSE](https://github.com/rohit-chouhan/otp/blob/main/LICENSE)_.
