---
trigger: always_on
description: Create Comprehensive Flutter Test Suite
---

Analyze the entire Flutter package and create a complete testing strategy.

Requirements:

1. Understand all package functionality before writing tests.

2. Create a complete `test/` directory structure.

3. Add tests for:

   * Unit tests
   * Widget tests (if applicable)
   * Integration tests (if applicable)
   * Edge cases
   * Error handling
   * Null safety scenarios
   * Invalid input scenarios
   * Performance-sensitive logic

4. Ensure every public API has corresponding test coverage.

5. Use meaningful test grouping and descriptions.

6. Follow the Arrange-Act-Assert testing pattern.

7. Add test utilities, mocks, and fixtures where necessary.

8. Configure coverage reporting.

9. Ensure `flutter test` outputs detailed and readable test information, including:

   * Test name
   * Scenario description
   * Expected result
   * Actual result on failure

10. Generate a `TESTING.md` file that includes:

    * Test architecture
    * Coverage goals
    * How to run tests
    * CI/CD integration instructions
    * Testing best practices

11. Target at least 90% code coverage where feasible.

12. Verify all tests pass successfully before finalizing.
