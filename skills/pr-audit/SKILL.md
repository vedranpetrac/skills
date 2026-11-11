---
name: pr-audit
description: Review a pull request against the laws of code (SOLID, DRY, KISS, YAGNI, the Law of Demeter), plus security, tests and accessibility, and write a ranked report with a verdict. Use when asked to audit, review or check a PR, a branch or a diff before it merges.
---

# PR audit

Reads a pull request the way a careful senior reviewer would: first what it is for, then whether it works, then whether it will still be easy to change in six months. Every finding has to point at a line and say what goes wrong. A law that is broken but costs nothing is not a finding.

## 1. Scope

1. Find the diff. For a PR number, use `gh pr view <n>` and `gh pr diff <n>`. For a branch, run `scripts/collect.sh [base]` (defaults to `origin/main`). It prints the changed files, the size of the change and which tests were touched.
2. Read the PR description and the linked issue, if there is one.
3. Read the repo's own rules first: `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, the linter and formatter config. **House rules beat the generic laws.** If the repo says "no classes", don't ask for an interface.
4. Over about 800 changed lines? Say so in the report, and review the riskiest files first: anything that touches auth, money, data deletion or a public API.

## 2. Intent

Write one sentence: what this PR changes, for whom. If you can't, that is the first finding ("the PR does three unrelated things, split it").

## 3. Five passes

Do the passes in this order and keep notes per pass. `references/laws.md` has the full checklist, what each law looks like in a diff and when *not* to flag it.

1. **Correctness.** Does it do what the description says? Edge cases: empty, null, one, many, very large, concurrent, offline, a second click. Errors handled where they can happen, not swallowed.
2. **Laws of code.** SOLID, DRY, KISS, YAGNI, the Law of Demeter, plus separation of concerns, least astonishment and fail fast. Only within the code this PR touches.
3. **Security.** Untrusted input, injection, authorisation on every new route or action, secrets, new dependencies, personal data in logs.
4. **Tests.** Changed behaviour has a test, the test would fail without the change, nothing is skipped or loosened to go green.
5. **Accessibility.** Only when the PR touches UI: semantics, names and labels, keyboard and focus, contrast, motion, alt text.

## 4. Verify before you report

For every finding:

- Re-read the code around it. Check it isn't handled somewhere else (a middleware, a base class, a wrapper).
- Cite `path/to/file.ext:line`.
- Write the failure in one sentence: *with this input or in this state, this goes wrong*. For a design finding, name the change that will hurt: *adding a second payment provider means editing these four files*.
- Can't write that sentence? Drop the finding.

## 5. Report

Use `references/report.md`. In short:

- **Verdict:** Ship, Ship after fixes, or Hold. One line on why.
- **Findings,** most severe first, in three groups: Blocker (wrong result, data loss, security hole, broken build), Should fix (will cost real time later), Nit (taste, at most five). Each finding names the law or pass, the file and line, what goes wrong, and the smallest fix.
- **What's good:** up to three things worth keeping, so the author knows what not to undo.

## Rules

- Laws are trade-offs, not commandments. Duplication twice is fine. An abstraction for one caller is not.
- Review the PR, not the codebase. Old problems in untouched code go in one line at the end, if at all.
- Don't post comments to GitHub, push or change code unless you're asked to.
- Never paste secrets, tokens or customer data into the report, even when you find them. Say where they are and that they need rotating.
