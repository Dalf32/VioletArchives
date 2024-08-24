require_relative 'model/patch'

module VioletArchives
  # Builds a Patch out of the data retrieved from the API
  class PatchBuilder
    def self.build_patch(patch_hash)
      patch = Patch.new(patch_hash['patch_number'], patch_hash['patch_timestamp'])

      patch_hash['items']&.each do |item|
        patch << Entity.new(:item, item['ability_id']).tap do |entity|
          build_changes(entity, item['ability_notes'])
        end
      end

      patch_hash['neutral_items']&.each do |neutral|
        patch << Entity.new(:neutral, neutral['ability_id']).tap do |entity|
          build_changes(entity, neutral['ability_notes'])
        end
      end

      patch_hash['heroes']&.each do |hero|
        patch << Entity.new(:hero, hero['hero_id']).tap do |entity|
          build_changes(entity, hero['hero_notes'])
          build_changes(entity, hero['talent_notes'])
          build_abilities(entity, hero['abilities'])

          hero['subsections']&.each do |subsection|
            type = subsection['style'] == 'hero_facet' ? :facet : :innate
            entity << Subsection.new(type, subsection['title']).tap do |subsec|
              build_changes(subsec, subsection['general_notes'])
              build_changes(subsec, subsection['talent_notes'])
              build_abilities(subsec, subsection['abilities'])
            end
          end
        end
      end

      patch
    end

    def self.build_abilities(entity, ability_list)
      ability_list&.each do |ability|
        entity << Entity.new(:ability, ability['ability_id']).tap do |spell|
          build_changes(spell, ability['ability_notes'])
        end
      end
    end

    def self.build_changes(entity, change_list)
      change_list&.each do |change|
        entity << Change.new(change['note'])
      end
    end

    private_class_method :build_abilities, :build_changes
  end
end
