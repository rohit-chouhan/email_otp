---
trigger: always_on
description: Review and Resolve Repository Issues and Pull Requests
---

Repository: Current Project

Please perform a complete repository maintenance review.

Tasks:

1. Analyze the codebase and understand the project architecture.

2. Review all currently open GitHub Issues.

3. Review all currently open Pull Requests.

4. Determine which issues and PRs are still relevant to the current version.

5. Identify:

   * Already fixed issues
   * Duplicate issues
   * Outdated issues
   * Invalid issues
   * Issues requiring implementation
   * PRs ready to merge
   * PRs requiring changes
   * PRs that should be closed

6. Fix all valid and actionable issues directly in the codebase.

7. Create an `OPEN_ISSUES.md` file containing:

   * Issue number
   * Title
   * Status
   * Priority
   * Analysis
   * Recommended action
   * Resolution details

8. Include ready-to-post GitHub comments for every issue and PR:

   * Issue resolved comments
   * Duplicate issue comments
   * Outdated issue comments
   * PR review comments
   * Merge recommendation comments
   * Close recommendation comments

9. Generate commits following conventional commit standards.

10. Provide a final maintenance report summarizing:

    * Issues fixed
    * Issues closed
    * Issues remaining
    * PRs reviewed
    * PRs merged/recommended
    * Technical debt discovered