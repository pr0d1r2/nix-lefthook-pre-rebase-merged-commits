# shellcheck shell=bash
# Lefthook-compatible pre-rebase safety guard.
# Warns when commits from the branch already appear in the upstream,
# preventing accidental duplicate commits from rebasing.
# Usage: lefthook-pre-rebase-merged-commits [upstream] [branch]
# NOTE: sourced by writeShellApplication - no shebang or set needed.

upstream="${1:-HEAD}"
branch="${2:-HEAD}"

merged=$(git log --oneline --cherry-mark --right-only "$upstream"..."$branch" 2>/dev/null | grep -c '^=' || true)

if [ "$merged" -gt 0 ]; then
    echo "Warning: $merged commit(s) from this branch already appear in $upstream"
    echo "Rebasing may create duplicate commits."
    exit 1
fi
