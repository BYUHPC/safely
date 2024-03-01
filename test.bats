#!/usr/bin/env bats



setup_file() {
    bats_require_minimum_version 1.5.0
    export PATH="$BATS_TEST_DIRNAME:$PATH"
    cd # $HOME has historically been a problem, so run tests from there
}



@test "safely puts the user in the correct directory on launch" {
    test "$(safely pwd -P)" = "$(pwd -P)"
}



@test "touch works when it should and doesn't when it shouldn't" {
    extra_dirs=()
    old_IFS="$IFS"
    IFS=,
    read -ra extra_dirs <<< "$TESTDIRS"
    IFS="$OLD_IFS"

    mkdir -p "$HOME/.cache"
    for dir in /tmp /dev/shm "$HOME/.cache" "${extra_dirs[@]}"; do
        safely -w "$dir" touch "$dir" # should succeed
        run ! safely touch "$dir"     # should fail
    done
}



@test "write rules apply recursively" {
    safely -w /dev touch /dev/shm
}



@test "multiple write directories can be specified" {
    safely -w /dev -w /tmp touch /dev/shm /tmp
}



@test "/dev/null is always writable and behaves as expected" {
    safely bash -c 'echo success >/dev/null' # make sure it doesn't deny permission
    test "$(safely bash -c 'echo right; echo wrong >/dev/null')" = "right"
}
