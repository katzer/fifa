## Release Notes: _fifa_

### 1.4.1 (not yet released)

1. Colorized error output across all platforms.

2. Added --no-color flag to disable the colorized output.

3. Print errors without line breaks if not pretty printed.

### 1.4.0 (10.03.2017)

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

### 1.3.2 (01.03.2017)

1. Renamed the tool to fifa (<b>Fi</b>nd<b>Fa</b>st).

2. Binaries for Linux BusyBox:

  - Linux (64-bit BusyBox): `mruby/build/x86_64-pc-linux-busybox/bin/fifa`

3. Imroved binary striping:

  - Fixed for Linux which was broken since v1.2.0
  - Added support for OSX and Windows binaries
  - Shrinks binary size to 1/4

4. Changed order of columns and ski format.


### 1.3.1 (14.02.2017)

1. The version flag gives more information about the compiled binary and the host system:

   ```
   $ ff -v
   v1.3.1 - Linux 32-Bit (x86_64)
   ```


### 1.3.0 (09.02.2017)

1. Changed the default name of config file:

   ```
   $ORBIT_HOME/config/orbit_file.json -> $ORBIT_HOME/config/orbit.json
   ```

2. Support empty list of planet ids to go through all configured items:

   ```
   $ ff -f=url
   user@hostname-1.de
   user@hostname-2.de
   ```

3. Strict command argument validation:

   ```
   $ ff -xyz app-package-1
   unknown option: -xyz
   ```

4. Support connection details in _ski_ format:

   ```
   $ ff -f=ski app-package-1
   app-package-1|server|App-Package 1|user@hostname-1.de
   ```

5. Improved pretty table output:

   ```
   $ ff -p app-package-1
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
   $ ff -p incomplete-id unknown-id
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


### 1.2.0 (25.01.2017)

1. Support for `$ORBIT_HOME`. The _orbit_file.json_ formerly specified by `$ORBIT_KEY` has to be placed by default under $ORBIT_HOME/config/orbit_file.json.

2. Binaries for both glibc 2.12 (or earlier like centos6) and 2.14 (or later like ubuntu14 or centos7).

  - Linux (64-bit, for old distros): `mruby/build/x86_64-pc-linux-gnu-glibc-2.12/bin/ff`
  - Linux (32-bit, for old distros): `mruby/build/i686-pc-linux-gnu-glibc-2.12/bin/ff`
  - Linux (64-bit GNU): `mruby/build/x86_64-pc-linux-gnu-glibc-2.14/bin/ff`
  - Linux (32-bit GNU): `mruby/build/i686-pc-linux-gnu-glibc-2.14/bin/ff`


### 1.1.0 (14.12.2016)

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
   $ ff -f=pqdb db-package
   OP_DB:user@server.de
   ```


### 1.0.1 (08.12.2016)

1. Fixed tiny format issue when using the pretty print flag.


### 1.0.0 (21.11.2016)

1. Support for multiple planets:

   ```
   $ ff app-package-1 app-package-2
   user@hostname-1.de
   user@hostname-2.de
   ```

2. Added flag for pretty printed output:

   ```
   $ ff -p app-package db-package web-package

     NR   PLANET        CONNECTION            
     =========================================
      0   app-package   user1@url1.de         
      1   db-package    url_url1.bla.blergh.de
      2   web-package   https://url.1.net
   ```


### 0.0.2 (11.11.2016)

1. Get a specific attribute:

   ```
   $ ff -a=port db-package
   1234
   ```


### 0.0.1 - Initial release (06.11.2016)

Cross-platform CLI tool to find out the way to any "planet".

```
$ ff -h
usage: ff [options...] <planet>
Options:
-e=TYPE          Expected type of planet to validate against
-f=FORMAT        Show formatted connection string
                 Possible formats are jdbc, sqlplus, url or tns
-t, --type       Show type of planet
-h, --help       This help text
-v, --version    Show version number
```

## Basic Usage

Get the connection by type:

```
$ export ORBIT_FILE=/path/to/orbit.json

$ ff app-package
$ user@hostname.de

$ ff -f=tns db-package
$ (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host.de)(PORT=1234)))(CONNECT_DATA=(SID=hostid)))
```

## Advanced features

Get the type:

```
$ ff -t db-package
$ db
```

Ensure the right type:

```
$ ff -e=web db-package
$ type missmatch: expected web but got db
```

