require_relative 'changeable'

module VioletArchives
  # A separate collection of Changes within an Entity
  class Subsection < Changeable
    attr_reader :name

    def initialize(type, name)
      super(type)

      @name = name
    end

    def merge(other_entity)
      Subsection.new(@type, @name).tap do |merged_subsec|
        (@changes + other_entity.changes).each { |change| merged_subsec << change }
        (@entities + other_entity.entities).group_by(&:id).values
                                           .map { |matches| matches.reduce(&:merge) }
                                           .each { |entity| merged_subsec << entity }
      end
    end

    def to_s
      all_children = @entities + @changes
      "#{@type.to_s.capitalize} #{@name} (#{change_count} changes)\n  #{all_children.map(&:to_s).join("\n  ")}"
    end

    def pretty_print(item_map, ability_map, hero_map)
      head_str = "#{@name} #{change_arrow_str}"
      changes_str = @changes.join("\n  ")
      entities_str = @entities.map { |e| e.pretty_print(item_map, ability_map, hero_map).gsub("\n", "\n  ") }.join("\n  ")

      [head_str, changes_str, entities_str].reject(&:empty?).join("\n  ")
    end

    def to_hash
      super.merge({
        name: @name
      })
    end

    def self.from_hash(subsec_hash)
      Subsection.new(subsec_hash['type'].to_sym, subsec_hash['name']).tap do |subsec|
        subsec_hash['changes'].each { |change| subsec << Change.from_hash(change) }
        subsec_hash['entities'].each { |child| subsec << Entity.from_hash(child) }
      end
    end
  end
end
