# Contributing

Retroslop Mall combines a Git/Rojo codebase with a Roblox Team Create place. Those
systems do not provide the same isolation, so coordinate the boundary before editing.

## Safe workflow

1. Fetch `origin/main` and create a short-lived feature branch, preferably in a
   separate Git worktree. Name branches `<github-user>/<scope>`.
2. Keep the shared Team Create place read-only unless the other collaborators know
   which instances or scripts you intend to change.
3. Prefer filesystem changes under the services mapped by `default.project.json`.
   Do not run `rojo serve` against the shared place from an unreviewed feature branch.
4. Validate every source change with:

   ```bash
   rojo build --output build.rbxlx
   ```

   `build.rbxlx` is gitignored and should be left in place after validation.
5. Review the full diff, commit only the intended files, push the feature branch,
   and open a pull request. A different collaborator should review and merge it.

## Place-file and Studio changes

- Do not include `retroslopmall.rbxlx` in an ordinary script-only pull request. Its
  large XML diff is difficult to review and likely to conflict with Team Create work.
- Test risky Studio work in a local or dedicated development copy of the place.
- Never publish the shared experience as part of a normal code review.
- Changes made in Play mode are temporary and are not a substitute for an Edit-mode
  implementation after review.

The project-specific agent and Rojo constraints in `AGENTS.md` still apply.
