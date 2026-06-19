# Testing Strategy & Guidelines

This document outlines the testing architecture, goals, and execution instructions for the `email_otp` Flutter package.

## 1. Test Architecture

The `email_otp` package employs a comprehensive testing strategy using the `flutter_test` framework. Since the package relies on network operations (SMTP direct connection and HTTP calls for templates), the testing architecture is divided into the following categories:

### Unit Tests
- **Core Logic:** Validates the static methods inside `EmailOTP`, covering configuration initialization (`config`, `setSMTP`), internal state updates, and error handling when invalid configurations are supplied.
- **OTP Generation:** Ensures cryptographically secure random string generation across all types (`numeric`, `alpha`, `alphaNumeric`) and verifies that the lengths are strictly adhered to.
- **Verification Logic:** Tests the boolean outputs of `verifyOTP()`, ensuring it matches valid input, rejects invalid input, correctly trims whitespace, and accurately respects the `_isExpired` flag behavior across subsequent OTP requests.

### Integration / Network Tests
- **SMTP Communication:** Simulates standard connection issues (e.g., unreachable hosts, invalid credentials) to ensure `EmailOTP.lastError` is correctly populated and the code doesn't crash during exceptions.
- **Template Retrieval:** Validates both the remote HTML fetching logic and the internal fallback mechanisms in `template_test.dart` to guarantee robust operation if JSdelivr/Github goes offline.

## 2. Coverage Goals

The primary goal is to maintain a minimum of **90% code coverage** for the core logic layer (`lib/` directory) with a particular emphasis on `email_otp.dart`.
- All public-facing API methods must have corresponding test scenarios.
- All conditional branching (e.g., falling back to `username` when `appEmail` is not provided) must be explicitly covered.
- Null safety and edge cases (like whitespace in inputs) are mandatory.

## 3. How to Run Tests

Ensure you have the Flutter SDK installed and initialized. You can run the test suite directly from your terminal:

**Run all tests:**
```bash
flutter test
```

**Run a specific test file:**
```bash
flutter test test/email_otp_test.dart
```

**Generate coverage report:**
```bash
flutter test --coverage
```
*Note: This generates a `lcov.info` file inside the `coverage/` directory which can be visualized using tools like `genhtml`.*

## 4. CI/CD Integration

To ensure the package remains stable with every PR and merge, all tests should be integrated into GitHub Actions (or any equivalent CI platform). 

**Sample GitHub Action (`.github/workflows/test.yml`):**
```yaml
name: Flutter Tests

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      - run: flutter pub get
      - run: flutter test --coverage
```

## 5. Testing Best Practices

- **Arrange-Act-Assert (AAA):** Every test case should clearly arrange its mock data/configurations, perform the action, and then assert the expected outcome.
- **Environment Variables for SMTP:** For local network integration tests, do not hardcode your SMTP credentials in the test files. Use a local `.env` file that is parsed securely during testing (already implemented in `test/email_otp_test.dart`).
- **Descriptive Naming:** Use clear grouping (`group()`) and describe the explicit scenario in the `test()` descriptor (e.g., `OTP Generation - AlphaNumeric`).
- **State Cleanup:** Ensure global static state from `EmailOTP` is reset or correctly overwritten between tests to prevent side effects.
