# ff [![Build Status](https://travis-ci.org/appPlant/ff.svg?branch=master)](https://travis-ci.org/appPlant/ff) [![Code Climate](https://codeclimate.com/github/appPlant/ff/badges/gpa.svg)](https://codeclimate.com/github/appPlant/ff)

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

And then execute:

```bash
$ docker-compose run compile # https://docs.docker.com/engine/installation
```

You'll be able to find the binaries in the following directories:

- Linux (64-bit): `mruby/build/x86_64-pc-linux-gnu/bin/ff`
- Linux (32-bit): `mruby/build/i686-pc-linux-gnu/bin/ff`
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

## Advanced features

Get the type:

    $ ff -t db-package
    $ db

Get a specific attribute:

    $ ff -a=port db-package
    $ 1234

Ensure the right type:

    $ ff -e=web db-package
    $ type missmatch: expected web but got db

Pretty print output:

    $ ff -p app-package db-package web-package
    
      NR   PLANET        CONNECTION            
      =========================================
       0   app-package   user1@url1.de         
       1   db-package    url_url1.bla.blergh.de
       2   web-package   https://url.1.net

## Releases

    $ docker-compose run release

Affer this command finishes, you'll see the /releases for each target in the releases directory.

## Tests

To run all integration tests:

    $ docker-compose run bintest

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
