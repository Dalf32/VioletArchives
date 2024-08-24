module VioletArchives
  # A collection of Patches used for querying
  class PatchSet
    def initialize(patches)
      @patches = patches.is_a?(Array) ? patches : [patches]
    end

    def empty?
      @patches.empty?
    end

    def count
      @patches.count
    end

    def single?
      count == 1
    end

    def buffed_heroes(num)
      buffed = buffed_nerfed(:buffed?).reverse
      buffed = buffed.take(num) unless num.zero?
      buffed
    end

    def nerfed_heroes(num)
      nerfed = buffed_nerfed(:nerfed?)
      nerfed = nerfed.take(num) unless num.zero?
      nerfed
    end

    def hero_changes(hero_id)
      @patches.map { |patch| find_by_id(patch.hero_changes, hero_id) }.compact
    end

    def hero_changes_with_num(hero_id)
      @patches.map { |patch| [patch.number, find_by_id(patch.hero_changes, hero_id)] }
              .reject { |_, change| change.nil? }
    end

    def item_changes(item_id)
      found_items = @patches.map { |patch| find_by_id(patch.item_changes, item_id) }
      found_neutrals = @patches.map { |patch| find_by_id(patch.neutral_changes, item_id) }
      (found_items + found_neutrals).compact
    end

    def item_changes_with_num(item_id)
      found_items = @patches.map { |patch| [patch.number, find_by_id(patch.item_changes, item_id)] }
      found_neutrals = @patches.map { |patch| [patch.number, find_by_id(patch.neutral_changes, item_id)] }
      (found_items + found_neutrals).reject { |_, change| change.nil? }
    end

    def to_s
      @patches.join("\n")
    end

    private

    def buffed_nerfed(func)
      @patches.flat_map(&:hero_changes).group_by(&:id).values
              .map { |matches| matches.reduce(&:merge) }.select(&func)
              .sort_by(&:change_score)
    end

    def find_by_id(entity_list, entity_id)
      entity_list.find { |entity| entity.id == entity_id }
    end
  end
end
