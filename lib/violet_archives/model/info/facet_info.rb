require_relative 'info_text_formatting'

module VioletArchives
  # Information about a DotA hero facet
  class FacetInfo
    include InfoTextFormatting

    def initialize(facet_data, bonus_values, addtl_values)
      @facet_data = facet_data
      @bonus_value = bonus_values.find { |val| val.name == name_id }
      @addtl_values = addtl_values
    end

    def name_id
      @facet_data['name']
    end

    def name
      @facet_data['title_loc']
    end

    def short_desc
      strip_html(fix_percent(replace_placeholders(@facet_data['description_loc'])))
    end

    private

    def replace_placeholders(text)
      replace_multiple_placeholders(
        replace_single_placeholder(text, @bonus_value), @addtl_values
      )
    end
  end
end
