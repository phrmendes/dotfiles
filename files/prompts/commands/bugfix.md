---
description: Debug a bug by finding the root cause and proving it with a failing test before fixing
---

There is a bug: $ARGUMENTS

Steps:
1. Understand what is broken, when it happens, and what the expected behaviour is
2. Scout the codebase — trace the data flow to find where it breaks
3. Form a hypothesis about the root cause
4. Write a failing test that reproduces the bug for the right reason — not just any failing test
5. Confirm the test fails, then implement the fix
6. Confirm the test passes and run the full test suite to check for regressions
7. Summarise the root cause and what was changed
