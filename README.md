 A fast & simple email authentication OTP sender and verification flutter package. It generates an OTP on the recipient's email which can be used to verify their identity. 
<center>
<p>
<img width="400" src="https://cdn.dribbble.com/users/3821672/screenshots/7172846/media/bdcf195a8ceaf94cd2e55ee274095c91.gif"/>
</p>
</center>

#### Usage
```
import 'package:email_otp/email_otp.dart';
```
#### Methods
⭐ **Class Intilization **
```dart
 Email_OTP myauth = Email_OTP();
```
⭐** setConfig()**
this function will config your OTP authentication.
```dart
myauth.setConfig(
    appEmail: "me@rohitchouhan.com",
    appName: "Email OTP",
    userEmail: email.text,
);
```
1. `appEmail` is your personal or company email, so client we see this mail when they recevie OTP.
2. 	`appName` is your app name, client will recived mail with this name.
3. `userEmail` property where OTP need to sent.

⭐** sendOTP()**
this function will send OTP, and return boolean
```dart
await myauth.sendOTP();
```
⭐** verifyOTP()**
this function will verify OTP, and return boolean. this method must have one parameter for OTP, which is enter by client.
```dart
var inputOTP = 987654; //which is enterted by client, after recieve mail
await myauth.verifyOTP(
  otp: inputOTP
);
```
#### See Complete Example
Code : [https://pub.dev/packages/email_otp/example](https://pub.dev/packages/email_otp/example "https://pub.dev/packages/email_otp/example")

# Thank You ❤️