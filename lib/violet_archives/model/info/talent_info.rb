require_relative 'ability_info'

module VioletArchives
  # Information about a DotA hero talent
  class TalentInfo < AbilityInfo
    def initialize(talent_data, bonus_values)
      super(talent_data)
      @talent_data = talent_data
      @bonus_value = bonus_values.find { |val| val.name == name_id }
    end

    def name_id
      @talent_data['name']
    end

    def name
      replace_placeholders(([super] + @talent_data['facets_loc']).reject(&:empty?).join(' / '))
    end

    protected

    def replace_placeholders(text)
      replace_single_placeholder(super, @bonus_value)
    end
  end
end
