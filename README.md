# ff [![GitHub release](https://img.shields.io/github/release/appPlant/ff.svg)](https://github.com/appPlant/ff/releases) [![Build Status](https://travis-ci.org/appPlant/ff.svg?branch=master)](https://travis-ci.org/appPlant/ff) [![Code Climate](https://codeclimate.com/github/appPlant/ff/badges/gpa.svg)](https://codeclimate.com/github/appPlant/ff)

Cross-platform CLI tool to find out the way to any "planet".

    $ ff -h
    usage: ff [options...] <planet>...
    Options:
    -a=ATTRIBUTE     Show value of attribute
    -e=TYPE          Expected type of planet to validate against
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

- Linux (64-bit, for old distros): `mruby/build/x86_64-pc-linux-gnu-glibc-2.12/bin/ff`
- Linux (32-bit, for old distros): `mruby/build/i686-pc-linux-gnu-glibc-2.12/bin/ff`
- Linux (64-bit): `mruby/build/x86_64-pc-linux-gnu-glibc-2.14/bin/ff`
- Linux (32-bit): `mruby/build/i686-pc-linux-gnu-glibc-2.14/bin/ff`
- OS X (64-bit): `mruby/build/x86_64-apple-darwin14/bin/ff`
- OS X (32-bit): `mruby/build/i386-apple-darwin14/bin/ff`
- Windows (64-bit): `mruby/build/x86_64-w64-mingw32/bin/ff`
- Windows (32-bit): `mruby/build/i686-w64-mingw32/bin/ff`

## Basic Usage

Get the connection by type:

    $ export ORBIT_FILE=/path/to/orbit.json

    $ ff app-package-1 app-package-2
    $ user@hostname-1.de
    $ user@hostname-2.de

    $ ff -f=tns db-package
    $ (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=host.de)(PORT=1234)))(CONNECT_DATA=(SID=hostid)))

Passing ids is optional. If no ids are specified, then _ff_ executes the request for all found planets.

## Advanced features

Get the type:

    $ ff -t db-package
    $ db

Get a specific attribute:

    $ ff -a=port db-package
    $ 1234

Ensure the right type:

    $ ff -e=web db-package
    $ <type missmatch>

Pretty print output:

    $ ff -p app-package db-package web-package
    
      NR   PLANET        CONNECTION            
      =========================================
       0   app-package   user1@url1.de         
       1   db-package    url_url1.bla.blergh.de
       2   web-package   https://url.1.net

## Internal features

Format used by the _ski_ tool:

    $ ff -f=ski app-package db-package web-package
    $ server|app-package|My App-Package|user1@url1.de
    $ db|db-package|My DB-Package|OP-DB:user1@url1.de
    $ web|web-package|My Web-Package|https://url.1.net

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
