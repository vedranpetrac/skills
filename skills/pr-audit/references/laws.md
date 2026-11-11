# The laws, and when not to use them

Each law has three parts: what it says, what it looks like in a diff, and when to leave it alone. The last part matters most. A review that flags every law it can name is noise.

## SOLID

**S, single responsibility.** A module has one reason to change.
- In a diff: a function that fetches, transforms, renders and logs. A file that grew a second job ("utils.ts" now also sends email). A PR description with "and also".
- Leave it: small scripts, one-off migrations, glue code that is meant to wire things together.

**O, open/closed.** Add behaviour by adding code, not by editing a growing switch.
- In a diff: the fourth `if (type === ...)` branch for the same decision in the same function, or the same switch repeated in several files.
- Leave it: two or three branches. A switch is often the clearest code there is.

**L, Liskov substitution.** A subtype works anywhere its parent does.
- In a diff: an override that throws "not supported", ignores an argument, narrows what it accepts or returns a different shape.
- Leave it: code with no inheritance or shared interface. Most modern code.

**I, interface segregation.** Don't make callers depend on things they don't use.
- In a diff: a component that takes a whole `user` or `order` object to read one field; an interface with ten methods where each implementer stubs half.
- Leave it: internal code with one caller.

**D, dependency inversion.** Business rules don't reach for concrete infrastructure.
- In a diff: domain logic that news up an HTTP client, reads `process.env` or calls the database directly, so it can't be tested without the network.
- Leave it: thin handlers and scripts, where the indirection would cost more than it saves.

## DRY, don't repeat yourself

One piece of knowledge, one place.
- In a diff: the same rule (a price calculation, a validation, a regex, a magic number) pasted in two or more places, so a fix in one misses the other.
- Leave it: code that looks alike but changes for different reasons. Wait for the third copy (rule of three). Duplicated test setup is often clearer than a clever helper.

## KISS, keep it simple

The simplest thing that works, readable by the next person.
- In a diff: a generic factory for one use, clever one-liners, deep nesting, a custom state machine where a boolean would do, a new library for something the platform already does.
- Leave it: complexity the problem really has. Name it and move on.

## YAGNI, you aren't gonna need it

Build what is needed now.
- In a diff: config options nobody sets, unused parameters "for later", plugin systems with one plugin, abstract base classes with one child, commented-out code kept just in case.
- Leave it: public APIs and data formats that are expensive to change later. A bit of foresight there is cheap.

## Law of Demeter, talk to friends, not strangers

A unit only talks to its direct collaborators.
- In a diff: chains like `order.customer.address.country.code`, or a component that knows the shape of a store three levels deep. One rename upstream breaks many files.
- Leave it: fluent builders, query builders and plain data objects where chaining is the design.

## Also check

- **Separation of concerns:** UI, business rules and data access in separate places. SQL in a template is a finding.
- **Least astonishment:** a function called `getUser` that also writes to the database; a boolean argument that flips behaviour (`save(true)`).
- **Fail fast:** bad input caught at the edge with a clear error, not three layers down as `undefined is not a function`.
- **Names:** a name that lies is a bug waiting. `data`, `info`, `handle`, `temp` in new code deserve a better word.
- **Boy scout rule:** small clean-ups *in the touched lines* are welcome. Drive-by refactors of untouched files belong in their own PR.

## Security

- Every new route, action, job or webhook checks who is calling and whether they may do this.
- Untrusted input (body, query, headers, files, webhooks, LLM output) is validated before use; queries are parameterised; HTML is escaped; paths can't climb out with `../`.
- No secrets, tokens or keys in code, config, tests, fixtures or logs. Found one? It needs rotating, not just deleting.
- New dependencies: maintained, licence fits, not a typo of a popular name, pinned.
- Personal data stays out of logs, analytics and error messages.
- Redirects and fetches to user-given URLs are allow-listed (open redirect, SSRF).

## Tests

- Changed behaviour has a test that would fail without the change. Ask: if I revert the fix, does a test go red?
- Edge cases from the correctness pass are covered, not just the happy path.
- No `skip`, `only`, loosened assertions or bumped timeouts to get green.
- Tests don't depend on order, time of day, network or each other.
- A refactor with no behaviour change keeps the old tests passing unchanged.

## Accessibility (UI changes only)

- Real elements: a button is a `<button>`, a link goes somewhere, headings go in order.
- Every input has a label, every icon-only button has an accessible name, images have alt text that says what is in them (or empty alt when decorative).
- Everything works with the keyboard, focus is visible and lands somewhere sensible after a dialog closes.
- Text contrast at least 4.5:1 (3:1 for large text and UI parts).
- Motion respects `prefers-reduced-motion`; nothing flashes more than three times a second.
- Status changes (errors, toasts, loading) are announced, not only coloured.
