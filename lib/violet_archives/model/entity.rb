require_relative 'change'
require_relative 'changeable'
require_relative 'subsection'

module VioletArchives
  # A hero or item which includes other Changeable elements
  class Entity < Changeable
    attr_reader :id

    def initialize(type, id)
      super(type)

      @id = id
      @subsections = []
    end

    def add_subsection(subsec)
      @subsections << subsec
    end

    def add(child)
      if child.is_a?(Subsection)
        add_subsection(child)
      else
        super
      end
    end
    alias << add

    def all_changes
      super + @subsections.flat_map(&:all_changes)
    end

    def change_count
      super + @subsections.sum(&:change_count)
    end

    def change_score
      super + @subsections.sum(&:change_score)
    end

    def buffs
      super + @subsections.flat_map(&:buffs)
    end

    def nerfs
      super + @subsections.flat_map(&:nerfs)
    end

    def merge(other_entity)
      Entity.new(@type, @id).tap do |merged_entity|
        (@changes + other_entity.changes).each { |change| merged_entity << change }
        (@entities + other_entity.entities).group_by(&:id).values
                                           .map { |matches| matches.reduce(&:merge) }
                                           .each { |entity| merged_entity << entity }
        (@subsections + other_entity.subsections).group_by(&:name).values
                                                 .map { |matches| matches.reduce(&:merge) }
                                                 .each { |subsec| merged_entity << subsec }
      end
    end

    def to_s
      all_children = @subsections + @entities + @changes
      "#{@type.to_s.capitalize} ID: #{@id} (#{change_count} changes)\n  #{all_children.map(&:to_s).join("\n  ")}"
    end

    def pretty_print(item_map, ability_map, hero_map)
      entity_name = name(item_map, ability_map, hero_map)

      head_str = "#{entity_name} #{change_arrow_str}"
      subsecs_str = @subsections.map { |s| s.pretty_print(item_map, ability_map, hero_map).gsub("\n", "\n  ") }.join("\n  ")
      changes_str = @changes.join("\n  ")
      entities_str = @entities.map { |e| e.pretty_print(item_map, ability_map, hero_map).gsub("\n", "\n  ") }.join("\n  ")

      [head_str, subsecs_str, changes_str, entities_str].reject(&:empty?).join("\n  ")
    end

    def name(item_map, ability_map, hero_map)
      case @type
          when :item, :neutral
            item_map[@id]
          when :ability
            ability_map[@id]
          when :hero
            hero_map[@id]
          end
    end

    def to_hash
      super.merge({
        id: @id,
        subsections: @subsections.map(&:to_hash)
      })
    end

    def self.from_hash(entity_hash)
      Entity.new(entity_hash['type'].to_sym, entity_hash['id']).tap do |entity|
        entity_hash['changes'].each { |change| entity << Change.from_hash(change) }
        entity_hash['entities'].each { |child| entity << Entity.from_hash(child) }
        entity_hash['subsections'].each { |subsec| entity << Subsection.from_hash(subsec) }
      end
    end

    protected

    attr_reader :subsections
  end
end
