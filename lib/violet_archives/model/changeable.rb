module VioletArchives
  # Anything that includes Changes and/or Entities
  class Changeable
    attr_reader :type

    def initialize(type)
      @type = type
      @changes = []
      @entities = []
    end

    def add_change(change)
      @changes << change
    end

    def add_entity(entity)
      @entities << entity
    end

    def add(child)
      if child.is_a?(Entity)
        add_entity(child)
      elsif child.is_a?(Change)
        add_change(child)
      end
    end
    alias << add

    def all_changes
      @changes + @entities.flat_map(&:all_changes)
    end

    def change_count
      @changes.count + @entities.sum(&:change_count)
    end

    def change_score
      @changes.sum(&:score) + @entities.sum(&:change_score)
    end

    def buffs
      @changes.select(&:buff?) + @entities.flat_map(&:buffs)
    end

    def nerfs
      @changes.select(&:nerf?) + @entities.flat_map(&:nerfs)
    end

    def buffed?
      change_score.positive?
    end

    def nerfed?
      change_score.negative?
    end

    def change_arrow_str
      (buffed? ? '↑' : '↓') * change_score.abs
    end

    def to_hash
      {
        type: @type,
        changes: @changes.map(&:to_hash),
        entities: @entities.map(&:to_hash)
      }
    end

    protected

    attr_reader :changes, :entities
  end
end
