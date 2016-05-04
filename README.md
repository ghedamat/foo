# Foo

An app to reproduce a possible bug with edeliver

## STEPS

### Working version (without edeliver)

checkout the first commit of the `master` branch

```
mkdir /tmp/foo
MIX_ENV=prod mix compile && MIX_ENV=prod mix release && cp rel/foo/releases/0.0.1/foo.tar.gz /tmp/foo

cd /tmp/foo
tar xzvf foo.tar.gz
./bin/foo start
```

then checkout `master`

```
mkdir /tmp/foo/releases/0.0.2
MIX_ENV=prod mix compile && MIX_ENV=prod mix release && cp rel/foo/releases/0.0.2/foo.tar.gz /tmp/foo/releases/0.0.2
cd /tmp/foo
./bin/foo upgrade 0.0.2
```

### Broken version (with edeliver)
remove all releases `rm -rf ./rel` in the project directory

checkout the first commit of the `edeliver-test` branch

```
mkdir /tmp/foo
MIX_ENV=prod mix compile && MIX_ENV=prod mix release && cp rel/foo/releases/0.0.1/foo.tar.gz /tmp/foo

cd /tmp/foo
tar xzvf foo.tar.gz
./bin/foo start
```

then checkout `edeliver-test`

```
mkdir /tmp/foo/releases/0.0.2
MIX_ENV=prod mix compile && MIX_ENV=prod mix release && cp rel/foo/releases/0.0.2/foo.tar.gz /tmp/foo/releases/0.0.2
cd /tmp/foo
./bin/foo upgrade 0.0.2
```

you'll get the following error

```
=> Upgrading release to version 0.0.2...
escript: exception error: no case clause matching
                 {error,
                     {'EXIT',
                         {suspended_supervisor,
                             [{release_handler_1,
                                  maybe_supervisor_which_children,3,
                                  [{file,"release_handler_1.erl"},{line,631}]},
                              {release_handler_1,get_procs,2,
                                  [{file,"release_handler_1.erl"},{line,616}]},
                              {release_handler_1,get_procs,2,
                                  [{file,"release_handler_1.erl"},{line,616}]},
                              {release_handler_1,get_procs,2,
                                  [{file,"release_handler_1.erl"},{line,615}]},
                              {release_handler_1,get_supervised_procs,4,
                                  [{file,"release_handler_1.erl"},{line,590}]},
                              {lists,foldl,3,[{file,"lists.erl"},{line,1262}]},
                              {release_handler_1,eval,2,
                                  [{file,"release_handler_1.erl"},{line,375}]},
                              {lists,foldl,3,
                                  [{file,"lists.erl"},{line,1262}]}]}}}

```


## Notes

I was able to reproduce this both on OSX and on a deploy server running ubuntu 14.04


it seems to happen ONLY if `Foo.Repo` is not supervised directly from the application but if instead it has an intermediate supervisor
and/or if there's another OTP application that uses `Foo.Repo` by aliasing it.

I know it's not very clear but this is the simples reproduction case I've been able to isolate.

I guess it must be something between `edeliver` and `ecto` but I feel I now need help/pointers to be able to go deeper

any help is appreciated





