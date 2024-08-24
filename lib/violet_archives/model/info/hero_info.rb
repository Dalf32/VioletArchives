require_relative 'ability_info'
require_relative 'facet_info'
require_relative 'talent_info'

module VioletArchives
  # Information about a DotA hero
  class HeroInfo
    def initialize(hero_data)
      @hero_data = hero_data
    end

    def name
      @hero_data['name_loc']
    end

    def attack_type
      [nil, 'Melee', 'Ranged'][@hero_data['attack_capability']]
    end

    def attribute
      %w[Strength Agility Intelligence Universal][@hero_data['primary_attr']]
    end

    def short_desc
      @hero_data['npe_desc_loc']
    end

    def abilities
      abils = @hero_data['abilities'].map { |ability_data| AbilityInfo.new(ability_data) }
      abils + @hero_data['facet_abilities'].map do |facet_abil|
        facet_data = facet_abil.dig('abilities', 0)
        facet_data.nil? ? nil : AbilityInfo.new(facet_data)
      end.compact
    end

    def abilities_ordered
      abils = abilities.filter(&:learnable?).reject(&:ult?) + aghs_abilities + [ult]
      abils = [innate] + abils unless innate.learnable?
      abils + abilities.reject { |a| abils.include?(a) }
    end

    def innate
      abilities.find(&:innate?)
    end

    def ult
      abilities.find { |abil| abil.ult? && !abil.from_scepter? && !abil.from_shard? }
    end

    def aghs_abilities
      (abilities.select(&:from_scepter?) + abilities.select(&:from_shard?)).compact
    end

    def facets
      @hero_data['facets'].map { |facet_data| FacetInfo.new(facet_data, facet_bonus_values) }
    end

    def talents
      @hero_data['talents'].map { |talent_data| TalentInfo.new(talent_data, bonus_values) }.reverse.each_slice(2).to_a
    end

    private

    def bonus_values
      abilities.flat_map(&:special_values).flat_map(&:bonuses)
    end

    def facet_bonus_values
      abilities.flat_map(&:special_values).map(&:facet_bonus).reject(&:empty?)
    end
  end
end
