require_relative 'ability_info'

module VioletArchives
  # Information about a DotA item
  class ItemInfo < AbilityInfo
    def initialize(item_data)
      super
      @item_data = item_data
    end

    def gold_cost
      @item_data['item_cost']
    end

    def neutral?
      (1..5).include?(neutral_tier)
    end

    def neutral_tier
      @item_data['item_neutral_tier'] + 1
    end

    def bonus_values
      values.select(&:bonus_value?)
    end

    def ability?
      !short_desc.empty?
    end
  end
end
