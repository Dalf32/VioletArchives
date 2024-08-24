require 'date'
require_relative 'entity'

module VioletArchives
  # A numbered collection of changes
  class Patch
    def self.base_number(patch_num)
      patch_num.gsub(/[a-zA-Z]/, '')
    end

    attr_reader :number, :timestamp, :item_changes, :neutral_changes, :hero_changes

    def initialize(number, timestamp)
      @number = number
      @timestamp = timestamp
      @item_changes = []
      @neutral_changes = []
      @hero_changes = []
    end

    def base_number
      Patch.base_number(@number)
    end

    def add_item(item)
      @item_changes << item
    end

    def add_neutral(neutral)
      @neutral_changes << neutral
    end

    def add_hero(hero)
      @hero_changes << hero
    end

    def add(entity)
      return unless entity.is_a?(Entity)

      case entity.type
        when :item
          add_item(entity)
        when :neutral
          add_neutral(entity)
        when :hero
          add_hero(entity)
      end
    end
    alias << add

    def to_s
      "#{@number} (#{Time.at(@timestamp).to_date})"
    end

    def to_hash
      {
        number: @number, timestamp: @timestamp,
        item_changes: @item_changes.map(&:to_hash),
        neutral_changes: @neutral_changes.map(&:to_hash),
        hero_changes: @hero_changes.map(&:to_hash)
      }
    end

    def self.from_hash(patch_hash)
      Patch.new(patch_hash['number'], patch_hash['timestamp']).tap do |patch|
        patch_hash['item_changes'].each { |item| patch.add_item(Entity.from_hash(item)) }
        patch_hash['neutral_changes'].each { |neutral| patch.add_neutral(Entity.from_hash(neutral)) }
        patch_hash['hero_changes'].each { |hero| patch.add_hero(Entity.from_hash(hero)) }
      end
    end
  end
end
