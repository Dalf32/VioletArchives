require_relative 'bonus_value'
require_relative 'info_text_formatting'

module VioletArchives
  # A value for an ability
  class AbilityValue
    include InfoTextFormatting

    def initialize(value_data, use_shard_values: false, use_scepter_values: false)
      @value_data = value_data
      @use_shard_values = use_shard_values
      @use_scepter_values = use_scepter_values
    end

    def name
      @value_data['name']
    end

    def heading?
      !@value_data['heading_loc'].empty?
    end

    def heading
      heading_text = @value_data['heading_loc'].gsub(/[+$]/, '').split('_')
      heading_text = @value_data['heading_loc'].split if ability_value?
      strip_html(heading_text.map(&:capitalize).join(' '))
    end

    def values
      shard_values = @value_data['values_shard']
      scepter_values = @value_data['values_scepter']

      return shard_values if @use_shard_values && !shard_values.empty?
      return scepter_values if @use_scepter_values && !scepter_values.empty?

      @value_data['values_float']
    end

    def percentage?
      @value_data['is_percentage']
    end

    def bonus_value?
      @value_data['heading_loc'].start_with?('+')
    end

    def ability_value?
      !bonus_value?
    end

    def values_str
      values.map { |v| "#{v}#{percentage? ? '%' : ''}" }.join('/')
    end

    def bonuses
      @value_data['bonuses'].map { |bonus| BonusValue.new(bonus) }
    end

    def facet_bonus
      BonusValue.new(@value_data['facet_bonus'])
    end
  end
end
