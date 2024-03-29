# Safely

`safely` grants write access only to user-specified directories while running an arbitrary command, preventing modification of files anywhere else. If you download the script `sketchy.sh` from a seedy website and want to run it while keeping it honest about only modifying the current directory like its documentation promises, you can run:

```bash
sketchy="$(realpath sketchy.sh)"
mkdir /tmp/throwaway
cd /tmp/throwaway
safely --writable . bash "$sketchy"
```

If `sketchy.sh` tries to modify any file outside of `/tmp/throwaway`, it will fail without doing any harm.

Multiple `-w/--writable` directories can be specified:

```bash
safely --writable /my/dir -w /touch/here -- touch /my/dir/my-file /touch/here/done
```

Write permission applies recursively to subdirectories. The following is thus equivalent to not using `safely` at all:

```bash
safely -w / command arg1 arg2
```

You may also be interested in [`pledge`](https://justine.lol/pledge), which is more mature and has significantly broader scope.



## Installation

[`apptainer`](https://apptainer.org/docs/user/latest/quick_start.html#quick-installation) must first be installed and able to bind-mount directories in containers. You can test this with:

```bash
mkdir it_works
apptainer exec --bind "$(realpath it_works)" docker://alpine ls -d it_works && echo SUCCESS || echo FAILURE
```

You can install `safely` with `make install`:

```bash
make install                  # install at /usr/bin/safely
make install PREFIX=/software # install at /software/bin/safely
```

If you have [`bats`](https://bats-core.readthedocs.io/en/stable/index.html) installed, you can run tests with `make check`. If you want to do testing with more than your home diretory and `/tmp`, you can specify extra directories with `TESTDIRS`:

```bash
make check                    # vanilla tests
make check TESTDIRS=/a/b,/cde # also make sure safely protects /a/b and /cde
```



## Security

`safely` was written to allow me to [grade](https://github.com/BYUHPC/grade) student assignments with some peace of mind, not to stand up to hostile commands. Since `safely` is just a fancy wrapper for `apptainer`, it's at most as secure as `apptainer` is--if a command can escape `apptainer`, it can escape `safely`. For the time being, don't assume that `safely` will stop a motivated attacker.

Pull requests that make `safely` more robust are welcome.
