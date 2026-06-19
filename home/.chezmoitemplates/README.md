# .chezmoitemplates

Chezmoi templates shared across platforms.

## skills/

Shared templates for AI skills, organized per skill folder to mirror
`~/.copilot/skills` and `~/.claude/skills`.

## my-cheatsheets.cheat

[Navi](https://github.com/denisidoro/navi) cheatsheets.

### git: Disable lock-verification for Git LFS

```bash
git config lfs.locksverify false
```

GitHub and GitLab store forks together with the parent repository to minimize duplicate files.
For Git LFS, this means usage (bandwidth and storage) is billed to the **parent repository's owner**, not the fork owner.
As a result, you may be unable to push LFS objects from a fork even when the fork is read/write.

Additionally, LFS objects are pushed before Git objects, so the forge can't yet confirm the push is tied to a PR branch
with "allow edits by maintainers" enabled — which creates a billing ambiguity that GitHub has not yet resolved.

Disabling lock verification sidesteps the push failure. References:

- https://github.com/git-lfs/git-lfs/issues/5001#issuecomment-1122998809
- https://github.com/cli/cli/discussions/8794#discussioncomment-8695076
