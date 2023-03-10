[![Build](https://github.com/front-matter/base32-url/actions/workflows/build.yml/badge.svg)](https://github.com/front-matter/base32-url/actions/workflows/build.yml)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=front-matter_base32-url&metric=coverage)](https://sonarcloud.io/summary/new_code?id=front-matter_base32-url)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=front-matter_base32-url&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=front-matter_base32-url)
[![Gem Version](https://badge.fury.io/rb/base32-url.svg)](https://badge.fury.io/rb/base32-url)

An implementation of Douglas Crockfords Base32-Encoding in Ruby, with two modifications to make
the resulting strings more URL friendly:

* use lower case characters
* use two digits (mod 97-10, ISO 7064) for the checksum

see <http://www.crockford.com/wrmg/base32.html>

## Installation

```
$ gem install base32-url
```

## Changes

```
0.6.0 - support Ruby versions beyond 2.x
0.5.0 - use mod 97-10 (ISO 7064) to calculate checksum
0.3.0 - encode into lower case characters, use * ~ _ ^ u for checksum
0.2.0 - added optional checksum
```

## Usage

```
#!/usr/bin/env ruby

require 'base32/url'

Base32::URL.encode(1234)                            # => "16j"
Base32::URL.encode(100**10, :split=>5, :length=>15) # => "02pqh-ty5nh-h0000"
Base32::URL.decode("2pqh-ty5nh-hoooo")              # => 10**100
Base32::URL.encode(1234, checksum: true)            # => "16j82"
Base32::URL.decode("16j82", checksum: true)          # => 1234
```

## Development

We use test-unit for unit testing:

```
bundle exec rake
```

Follow along via [Github Issues](https://github.com/datacite/base32-url/issues).

### Note on Patches/Pull Requests

* Fork the project
* Write tests for your new feature or a test that reproduces a bug
* Implement your feature or make a bug fix
* Do not mess with Rakefile, version or history
* Commit, push and make a pull request. Bonus points for topical branches.

## License
**base32-url** is released under the [MIT License](https://github.com/datacite/base32-url/blob/master/LICENSE.md).
