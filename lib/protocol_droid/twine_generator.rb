#
# Copyright (c) 2016, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license. 
# For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
#

require "twine"

module ProtocolDroid
  class TwineGenerator

    KEY_ID = "Key"
    COMMENT_ID = "Comment"
    EN_LOCALE = "en"

    def initialize(csv, out_path)
      @csv = csv
      @out_path = out_path
      @non_english_locales = @csv.headers - [KEY_ID, COMMENT_ID, EN_LOCALE]
    end

    def generate
      section = generate_section
      strings_file = generate_strings_file(section)
      strings_file.write(@out_path)
    end

    def generate_section
      Twine::StringsSection.new("General").tap do |section|
        valid_rows = filter_duplicate_rows
        valid_rows.sort{|a, b| a[KEY_ID] <=> b[KEY_ID] }.each do |row|
          translation_row = Twine::StringsRow.new(row[KEY_ID])

          translation_row.comment = row[COMMENT_ID]

          translation_row.translations[EN_LOCALE] = row[EN_LOCALE]
          @non_english_locales.each do |locale|
            translation_row.translations[locale] = row[locale] if row[locale]
          end

          section.rows << translation_row
        end
      end
    end

    def filter_duplicate_rows
      @csv.entries.uniq{|x| x[KEY_ID] }
    end

    def generate_strings_file(section)
      Twine::StringsFile.new.tap do |strings_file|
        strings_file.set_developer_language_code(EN_LOCALE)

        @non_english_locales.each do |locale|
          strings_file.add_language_code(locale)
        end

        strings_file.sections << section
      end
    end
  end
end
