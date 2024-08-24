require_relative 'info_text_formatting'

module VioletArchives
  # Information about a DotA hero facet
  class FacetInfo
    include InfoTextFormatting

    def initialize(facet_data, bonus_values)
      @facet_data = facet_data
      @bonus_value = bonus_values.find { |val| val.name == name_id }
    end

    def name_id
      @facet_data['name']
    end

    def name
      @facet_data['title_loc']
    end

    def short_desc
      strip_html(replace_single_placeholder(@facet_data['description_loc'], @bonus_value))
    end
  end
end
