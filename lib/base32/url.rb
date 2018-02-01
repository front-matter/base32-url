# encoding: UTF-8
#
# (c) 2008, Levin Alexander <http://levinalex.net>
#
# This file is released under the same license as ruby.

require 'enumerator'

module Base32
end

# this is *not* the same as the Base32 encoding defined in RFC 4648
#
# The Base32 symbol set is a superset of the Base16 symbol set.
#
# We chose a symbol set of 10 digits and 22 letters. We exclude 4 of the 26
# letters: i l o u.
#
# Excluded Letters
#
# i:: Can be confused with 1
# l:: Can be confused with 1
# o:: Can be confused with 0
# u:: Accidental obscenity
#
# When decoding, upper and lower case letters are accepted, and i and l will
# be treated as 1 and o will be treated as 0. When encoding, lower case
# letters are used.
#
# If the bit-length of the number to be encoded is not a multiple of 5 bits,
# then zero-extend the number to make its bit-length a multiple of 5.
#
# Hyphens (-) can be inserted into symbol strings. This can partition a
# string into manageable pieces, improving readability by helping to prevent
# confusion. Hyphens are ignored during decoding. An application may look for
# hyphens to assure symbol string correctness.
#
#
class Base32::URL
  ENCODE_CHARS =
    %w(0 1 2 3 4 5 6 7 8 9 a b c d e f g h j k m n p q r s t v w x y z ?)

  DECODE_MAP = ENCODE_CHARS.to_enum(:each_with_index).reduce({}) do |hsh, (c,i)|
    hsh[c] = i
    hsh
  end.merge({'i' => 1, 'l' => 1, 'o' => 0})

  # encodes an integer into a string
  #
  # when +checksum+ is given, a checksum is added at the end of the the string,
  # calculated as modulo 97-10 (ISO 7064)
  #
  # when +split+ is given a hyphen is inserted every <n> characters to improve
  # readability
  #
  # when +length+ is given, the resulting string is zero-padded to be exactly
  # this number of characters long (hyphens are ignored)
  #
  #   Base32::URL.encode(1234) # => "16j"
  #   Base32::URL.encode(123456789012345, :split=>5) # => "3g923-0vqvs"
  #
  def self.encode(number, opts = {})
    # verify options
    raise ArgumentError unless (opts.keys - [:length, :split, :checksum] == [])

    str = number.to_s(2).reverse.scan(/.{1,5}/).map do |bits|
      ENCODE_CHARS[bits.reverse.to_i(2)]
    end.reverse.join

    if opts[:checksum]
      remainder = 98 - ((number * 100) % 97)
      str += sprintf("%02d", remainder)
    end

    str = str.rjust(opts[:length], '0') if opts[:length]

    if opts[:split]
      str = str.reverse
      str = str.scan(/.{1,#{opts[:split]}}/).map { |x| x.reverse }
      str = str.reverse.join("-")
    end

    str
  end

  # decode a string to an integer using Douglas Crockfords Base32 Encoding
  #
  # the string is converted to uppercase and hyphens are stripped before
  # decoding
  #
  #   I,i,l,L decodes to 1
  #   O,o decodes to 0
  #
  #   Base32::URL.decode("16J") # => 1234
  #   Base32::URL.decode("OI") # => 1
  #   Base32::URL.decode("3G923-0VQVS") # => 123456789012345
  #
  # returns +nil+ if the string contains invalid characters and can't be
  # decoded, or if checksum option is used and checksum is incorrect

  def self.decode(string, opts = {})
    string, checksum = string[0..-3], string[-2..-1].to_i if opts[:checksum]

    number = clean(string).split(//).map { |char|
      DECODE_MAP[char] or return nil
    }.inject(0) { |result,val| (result << 5) + val }

    if opts[:checksum]
      remainder = 98 - ((number * 100) % 97)
      return nil if remainder != checksum
    end

    number
  end

  # same as decode, but raises ArgumentError when the string can't be decoded
  def self.decode!(string, opts = {})
    decode(string) or raise ArgumentError
  end

  # return the canonical encoding of a string. converts it to uppercase
  # and removes hyphens
  #
  # replaces invalid characters with a question mark ('?')
  #
  def self.normalize(string, opts = {})
    if opts[:checksum]
      checksum = string.split(//).last(2).join
      string = string[0..-2]
    end

    string = clean(string).split(//).map do |char|
      ENCODE_CHARS[DECODE_MAP[char] || 32]
    end.join

    string += checksum if opts[:checksum]

    string
  end

  # returns false if the string contains invalid characters and can't be
  # decoded
  #
  def self.valid?(string, opts = {})
    !(normalize(string, opts) =~ /\?/)
  end

  class << self
    def clean(string)
      string.gsub(/-/,'').downcase
    end
    private :clean
  end
end
