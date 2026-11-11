# Skills

The skills I use with AI coding agents. Each one is a folder with a `SKILL.md` and the files it reads. I write them for Claude Code, and any agent that reads skill folders can use them.

| Skill | What it does |
| --- | --- |
| [pr-audit](skills/pr-audit) | Reviews a pull request against the laws of code (SOLID, DRY, KISS, YAGNI, the Law of Demeter), plus security, tests and accessibility, and writes a ranked report with a verdict. |
| [youtube-shorts](skills/youtube-shorts) | Writes a YouTube Short script (15 to 60 seconds) from a topic, a brain dump or a section of a long video: three hooks, timed beats, a looping end, a title and a description. |

How each one works, with examples: [petrach.dev/toolbox](https://petrach.dev/toolbox).

## Install

In Claude Code, add this repo as a plugin marketplace once, then install the skills you want:

```
/plugin marketplace add vedranpetrac/skills
/plugin install pr-audit@petrach
/plugin install youtube-shorts@petrach
```

To update later: `/plugin marketplace update petrach`.

By hand, for Claude Code or another agent: clone the repo and copy a skill folder into your agent's skills folder.

```
git clone https://github.com/vedranpetrac/skills
cp -r skills/skills/pr-audit ~/.claude/skills/
```

## Then ask

- `Audit PR #42 and give me a verdict`
- `Write a 45-second Short from section 3 of this script`

## Where pr-audit comes from

It builds on three public skills and puts them into one pass with a verdict:

- [pr-review-code-simplicity](https://github.com/infinum/ai/tree/main/plugins/pr-review-code-simplicity) from Infinum
- [requesting-code-review](https://github.com/obra/superpowers/tree/main/skills/requesting-code-review) from Superpowers
- [Claude Code security review](https://github.com/anthropics/claude-code-security-review) from Anthropic

## Licence

MIT, use them anywhere. See [LICENSE](LICENSE).

Something wrong or unclear? Open an issue.
