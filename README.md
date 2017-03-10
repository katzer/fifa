# fifa [![GitHub release](https://img.shields.io/github/release/appPlant/ff.svg)](https://github.com/appPlant/ff/releases) [![Build Status](https://travis-ci.org/appPlant/ff.svg?branch=master)](https://travis-ci.org/appPlant/ff) [![codebeat badge](https://codebeat.co/badges/5cfefd2d-baeb-4067-9c3a-672dba3a7ee9)](https://codebeat.co/projects/github-com-appplant-ff)

Cross-platform CLI tool to find out the way to any "planet".

    $ fifa -h
    usage: fifa [options...] <planet>...
    Options:
    -a=ATTRIBUTE     Show value of attribute
    -f=FORMAT        Show formatted connection string
                     Possible formats are jdbc, sqlplus, url, tns or pqdb
    -p, --pretty     Pretty print output as a table
    -t, --type       Show type of planet
    -h, --help       This help text
    -v, --version    Show version number

## Prerequisites
You'll need to add your `ORBIT_FILE` first to your profile:

    $ export ORBIT_FILE=/path/to/orbit.json

## Installation

Download the latest version from the [release page][releases] and add the executable to your `PATH`.

## Development

Clone the repo:
    
    $ git clone https://github.com/appPlant/ff.git && cd ff/

Make the scripts executable

    $ chmod u+x scripts/*

And then execute:

```bash
$ scripts/compile # https://docs.docker.com/engine/installation
```

You'll be able to find the binaries in the following directories:

- Linux (64-bit, for old distros): `mruby/build/x86_64-pc-linux-gnu-glibc-2.12/bin/fifa`
- Linux (32-bit, for old distros): `mruby/build/i686-pc-linux-gnu-glibc-2.12/bin/fifa`
- Linux (64-bit GNU): `mruby/build/x86_64-pc-linux-gnu/bin/fifa`
- Linux (32-bit GNU): `mruby/build/i686-pc-linux-gnu/bin/fifa`
- Linux (64-bit BusyBox): `mruby/build/x86_64-pc-linux-busybox/bin/fifa`
- OS X (64-bit): `mruby/build/x86_64-apple-darwin14/bin/fifa`
- OS X (32-bit): `mruby/build/i386-apple-darwin14/bin/fifa`
- Windows (64-bit): `mruby/build/x86_64-w64-mingw32/bin/fifa`
- Windows (32-bit): `mruby/build/i686-w64-mingw32/bin/fifa`

## Basic Usage

Get the connection by type:

    $ export ORBIT_FILE=/path/to/orbit.json

    $ fifa app-package-1 app-package-2
    $ user@hostname-1.de
    $ user@hostname-2.de

    $ fifa -f=tns db-package
    $ (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host.de)(PORT=1234)))(CONNECT_DATA=(SID=hostid)))

Passing ids is optional. If no ids are specified, then _ff_ executes the request for all found planets.

Get the type:

    $ fifa -t db-package
    $ db

Get a specific attribute:

    $ fifa -a=port db-package
    $ 1234

Pretty print output:

    $ fifa -p app-package db-package web-package
    
    +-----+-------------+--------+-----------+------------------------+
    |           ./fifa -p app-package db-package web-package          |
    +-----+-------------+--------+-----------+------------------------+
    | NR. | ID          | TYPE   | NAME      | CONNECTION             |
    +-----+-------------+--------+-----------+------------------------+
    |  0. | app-package | server | Server    | user1@url1.de          |
    +-----+-------------+--------+-----------+------------------------+
    |  1. | db-package  | db     | Database  | url_url1.bla.blergh.de |
    +-----+-------------+--------+-----------+------------------------+
    |  2. | web-package | web    | Webserver | https://url.1.net      |
    +-----+-------------+--------+-----------+------------------------+

## Matchers

As its done the good old way:

    $ ff planet-1 planet-2

That basically means to find any planet with id _planet-1_ __or__ _planet-2_ and is just a shortened way for:

    $ ff id=planet-1 id=planet-2

Which is a shortened way for:

    $ ff @id=planet-1 @id=planet-2

The opposite, e.g. find all planets who have a different id other than _planet-1_ __and__ _planet-2_ can be expressed as follows:

    $ ff %id=planet-1%id=planet-2

Or by using a regular expression:

    $ ff %id:planet-1|planet-2

Lets find all productive server Jens has to take care about:

    $ ff type=server@env=prod@tags:Jens

## Internal features

Format used by the _ski_ tool:

    $ fifa -f=ski app-package db-package web-package
    $ app-package|server|My App-Package|user1@url1.de
    $ db-package|db|My DB-Package|OP-DB:user1@url1.de
    $ web-package|web|My Web-Package|https://url.1.net

The general format is `type|id|name|type specific connection`.

## Releases

    $ scripts/release

Affer this command finishes, you'll see the /releases for each target in the releases directory.

## Tests

To run all tests:

    $ scripts/bintest

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appplant/ff.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

The code is available as open source under the terms of the [Apache 2.0 License][license].

Made with :yum: from Leipzig

© 2016 [appPlant GmbH][appplant]

[releases]: https://github.com/appPlant/ff/releases
[docker]: https://docs.docker.com/engine/installation
[license]: http://opensource.org/licenses/Apache-2.0
[appplant]: www.appplant.de
