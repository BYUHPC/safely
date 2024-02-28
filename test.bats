#!/usr/bin/env bats



setup_file() {
    export PATH="$BATS_TEST_DIRNAME:$PATH"
    cd # $HOME has historically been a problem, so run tests from there
}



@test "safely puts the user in the correct directory on launch" {
    test "$(safely pwd -P)" = "$(pwd -P)"
}



@test "touch works when it should and doesn't when it shouldn't" {
    bats_require_minimum_version 1.5.0

    extra_dirs=()
    old_IFS="$IFS"
    IFS=,
    read -ra extra_dirs <<< "$TESTDIRS"
    IFS="$OLD_IFS"

    mkdir -p "$HOME/.cache"
    for dir in /tmp /dev/shm "$HOME/.cache" "${extra_dirs[@]}"; do
        test_dir="$(mktemp -d "$dir/.safety-test-XXXX")"

        safely -w "$test_dir" touch "$test_dir/file1" # should succeed
        run ! safely touch "$test_dir/file2"          # should fail

        rm -r "$test_dir"
    done
}
