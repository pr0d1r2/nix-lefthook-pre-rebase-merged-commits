#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    TMP="$BATS_TEST_TMPDIR"

    # Create a test repo with some history
    git init "$TMP/repo" >/dev/null 2>&1
    cd "$TMP/repo" || return
    git config user.email "test@test.com"
    git config user.name "Test"
    echo "initial" > file.txt
    git add file.txt
    git commit -m "Initial commit" >/dev/null 2>&1
    DEFAULT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
}

@test "no merged commits exits 0" {
    cd "$TMP/repo" || return
    git checkout -b feature >/dev/null 2>&1
    echo "new" > new.txt
    git add new.txt
    git commit -m "Feature commit" >/dev/null 2>&1
    run lefthook-pre-rebase-merged-commits "$DEFAULT_BRANCH" feature
    assert_success
}

@test "cherry-picked commits exits 1" {
    cd "$TMP/repo" || return
    git checkout -b feature >/dev/null 2>&1
    echo "new" > new.txt
    git add new.txt
    git commit -m "Feature commit" >/dev/null 2>&1
    # Add diverging commit on default branch so cherry-pick doesn't fast-forward
    git checkout "$DEFAULT_BRANCH" >/dev/null 2>&1
    echo "other" > other.txt
    git add other.txt
    git commit -m "Other work" >/dev/null 2>&1
    git cherry-pick feature >/dev/null 2>&1
    run lefthook-pre-rebase-merged-commits "$DEFAULT_BRANCH" feature
    assert_failure
    assert_output --partial "already appear in"
}

@test "defaults to HEAD when no args" {
    cd "$TMP/repo" || return
    run lefthook-pre-rebase-merged-commits
    assert_success
}
