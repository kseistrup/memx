# memx
Memoize output from job execution, while preserving stdout, stderr and
returncode: Subsequent runs will use the cached values from a previous run,
unless TTL has been reached (by default, jobs are only run once).

## Usage
```text
Usage: memx [OPTIONS] -- COMMAND [ARG [ARG …]]

Positional arguments:
  COMMAND               command to run
  ARG                   optional argument(s) to command

Optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show version information and exit
  -c, --copyright       show copying policy and exit
  -f, --force           re-run command no matter what
  -d [DIR], --dir [DIR]
                        where to store cache data (default: ~/.cache)
  -t [TTL], --ttl [TTL]
                        time before we re-run command (default: never)
  -x [CONTEXT], --context [CONTEXT]
                        free form context
  --include-cwd [{yes,no,auto}]
                        take $CWD into consideration (default: auto)
```

## Requirements
Runs on Python 3 only (tested on Python 3.5.2).

## Install
Drop `memx` in your `$PATH`.

## Example(s)
```sh
$ memx -- date --utc '+%F %T %Z'  # first run
2016-09-12 16:22:44 UTC
$ echo $?
0
$ memx -- date --utc '+%F %T %Z'  # subsequent run
2016-09-12 16:22:44 UTC
$ echo $?
0
```
A more useful example could be to memoize the output from whois(1):
```sh
#!/bin/sh
# This is ~/.local/bin/whois

exec memx -- /usr/bin/whois "${@}"

# eof
```

:smile:
