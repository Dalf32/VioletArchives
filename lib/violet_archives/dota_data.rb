require_relative 'model/info/ability_info'
require_relative 'model/info/hero_info'
require_relative 'model/info/item_info'

module VioletArchives
  # Manages access to all data needed
  class DotaData
    def initialize(repo, dota_service)
      @repo = repo
      @dota_service = dota_service
      @item_info = {}
      @ability_info = {}
      @hero_info = {}
    end

    def patches
      @patches ||= @repo.load_patches
    end

    def item_map
      @item_map ||= build_name_map(@dota_service.item_list, :item)
    end

    def ability_map
      @ability_map ||= build_name_map(@dota_service.ability_list, :ability)
    end

    def hero_map
      @hero_map ||= build_name_map(@dota_service.hero_list, :hero)
    end

    def current_patch
      patches.first
    end

    def recent_patches(num)
      patches.take(num)
    end

    def patches_with_number(patch_num)
      patches.select { |patch| patch.number.start_with?(patch_num) }
    end

    def patches_since(timestamp)
      patches.select { |patch| patch.timestamp > timestamp }
    end

    def item_id_by_name(item_name)
      get_id_by_name(item_map, item_name)
    end

    def ability_id_by_name(ability_name)
      get_id_by_name(ability_map, ability_name)
    end

    def hero_id_by_name(hero_name)
      get_id_by_name(hero_map, hero_name)
    end

    def item_data(item_id)
      unless @item_info.key?(item_id)
        item = ItemInfo.new(entity_data(@dota_service.item_data(item_id), :item))
        @item_info[item_id] = item
      end

      @item_info[item_id]
    end

    def ability_data(ability_id)
      unless @ability_info.key?(ability_id)
        abil = AbilityInfo.new(entity_data(@dota_service.ability_data(ability_id), :ability))
        @ability_info[ability_id] = abil
      end

      @ability_info[ability_id]
    end

    def hero_data(hero_id)
      unless @hero_info.key?(hero_id)
        hero = HeroInfo.new(entity_data(@dota_service.hero_data(hero_id), :hero))
        @hero_info[hero_id] = hero
      end

      @hero_info[hero_id]
    end

    private

    def build_name_map(json_hash, type)
      path = ['result', 'data', type == :hero ? 'heroes' : 'itemabilities']
      name_map = {}

      json_hash.dig(*path).each do |entity|
        name_map[entity['id']] = entity['name_loc']
      end

      name_map
    end

    def get_id_by_name(name_map, entity_name)
      name_map.to_a.find { |(_, name)| name.casecmp?(entity_name) }&.first
    end

    def entity_data(json_hash, type)
      collection_key = { item: 'items', ability: 'abilities', hero: 'heroes' }[type]
      path = ['result', 'data', collection_key, 0]
      json_hash.dig(*path)
    end
  end
end
