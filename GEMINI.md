# Architecture Overview

## `EmailOTP` Package

The `EmailOTP` package provides a straightforward way to generate, send, and verify one-time passwords (OTPs) directly from a Flutter/Dart client application. Since version 3.1.0, it sends emails using a direct SMTP connection instead of relying on a centralized backend server.

### Core Architecture & Components

- **`EmailOTP` Class:** A utility class containing static methods and properties to handle the entire OTP lifecycle.
  - **Configuration (`config`, `setSMTP`):** Methods to initialize the application name, developer email, OTP properties (length, type, expiry), and SMTP server credentials.
  - **OTP Generation (`_getRandomOTP`):** Uses `dart:math` to generate cryptographically secure random strings based on the configured `OTPType` (numeric, alpha, alphanumeric) and length.
  - **Email Dispatch (`sendOTP`):** Uses the `mailer` package to establish a direct connection to an SMTP server. It handles network exceptions, TLS handshake issues, and standard mailer errors gracefully.
  - **Template Management (`_getThemeHtml`, `setTemplate`):** The package can fetch HTML email templates dynamically from a remote GitHub repository via `http` (using the jsdelivr CDN). If the remote fetch fails, it provides a seamless fallback to an internal hardcoded HTML template (`_getDefaultTheme`). It also fully supports custom user-provided HTML templates.
  - **Verification & Expiry (`verifyOTP`, `isOtpExpired`):** Methods to check if the generated OTP matches the user input. Expiry is handled by a `Future.delayed` timer that reassigns the OTP variable and sets `_isExpired` to true once the duration is met.

### Key Dependencies
- `mailer`: For constructing and dispatching emails via standard SMTP protocols.
- `http`: For retrieving remote HTML template assets dynamically.

---

## Preparation for Future Updates

When making modifications or adding new features to this package, you must ensure the documentation remains synchronized. **Always update the following files based on the new changes:**

### 1. `README.md`
- **Configuration:** Document any new parameters added to `config()` or `setSMTP()`.
- **Themes:** If new `EmailTheme` enumerations are added, update the Themes table with the corresponding preview images.
- **Methods:** If method signatures change or new public methods are exposed, add relevant examples in the usage section.
- **Table of Contents** - If any heading is added or removed, update the table of contents.

### 2. `CHANGELOG.md`
- Create a new version heading (e.g., `## [New Version]`).
- Clearly summarize all new features and bug fixes.
- If a change is backwards-incompatible, explicitly mark it with **BREAKING CHANGE** and provide migration steps for developers.
