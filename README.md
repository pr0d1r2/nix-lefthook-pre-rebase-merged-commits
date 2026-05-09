# nix-lefthook-pre-rebase-merged-commits

[![CI](https://github.com/pr0d1r2/nix-lefthook-pre-rebase-merged-commits/actions/workflows/ci.yml/badge.svg)](https://github.com/pr0d1r2/nix-lefthook-pre-rebase-merged-commits/actions/workflows/ci.yml)

> This code is LLM-generated and validated through an automated integration process using [lefthook](https://github.com/evilmartians/lefthook) git hooks, [bats](https://github.com/bats-core/bats-core) unit tests, and GitHub Actions CI.

Lefthook-compatible pre-rebase merged commits guard, packaged as a Nix flake.

Prevents accidental duplicate commits by warning when commits from the current branch already appear in the upstream. Uses `git log --cherry-pick` to detect already-merged commits before rebasing.

## Usage

### Option A: Lefthook remote (recommended)

Add to your `lefthook.yml` - no flake input needed, just the wrapper binary in your devShell:

```yaml
remotes:
  - git_url: https://github.com/pr0d1r2/nix-lefthook-pre-rebase-merged-commits
    ref: main
    configs:
      - lefthook-remote.yml
```

### Option B: Flake input

Add as a flake input:

```nix
inputs.nix-lefthook-pre-rebase-merged-commits = {
  url = "github:pr0d1r2/nix-lefthook-pre-rebase-merged-commits";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Add to your devShell:

```nix
nix-lefthook-pre-rebase-merged-commits.packages.${pkgs.stdenv.hostPlatform.system}.default
```

Add to `lefthook.yml`:

```yaml
pre-rebase:
  commands:
    pre-rebase-merged-commits:
      run: timeout ${LEFTHOOK_PRE_REBASE_MERGED_COMMITS_TIMEOUT:-10} lefthook-pre-rebase-merged-commits {1} {2}
```

### Configuring timeout

The default timeout is 10 seconds. Override per-repo via environment variable:

```bash
export LEFTHOOK_PRE_REBASE_MERGED_COMMITS_TIMEOUT=30
```

## Development

The repo includes an `.envrc` for [direnv](https://direnv.net/) - entering the directory automatically loads the devShell with all dependencies:

```bash
cd nix-lefthook-pre-rebase-merged-commits  # direnv loads the flake
bats tests/unit/
```

If not using direnv, enter the shell manually:

```bash
nix develop
bats tests/unit/
```

## License

MIT
