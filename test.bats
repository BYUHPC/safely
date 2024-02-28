#!/usr/bin/env bats



@test "touch works when it should and doesn't when it shouldn't" {
    bats_require_minimum_version 1.5.0
    export PATH="$BATS_TEST_DIRNAME:$PATH"
    for dir in /tmp "$HOME/.cache"; do
        mkdir -p "$dir/safety-test"
        test_dir="$(mktemp -d "$dir/safety-test/XXXX")"

        safely -w "$test_dir" touch "$test_dir/file1" # should succeed
        run ! safely touch "$test_dir/file2"

        pushd "$test_dir"

        safely -w . touch file2 # should succeed
        run ! safely touch file2

        popd

        rm -r "$test_dir"
    done
}
