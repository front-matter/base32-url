[![Gem Version](https://badge.fury.io/rb/base32-url.svg)](https://badge.fury.io/rb/base32-url)
[![Build Status](https://travis-ci.org/datacite/base32-url.svg?branch=master)](https://travis-ci.org/datacite/base32-url)

An implementation of Douglas Crockfords Base32-Encoding in Ruby, with two modifications to make
the resulting strings more URL friendly:

* use lower case characters
* only use characters that don't need URL encoding for checksum

see <http://www.crockford.com/wrmg/base32.html>

## Installation

```
$ gem install base32-url
```

## Changes

```
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
Base32::URL.encode(1234, checksum: true)            # => "16jd"
Base32::URL.decode("16jd", checksum: true)          # => 1234
