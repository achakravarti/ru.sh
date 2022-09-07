% RU.SH:LOG(3) Version 0.0.1 | ReUsable Shell Helpers Manual
%
% 2022


# NAME
`log_ok`, `log_info`, `log_warn`, `log_fail`, `log_dump` -- interface for
printing and logging messages.


# SYNOPSIS
```
. /usr/local/src/ru.sh/log.sh
export LOG_FILE
log_ok $1
log_info $1
log_warn $1
log_fail $1
log_dump $1
```


# DESCRIPTION
In shell scripts, it is often useful to provide feedback on what actions are
being performed and to log this feedback for later review. The Log component of
*ru.sh* facilitates this by providing shell functions to print and save
formatted log entries from message strings. In the context of *ru.sh*, _logging_
means:

  #. Generating a formatted log entry from an unformatted message string,
  #. Printing the log entry to either *stdout* or *stderr*, and
  #. Optionally writing the log entry to a file.

All other components of *ru.sh* depend on this component, so it is necessary to
always source it if the functions from any other component are used, even if the
logging functions are not used directly.

The following functions are available:

  - `log_ok`: Logs a success message
  - `log_info`: Logs an informational message
  - `log_warn`: Logs a warning message
  - `log_fail`: Logs an error message
  - `log_dump`: Logs the output of a command
 
Each of these functions prints a coloured timestamped log entry and optionally
writes it to a file defined by the exported environment variable `LOG_FILE`. If
`LOG_FILE` is not set, then the log entry is simply printed and not written to
file.  All of these functions print to *stdout* except `log_fail`, which prints
to *stderr*. Additionally, `log_fail` also automatically exits the shell, which
is not the case with the other functions. The `log_dump` function is special in
that the output of any shell command may be piped to it; this is not possible
with the other log functions.

The message to be logged is passed through the first parameter of the function,
and the caption of the message is determined by which function is invoked. The
format of the printed/logged message is as follows:

[_caption_] _timestamp_: _message_...

_caption_ is determined by which log function has been invoked, and is one of
the following:

  - [ OK ] (printed in green) if `log_ok` has been called
  - [INFO] (printed in blue)if `log_info` has been called
  - [WARN] (printed in bold orange) if `log_warn` has been called
  - [FAIL] (printed in bold red) if `log_fail` has been called
  - [DUMP] (printed in cyan) if `log_dump` has been called
  
The caption is always enclosed in square brackets, and the OK caption has a
padding of 1 whitespace character around it to keep its width to 4 characters
consistent with the other captions.
  
_timestamp_ is in the Linux kernel log format, which in the `strftime` format is
`%b %d %H:%M:%S`. The timestamp is printed in purple after the caption by all of
the log function.

_message_ is the contextual message of the log entry and is passed to each of
the log functions through their first (and only) parameter as an unformatted
string. Ellipses are automatically added to the end of the message.

For concrete examples, see the sample outputs listed in the **EXAMPLES** section
of this page.


# FILES
The source files of the Log component are distributed as shown below. Files
marked with _origin_ are relative to the project root of the Git repository
where development takes place. Files marked with _install_ are installed to the
host machine when `make install` is executed.

| */usr/local/src/ru.sh/log.sh* (install)
| *src/log.sh* (origin)
|    Definition of logging shell routines.

| */usr/local/share/man/man3/ru.sh:log.3.gz* (install)
| */usr/local/share/doc/ru.sh/log.3.md* (install)
| *doc/log.3.md* (origin)
|    Man page documentation; the second file is installed only if the *configure* script is run with the *-s* option.

| */usr/local/tests/ru.sh/log.sh* (install)
| *test/log.sh* (origin)
|    Unit tests.

| */usr/local/share/examples/ru.sh/log.sh*(install)
| *examples/log.sh* (origin)
|    Examples of usage.


# EXAMPLES
To display an OK message on *stdout* without logging it to a file:
```
log_ok 'This is an OK message'
```
Sample output:

[ OK ] Aug 03 09:12:33: This is an OK message...

To display a WARN message on *stdout* and log it to *test.log*:
```
export LOG_FILE=test.log
log_warn 'This is a warning message'
```
Sample output:

[WARN] Aug 03 09:12:33: This is a warning message...

To log the output of the `mount` command:
```
mount | log_dump
```
Sample output:

[DUMP] Sep 07 13:57:18:
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sys on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
dev on /dev type devtmpfs (rw,nosuid,relatime,size=8133996k,nr_inodes=2033499,mode=755,inode64)
run on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755,inode64)
efivarfs on /sys/firmware/efi/efivars type efivarfs (rw,nosuid,nodev,noexec,relatime)
/dev/sdb2 on / type ext4 (rw,relatime)

More examples of common use cases can be found in the *examples/log.sh* file
provided with the source code.


# STANDARDS
The Log component conforms to the POSIX.1-2017 Shell Command Language.


# BUGS
Piping to `log_dump` does not work as anticipated in some situations; this is
still being investigated. To report other bugs, please send an e-mail to 
`<abhishek@taranjali.org>`.


# AUTHORS
Developed and maintained by Abhishek Chakravarti `<abhishek@taranjali.org>`.


# COPYRIGHT
Copyright &copy; 2022 Abhishek Chakravarti `<abhishek@taranjali.org>`.
SPDX-License-Identifier: BSD-2-Clause. This is free and open source software:
you are free to use and redistribute it under the provisions of the BSD 2-Clause
License. There is NO WARRANTY, to the extent permitted by law. See the `LICENSE`
file provided with the source code for the full license text.


# SEE ALSO
**ru.sh(3)**


# COLOPHON
This page is part of release 0.0.1 of the `ru.sh` (*R*e*U*sable *S*hell
*H*elpers) project. The latest version of this project is available from the
public mirrors at [CodeBerg](https://codeberg.org/abhishekc/ru.sh)and
[GitHub](https://github.com/achakravarti/ru.sh).
