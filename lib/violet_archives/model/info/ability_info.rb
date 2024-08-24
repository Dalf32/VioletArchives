require_relative 'ability_value'
require_relative 'dota_info_constants'
require_relative 'info_text_formatting'

module VioletArchives
  # Information about a DotA ability
  class AbilityInfo
    include InfoTextFormatting

    def initialize(ability_data)
      @ability_data = ability_data
    end

    def id
      @ability_data['id']
    end

    def name
      @ability_data['name_loc']
    end

    def short_desc
      fix_percent(strip_html(replace_placeholders(@ability_data['desc_loc'])))
    end

    def notes
      @ability_data['notes_loc'].map { |note| fix_percent(replace_placeholders(note)) }
    end

    def innate?
      @ability_data['ability_is_innate']
    end

    def from_scepter?
      @ability_data['ability_is_granted_by_scepter']
    end

    def from_shard?
      @ability_data['ability_is_granted_by_shard']
    end

    def scepter_upgrade?
      @ability_data['ability_has_scepter']
    end

    def shard_upgrade?
      @ability_data['ability_has_shard']
    end

    def scepter_desc
      fix_percent(strip_html(replace_multiple_placeholders(
                               @ability_data['scepter_loc'], special_values(use_scepter_values: true)
                             )))
    end

    def shard_desc
      fix_percent(strip_html(replace_multiple_placeholders(
                               @ability_data['shard_loc'], special_values(use_shard_values: true)
                             )))
    end

    def ult?
      @ability_data['type'] == 1
    end

    def talent?
      @ability_data['type'] == 2
    end

    def max_level
      @ability_data['max_level']
    end

    def learnable?
      (@ability_data['behavior'].to_i & DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE).zero? && max_level > 1
    end

    def target_type
      behavior = @ability_data['behavior'].to_i
      target_types = []

      target_types << 'Passive' if (behavior & DOTA_ABILITY_BEHAVIOR_PASSIVE).positive?
      target_types << 'No Target' if (behavior & DOTA_ABILITY_BEHAVIOR_NO_TARGET).positive?
      target_types << 'Unit Target' if (behavior & DOTA_ABILITY_BEHAVIOR_UNIT_TARGET).positive?
      target_types << 'Point Target' if (behavior & DOTA_ABILITY_BEHAVIOR_POINT).positive?

      target_types.join('/')
    end

    def behavior
      behavior = @ability_data['behavior'].to_i
      behaviors = []

      behaviors << 'Channelled' if (behavior & DOTA_ABILITY_BEHAVIOR_CHANNELLED).positive?
      behaviors << 'Toggle' if (behavior & DOTA_ABILITY_BEHAVIOR_TOGGLE).positive?
      behaviors << 'AOE' if (behavior & DOTA_ABILITY_BEHAVIOR_AOE).positive?
      behaviors << 'Aura' if (behavior & DOTA_ABILITY_BEHAVIOR_AURA).positive?
      behaviors << 'Auto-Cast' if (behavior & DOTA_ABILITY_BEHAVIOR_AUTOCAST).positive?

      behaviors.join('/')
    end

    def no_target?
      @ability_data['target_team'].zero? # DOTA_UNIT_TARGET_TEAM_NONE
    end

    def targets_allies?
      (@ability_data['target_team'] & DOTA_UNIT_TARGET_TEAM_FRIENDLY).positive?
    end

    def targets_enemies?
      (@ability_data['target_team'] & DOTA_UNIT_TARGET_TEAM_ENEMY).positive?
    end

    def target_team
      target_teams = []

      target_teams << 'Allied' if targets_allies?
      target_teams << 'Enemy' if targets_enemies?

      target_teams.join('/')
    end

    def no_damage?
      @ability_data['damage'].zero? # DAMAGE_TYPE_NONE
    end

    def damage_type
      damage = @ability_data['damage']

      if (damage & DAMAGE_TYPE_PHYSICAL).positive?
        'Physical'
      elsif (damage & DAMAGE_TYPE_MAGICAL).positive?
        'Magical'
      elsif (damage & DAMAGE_TYPE_PURE).positive?
        'Pure'
      end
    end

    def target_affects
      type = @ability_data['target_type']
      affects = []

      affects << 'Heroes' if (type & DOTA_UNIT_TARGET_HERO).positive?
      affects << 'Buildings' if (type & DOTA_UNIT_TARGET_BUILDING).positive?
      affects << 'Units' if (type & DOTA_UNIT_TARGET_BASIC).positive?

      affects.join('/')
    end

    def anything_to_pierce?
      @ability_data['immunity'].positive?
    end

    def pierces_spell_immunity?
      @ability_data['immunity'].odd?
    end

    def anything_to_dispel?
      @ability_data['dispellable'].positive?
    end

    def dispellable?
      [1, 2].include?(@ability_data['dispellable'])
    end

    def dispellable
      dispel = @ability_data['dispellable']

      case dispel
        when 1
          'Strong Dispels Only'
        when 2
          'Yes'
        else
          'No'
      end
    end

    def special_values(value_opts = {})
      @ability_data['special_values'].map { |val| AbilityValue.new(val, **value_opts) }
    end

    def ability_values
      values.select(&:ability_value?)
    end

    def cooldowns?
      @ability_data['cooldowns'].any? && @ability_data['cooldowns'].all?(&:positive?)
    end

    def cooldowns
      @ability_data['cooldowns']
    end

    def mana_costs?
      @ability_data['mana_costs'].any? && @ability_data['mana_costs'].all?(&:positive?)
    end

    def mana_costs
      @ability_data['mana_costs']
    end

    def health_costs?
      @ability_data['health_costs'].any? && @ability_data['health_costs'].all?(&:positive?)
    end

    def health_costs
      @ability_data['health_costs']
    end

    def ==(other)
      id == other.id
    end

    def eql?(other)
      self == other
    end

    protected

    def values
      special_values.select(&:heading?)
    end

    def replace_placeholders(text)
      replace_multiple_placeholders(text, special_values)
    end
  end
end
