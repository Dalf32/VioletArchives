module VioletArchives
  # Formats data objects for text output
  class DotaTextFormatter
    def initialize(dota_dataset)
      @dota_dataset = dota_dataset
    end

    def format_entity(changed_entity)
      changed_entity.nil? ? 'No changes found.' : pretty_print(changed_entity)
    end

    def format_entities(changed_entities)
      return format_entity(changed_entities) unless changed_entities.is_a?(Enumerable)

      changed_entities.empty? ? 'No changes found.' : changed_entities.map { |entity| pretty_print(entity) }.join("\n\n")
    end

    def format_trend(patch_change_pairs)
      return '' if patch_change_pairs.empty?

      patch_change_pairs = patch_change_pairs.reverse
      first_row = patch_change_pairs.map(&:first).map { |patch_num| patch_num.ljust(6) }
      second_row = patch_change_pairs.map(&:last).map { |change| change.change_arrow_str.ljust(6) }
      entity_name = name(patch_change_pairs.first.last)

      "#{entity_name}\n #{first_row.join(' | ')}\n #{second_row.join(' | ')}"
    end

    def format_hero(hero_info)
      abilities = hero_info.abilities_ordered
      max_left_talent = hero_info.talents.map { |pair| pair.first.name.length }.max

      <<~HERO
        #{hero_info.name}
        #{'=' * (hero_info.name.length + 1)}
        #{hero_info.attack_type} #{hero_info.attribute} Hero
        #{hero_info.short_desc}

        Abilities
        ----------
          #{abilities.map do |ability|
            label = 'Innate: ' if ability.innate?
            label = 'Ultimate: ' if ability.ult?
            label = 'Shard: ' if ability.from_shard?
            label = 'Scepter: ' if ability.from_scepter?

            "#{label}#{ability.name}\n  #{ability.short_desc}\n"
          end.join("\n  ")}
        Facets
        -------
          #{hero_info.facets.map do |facet|
            "#{facet.name}\n  #{facet.short_desc}\n"
          end.join("\n  ")}
        Talents
        --------
          #{hero_info.talents.map.with_index { |pair, i| "#{pair.first.name.rjust(max_left_talent)} |#{(5 - i) * 5}| #{pair.last.name}" }.join("\n  ")}
      HERO
    end

    def format_ability(ability_info)
      aghs_upgrades = ''
      aghs_upgrades += "\nScepter Upgrade: #{ability_info.scepter_desc}" if ability_info.scepter_upgrade?
      aghs_upgrades += "\nShard Upgrade: #{ability_info.shard_desc}" if ability_info.shard_upgrade?

      <<~ABILITY
        #{ability_info.name}
        #{'=' * (ability_info.name.length + 1)}
        #{format_ability_details(ability_info).strip}
        #{aghs_upgrades}
      ABILITY
    end

    def format_item(item_info)
      bonus_values = item_info.bonus_values.map { |val| "+#{val.values.first} #{val.heading}" }.join("\n")
      bonus_values += "\n" unless bonus_values.empty?

      <<~ITEM
        #{item_info.name}
        #{'=' * (item_info.name.length + 1)}
        #{bonus_values}#{item_info.ability? ? format_ability_details(item_info) : ''}
        #{item_info.neutral? ? "Neutral Tier: #{item_info.neutral_tier}" : "Cost: #{item_info.gold_cost}"}
      ITEM
    end

    private

    def pretty_print(entity)
      entity.pretty_print(@dota_dataset.item_map, @dota_dataset.ability_map, @dota_dataset.hero_map)
    end

    def name(entity)
      entity.name(@dota_dataset.item_map, @dota_dataset.ability_map, @dota_dataset.hero_map)
    end

    def format_target_detail(ability_info)
      target_detail = "Ability: #{ability_info.target_type}"
      target_detail += "\nAffects: #{ability_info.target_team} #{ability_info.target_affects}" unless ability_info.no_target?
      target_detail += "\nDamage Type: #{ability_info.damage_type}" unless ability_info.no_damage?
      target_detail
    end

    def format_debuff_piercing(ability_info)
      debuff_piercing = ''
      debuff_piercing += "Pierces Spell Immunity: #{ability_info.pierces_spell_immunity? ? 'Yes' : 'No'}\n" if ability_info.anything_to_pierce?
      debuff_piercing += "Dispellable: #{ability_info.dispellable}\n" if ability_info.anything_to_dispel?
      debuff_piercing
    end

    def format_ability_values(ability_info)
      values = ability_info.ability_values.map { |val| "#{val.heading} #{val.values_str}" }.join("\n")
      values += "\n\nCooldown: #{ability_info.cooldowns.join('/')}" if ability_info.cooldowns?
      values += "\nMana Cost: #{ability_info.mana_costs.join('/')}" if ability_info.mana_costs?
      values += "\nHealth Cost: #{ability_info.health_costs.join('/')}" if ability_info.health_costs?
      values
    end

    def format_ability_details(ability_info)
      notes = [''] + ability_info.notes.map { |note| "Note: #{note}" }

      <<~ABILITY_DETAIL
        #{ability_info.short_desc}#{notes.join("\n")}

        #{format_target_detail(ability_info)}
        #{format_debuff_piercing(ability_info)}
        #{format_ability_values(ability_info).strip}
      ABILITY_DETAIL
    end
  end
end
