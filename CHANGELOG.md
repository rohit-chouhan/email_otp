## 3.2.0
- **Security**: Replaced `Random()` with `Random.secure()` in OTP generation to ensure cryptographically secure codes.
- **Feature**: Added `EmailOTP.lastError` to retrieve specific error messages (e.g., SMTP Auth failure, network issues) when `sendOTP` fails.
- **Feature**: Automatically attaches a plain text fallback to the email message to drastically improve deliverability and spam scores.
- **Feature**: Added `resendOTP({required String email})` method to resend existing valid OTPs without generating new ones.
- **Feature**: Added `headers` parameter to `EmailOTP.config()` allowing custom SMTP headers (like `Reply-To`).
- **Feature**: Added `EmailPort.port1025` support to cleanly run test environments against MailHog or Mailpit.
- **Fix**: Removed default `"email-otp@pub.dev"` sender address to prevent SPF/DMARC delivery failures. `appEmail` now defaults to the authenticated SMTP username.
- **Fix**: Reset `_isExpired` flag in `sendOTP()` so subsequent OTP requests aren't instantly marked as expired.
- **Fix**: Enforced `_isExpired` check in `verifyOTP()` and securely trimmed whitespace from user input.
- Added explicit `void` return types to static methods to resolve static analysis lint warnings.
- Upgraded `mailer` dependency to `^7.1.0`.
- **Feature**: Added `v7`, `v8`, `v9`, and `v10` premium templates with responsive light/dark modes.
- **Feature**: Added dynamic `{{year}}` placeholder replacement for email footers.
- **Fix**: Rebuilt all previous templates (`v1` to `v6`) to properly support responsive dark mode rendering across all major email clients.
## 3.1.0
- **BREAKING CHANGE**: Removed server-side dependency. Now sends emails directly from the client.
- **REQUIRED**: You must now provide your own SMTP credentials using `EmailOTP.setSMTP()`.
- Added remote template fetching from GitHub via jsDelivr.
- Added dependency `mailer` and `http`.
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
