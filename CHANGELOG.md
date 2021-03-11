# Release Notes: _fifa_

A tool to find out the way to any "planet".

## 1.5.2

Released at:

1. Upgraded to mruby 3.0.0

[Full Changelog](https://github.com/katzer/fifa/compare/1.5.1...master)

## 1.5.1

<details><summary>Releasenotes</summary>
<p>

Released at: 18.03.2020

1. Compiled binary for OSX build with MacOSX10.15 SDK

2. Upgraded to mruby 2.1.0

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.5.0...1.5.1)
</details>

## 1.5.0

Released at: 13.08.2019

<details><summary>Releasenotes</summary>
<p>

1. Compiled with `MRB_WITHOUT_FLOAT`

2. Compiled binary for OSX build with MacOSX10.13 SDK (Darwin17)

3. Upgraded to mruby 2.0.1

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.7...1.5.0)
</details>

## 1.4.7

Released at: 02.01.2019

<details><summary>Releasenotes</summary>
<p>

1. New command-line argument parser.

   Before:
   ```
   $ fifa -f=url
   ```

   After:
   ```
   $ fifa -f url
   ```

2. Support for the new KeePass properties.

3. Internal code rewrite and restructure.

4. Added -n flag as an alias for --no-color.

5. Removed LVAR section for non test builds.

6. Upgraded to mruby 2.0.0

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.6...1.4.7)
</details>

## 1.4.6

Released at: 16.08.2018

<details><summary>Releasenotes</summary>
<p>

1. Increase MacOSX min SDK version from 10.5 to to 10.11

2. Remove 32-bit build targets.

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.5...1.4.6)
</details>

## 1.4.5

Released at: 02.01.2019

<details><summary>Releasenotes</summary>
<p>

1. Row number for table output starts with 1. instead of 0.

2. Renamed target x86_64-pc-linux-busybox to x86_64-alpine-linux-musl

3. Improved compiler optimizations:

  - Shrinks binary size by 1/4

4. Upgrade to mruby-1.4.1

5. Added --group flag

   ```sh
   $ fifa -c type=server type=web type=db type=tool
   41
   82
   84
   85

   $ fifa -c -g type # Finds out types dynamically
   41
   82
   84
   85
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.4...1.4.5)
</details>

## 1.4.4

Released at: 17.11.2017

<details><summary>Releasenotes</summary>
<p>

No notable changes

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.3...1.4.4)
</details>

## 1.4.3

Released at: 11.07.2017

<details><summary>Releasenotes</summary>
<p>

1. Upgraded to mruby-1.3.0

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.2...1.4.3)
</details>

## 1.4.2

Released at: 31.05.2017

<details><summary>Releasenotes</summary>
<p>

1. Bug fixes for edge cases like if type attribute is missing.

2. Colorized error output.

3. Proper print complex attributes.

4. Return result set in sorted order only if -s flag is given.

   ```
   $ fifa -s type=db
   ```

5. Performance enhancements.

6. Switched from gcc to clang compiler.

7. Support connection details in _json_ format:

   ```
   $ fifa -f=json app-package-1
   {"id":"app-package-1","name":"App-Package 1","type":"server",...}
   ```

8. Compile binary for OSX with MacOSX10.11 SDK (Darwin15).

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.1...1.4.2)
</details>

## 1.4.1

Released at: 15.03.2017

<details><summary>Releasenotes</summary>
<p>

1. Colorized error output.

2. Added column to ski format to indicate if the planet is valid:

   ```
   $ fifa -f=ski valid-package invalid-package
   1|valid-package|server|App Package|user@hostname-1.de
   0|valid-package|server|App Package|missing user
   ```

3. Added --no-color flag to disable the colorized output.

4. Print errors without line breaks if not pretty printed.

5. Log errors if referenced server is unknown or invalid.

6. Return result set in sorted order.

7. Exit with failure if type is missing.

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.4.0...1.4.1)
</details>

## 1.4.0

Released at: 10.03.2017

<details><summary>Releasenotes</summary>
<p>

1. Removed -e flag

2. Find planets by generic match queries:

   ```
   $ fifa type=server@env=prod type=db%tags:Jens
   ```

3. Get count of matching planets per query:

   ```
   $ fifa -c type=db@tags:ora10 type=db@tags:ora11
   0
   25
   ```

   ```
   $ fifa -p -c type=server "type:db|web"
   +-----+------------+--------+-----------+-------------+------------------------+-------+
   |                          ./fifa -p -c type=server type:db|web                        |
   +-----+------------+--------+-----------+-------------+------------------------+-------+
   | NR. | ID         | TYPE   | NAME      | MATCHER     | CONNECTION             | COUNT |
   +-----+------------+--------+-----------+-------------+------------------------+-------+
   |  0. | my-app     | server | Server    | type=server | user1@url1.de          | 1     |
   +-----+------------+--------+-----------+-------------+------------------------+-------+
   |  1. | my-db      | db     | Database  | type:db|web | url_url1.bla.blergh.de | 2     |
   |     | my-web     | web    | Webserver |             | https://url.1.net      |       |
   +-----+------------+--------+-----------+-------------+------------------------+-------+
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.3.2...1.4.0)
</details>

## 1.3.2

Released at: 01.03.2017

<details><summary>Releasenotes</summary>
<p>

1. Renamed the tool to fifa (<b>Fi</b>nd<b>Fa</b>st).

2. Binaries for Linux BusyBox:

  - Linux (64-bit BusyBox): `mruby/build/x86_64-pc-linux-busybox/bin/fifa`

3. Improved binary striping:

  - Fixed for Linux which was broken since v1.2.0
  - Added support for OSX and Windows binaries
  - Shrinks binary size to 1/4

4. Changed order of columns and ski format.

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.3.1...1.3.2)
</details>

## 1.3.1

Released at: 14.02.2017

<details><summary>Releasenotes</summary>
<p>

1. The version flag gives more information about the compiled binary and the host system:

   ```
   $ fifa -v
   v1.3.1 - Linux 32-Bit (x86_64)
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.3.0...1.3.1)
</details>

## 1.3.0

Released at: 09.02.2017

<details><summary>Releasenotes</summary>
<p>

1. Changed the default name of config file:

   ```
   $ORBIT_HOME/config/orbit_file.json -> $ORBIT_HOME/config/orbit.json
   ```

2. Support empty list of planet ids to go through all configured items:

   ```
   $ fifa -f=url
   user@hostname-1.de
   user@hostname-2.de
   ```

3. Strict command argument validation:

   ```
   $ fifa -xyz app-package-1
   unknown option: -xyz
   ```

4. Support connection details in _ski_ format:

   ```
   $ fifa -f=ski app-package-1
   app-package-1|server|App-Package 1|user@hostname-1.de
   ```

5. Improved pretty table output:

   ```
   $ fifa -p app-package-1
   +-----+---------------+--------+---------------+----------------+
   |                      ff -p app-package-1                      |
   +-----+---------------+--------+---------------+----------------+
   | NR. | ID            | TYPE   | NAME          | CONNECTION     |
   +-----+---------------+--------+---------------+----------------+
   |  0. | app-package-1 | server | App-Package 1 | <missing user> |
   +-----+---------------+--------+---------------+----------------+
   ```

6. Missing properties or unknown ids do not throw runtime errors anymore:

   ```
   $ fifa -p incomplete-id unknown-id
   +-----+---------------+---------+---------------+----------------+
   |                 ff -p incomplete-id unknown-id                 |
   +-----+---------------+---------+---------------+----------------+
   | NR. | ID            | TYPE    | NAME          | CONNECTION     |
   +-----+---------------+---------+---------------+----------------+
   |  0. | incomplete-id | server  | App-Package 1 | <missing user> |
   +-----+---------------+---------+---------------+----------------+
   |  1. | unknown-id    | unknown | unknown       | <unknown>      |
   +-----+---------------+---------+---------------+----------------+
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.2.0...1.3.0)
</details>

## 1.2.0

Released at: 25.01.2017

<details><summary>Releasenotes</summary>
<p>

1. Support for `$ORBIT_HOME`. The _orbit_file.json_ formerly specified by `$ORBIT_KEY` has to be placed by default under $ORBIT_HOME/config/orbit_file.json.

2. Binaries for both glibc 2.12 (or earlier like centos6) and 2.14 (or later like ubuntu14 or centos7).

  - Linux (64-bit, for old distros): `mruby/build/x86_64-pc-linux-gnu-glibc-2.12/bin/ff`
  - Linux (32-bit, for old distros): `mruby/build/i686-pc-linux-gnu-glibc-2.12/bin/ff`
  - Linux (64-bit GNU): `mruby/build/x86_64-pc-linux-gnu-glibc-2.14/bin/ff`
  - Linux (32-bit GNU): `mruby/build/i686-pc-linux-gnu-glibc-2.14/bin/ff`

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.1.0...1.2.0)
</details>

## 1.1.0

Released at: 14.12.2016

<details><summary>Releasenotes</summary>
<p>

1. Added custom _pqdb_ format:

   ``` json
   // orbit_file.json

   [{
       "id": "app-package",
       "type": "server",
       "user": "user",
       "url": "server.de"
   },{
       "id": "db-package",
       "server": "app-package",
       "db": "OP_DB",
       "type": "db"
   }]
   ```

   ```
   $ fifa -f=pqdb db-package
   OP_DB:user@server.de
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.0.1...1.1.0)
</details>

## 1.0.1

Released at: 08.12.2016

<details><summary>Releasenotes</summary>
<p>

1. Fixed tiny format issue when using the pretty print flag.

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/1.0.0...1.0.1)
</details>

## 1.0.0

Released at: 21.11.2016

<details><summary>Releasenotes</summary>
<p>

1. Support for multiple planets:

   ```
   $ fifa app-package-1 app-package-2
   user@hostname-1.de
   user@hostname-2.de
   ```

2. Added flag for pretty printed output:

   ```
   $ fifa -p app-package db-package web-package

     NR   PLANET        CONNECTION            
     =========================================
      0   app-package   user1@url1.de         
      1   db-package    url_url1.bla.blergh.de
      2   web-package   https://url.1.net
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/0.0.2...1.0.0)
</details>

## 0.0.2

Released at: 11.11.2016

<details><summary>Releasenotes</summary>
<p>

1. Get a specific attribute:

   ```
   $ fifa -a=port db-package
   1234
   ```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/0.0.1...0.0.2)
</details>

## 0.0.1

Released at: 06.11.2016

<details><summary>Releasenotes</summary>
<p>

```
$ fifa -h
usage: ff [options...] <planet>
Options:
-e=TYPE          Expected type of planet to validate against
-f=FORMAT        Show formatted connection string
                 Possible formats are jdbc, sqlplus, url or tns
-t, --type       Show type of planet
-h, --help       This help text
-v, --version    Show version number
```

Get the connection by type:

```
$ export ORBIT_FILE=/path/to/orbit.json

$ fifa app-package
$ user@hostname.de

$ fifa -f=tns db-package
$ (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host.de)(PORT=1234)))(CONNECT_DATA=(SID=hostid)))
```

Get the type:

```
$ fifa -t db-package
$ db
```

Ensure the right type:

```
$ fifa -e=web db-package
$ type missmatch: expected web but got db
```

</p>

[Full Changelog](https://github.com/katzer/fifa/compare/f3d163089181041b58155665df5d79bfedf2b997...0.0.1)
</details>
