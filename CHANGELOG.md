## 3.0.2

- OTP expiry option added
- `getOTP` changed into method `getOTP()`
- `isExpired()` method added to validate otp expiry time
- `v6` New theme added
- bugs fixed

## 3.0.1

- Documentation broken image link fixed

## 3.0.0

- Various bug fixes have been implemented.
- Documentation has been improved for better clarity and ease of use.
- New features added.
- Added new themes: v4 and v5.
- Replaced `setConfig()` with `config()`.
- In the `sendOTP()` method, use the `userEmail:` property.
- Removed the `auth:` property from the `setSMTP` method; it is no longer needed.
- You can now easily pass the OTP type using the `OTPType` enum class.
- You can now pass the `smtp_port:` value easily using the `EmailPort` enum class.
- You can now pass the `smtp_secure:` value easily using the `SecureType` enum class.
- You can now select themes using the `EmailTheme` enum class.

## 2.1.2

- bugs fixed
- theme customization [added]

## 2.1.1

- error handling [added]

## 2.1.0

- bug fixed
- Customize Template [added]

## 2.0.1

- bug fixed

## 2.0.0

- bug fixed
- new cool email template
- new feature added for custom SMTP

## 1.0.4

- format fixed

## 1.0.3

- otpType property added.

## 1.0.2

- Changed class Name from Email_OTP to EmailOTP.
- otpLength property added.

## 1.0.1

- readme changed.

## 1.0.0

- initial release.
