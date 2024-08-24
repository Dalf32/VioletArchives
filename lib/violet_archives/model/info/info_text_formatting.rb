module VioletArchives
  # Text formatting functions for info classes
  module InfoTextFormatting
    def strip_html(text)
      text.gsub(%r{<[a-zA-Z0-9 /'=#]+>}, '')
    end

    def replace_single_placeholder(text, bonus_value)
      return text if bonus_value.nil?

      text.gsub(/{s:bonus_[a-zA-Z_]+}/, bonus_value.has_single_value? ? bonus_value.value.to_s : bonus_value.values_str)
    end

    def replace_multiple_placeholders(text, special_values)
      special_values.each do |val|
        text.gsub!(/%(bonus_)?#{val.name}%/i, val.values_str)
        text.gsub!(/{s:#{val.name}}/, val.values_str)
      end

      text
    end

    def fix_percent(text)
      text.gsub('%%', '%')
    end
  end
end
