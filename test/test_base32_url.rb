# encoding: utf-8

require 'test/unit'
require 'base32/url'

class TestBase32Url < Test::Unit::TestCase

  def test_encoding_and_decoding_single_chars
    from = (0..31).to_a
    to = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f g h j k m n p q r s t v w x y z)

    from.zip(to) do |symbol_value, encode_symbol|
      assert_equal encode_symbol, Base32::URL.encode(symbol_value)
      assert_equal symbol_value, Base32::URL.decode(encode_symbol)
    end
  end

  def test_encoding_larger_numbers
    assert_equal("10", Base32::URL.encode(32))
    assert_equal("16j", Base32::URL.encode(1234))
  end

  def test_decoding_strings
    assert_equal(1234, Base32::URL.decode("16J"))
  end

  def test_decoding_normalizes_symbols
    assert_equal Base32::URL.decode('11100110'),
      Base32::URL.decode('IL1O0ilo')
  end

  def test_decoding_lowercase
    assert_equal Base32::URL.decode("abcdefghijklmnopqrstvwxyz"),
      Base32::URL.decode("ABCDEFGHIJKLMNOPQRSTVWXYZ")
  end

  def test_decoding_invalid_strings
    assert_equal nil, Base32::URL.decode("Ü'+?")
    assert_raises(ArgumentError) { Base32::URL.decode!("'+?") }
  end

  def test_decode_should_ignore_hyphens
    assert_equal 1234, Base32::URL.decode("1-6-j")
  end

  def test_normalize
    assert_equal "he110w0r1d", Base32::URL.normalize("hello-world")
    assert_equal "he110w0r1d", Base32::URL.normalize("HELLO-WORLD")
    assert_equal "b?123", Base32::URL.normalize("BU-123")
  end

  def test_normalize_with_checksum
    assert_equal "b?123", Base32::URL.normalize("BU-123", :checksum => true)
    assert_equal "b123u", Base32::URL.normalize("B123u", :checksum => true)
  end

  def test_valid
    assert_equal true, Base32::URL.valid?("hello-world")
    assert_equal false, Base32::URL.valid?("BU-123")
  end

  def test_valid_with_checksum
    assert_equal true, Base32::URL.valid?("b123u", :checksum => true)
    assert_equal false, Base32::URL.valid?("bu-123", :checksum => true)
  end

  def test_length_and_hyphenization
    assert_equal "0016j", Base32::URL.encode(1234, :length => 5)
    assert_equal "0-01-6j",
      Base32::URL.encode(1234, :length => 5, :split => 2)
    assert_equal "00-010",
      Base32::URL.encode(32, :length => 5, :split => 3)
  end

  def test_encoding_checksum
    assert_equal "16ja",
      Base32::URL.encode(1234, :checksum => true)
    assert_equal "016ja",
      Base32::URL.encode(1234, :length => 5, :checksum => true)
    assert_equal "0-16-ja",
      Base32::URL.encode(1234, :length => 5, :split => 2, :checksum => true)
  end

  def test_decoding_checksum
    assert_equal 1234,
      Base32::URL.decode("16ja", :checksum => true)
    assert_equal 1234,
      Base32::URL.decode("016ja", :length => 5, :checksum => true)
    assert_equal 1234,
      Base32::URL.decode("0-16-ja", :length => 5, :split => 2, :checksum => true)
  end

  def test_decoding_invalid_checksum
    assert_equal nil,
      Base32::URL.decode("16jc", :checksum => true)
  end
end
