#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

require "test_helper"
require "minitest/autorun"

class ProtocolDroid::TwineGeneratorTest < Minitest::Test
  def setup
    @raw_csv = "Key,Comment,en,de,fr\n"
    @tmp_output_path = "tmp/out.twine"
  end

  def teardown
    File.delete(@tmp_output_path)
  end

  def test_row_written_to_twine_file_for_each_raw_csv_row
    @raw_csv << "key-one,comment-one,en-one,de-one,fr-one\n"
    @raw_csv << "key-two,comment-two,en-two,de-two,fr-two"

    csv = CSV.parse(@raw_csv, {headers: true})

    generator = ProtocolDroid::TwineGenerator.new(csv, @tmp_output_path)
    generator.generate

    loaded_strings_file = Twine::StringsFile.new
    loaded_strings_file.read(@tmp_output_path)

    assert_equal 2, loaded_strings_file.sections.first.rows.count
  end

  def test_key_comment_and_translations_mapped_from_csv_columns
    @raw_csv << "key-one,comment-one,en-one,de-one,fr-one\n"
    @raw_csv << "key-two,comment-two,en-two,de-two,fr-two"

    csv = CSV.parse(@raw_csv, {headers: true})

    generator = ProtocolDroid::TwineGenerator.new(csv, @tmp_output_path)
    generator.generate

    loaded_strings_file = Twine::StringsFile.new
    loaded_strings_file.read(@tmp_output_path)

    row = loaded_strings_file.strings_map["key-one"]
    assert_equal "key-one", row.key
    assert_equal "comment-one", row.comment
    assert_equal "en-one", row.translations["en"]
    assert_equal "de-one", row.translations["de"]
    assert_equal "fr-one", row.translations["fr"]

    row = loaded_strings_file.strings_map["key-two"]
    assert_equal "key-two", row.key
    assert_equal "comment-two", row.comment
    assert_equal "en-two", row.translations["en"]
    assert_equal "de-two", row.translations["de"]
    assert_equal "fr-two", row.translations["fr"]
  end

  def test_rows_with_duplicate_keys_filtered_from_twine_file
    @raw_csv << "key-one,comment-one,en-one,de-one,fr-one\n"
    @raw_csv << "key-one,comment-two,en-two,de-two,fr-two"

    csv = CSV.parse(@raw_csv, {headers: true})

    generator = ProtocolDroid::TwineGenerator.new(csv, @tmp_output_path)
    generator.generate

    loaded_strings_file = Twine::StringsFile.new
    loaded_strings_file.read(@tmp_output_path)

    assert_equal 1, loaded_strings_file.sections.first.rows.count
  end

  def test_rows_are_sorted_by_key
    @raw_csv << "key-one,comment-one,en-one,de-one,fr-one\n"
    @raw_csv << "a-key-one,comment-two,en-two,de-two,fr-two"

    csv = CSV.parse(@raw_csv, {headers: true})

    generator = ProtocolDroid::TwineGenerator.new(csv, @tmp_output_path)
    generator.generate

    loaded_strings_file = Twine::StringsFile.new
    loaded_strings_file.read(@tmp_output_path)

    row = loaded_strings_file.sections.first.rows.first
    assert_equal "a-key-one", row.key
  end
end
