module VioletArchives
  # A single change to an Entity
  class Change
    BUFF = 1
    NERF = -1
    NEUTRAL = 0

    attr_accessor :score
    attr_writer :term, :direction

    def initialize(text)
      @text = text
    end

    def find_term(terms)
      terms.detect { |term| @text.downcase.include?(term) }
    end

    def find_direction(directions)
      directions.detect { |direction| @text.downcase.include?(direction) }
    end

    def calc_score(term_map, direction_map)
      return BUFF if direction_map[@direction] == :buff
      return NERF if direction_map[@direction] == :nerf
      return NEUTRAL if direction_map[@direction] == :neutral
      return NEUTRAL if term_map[@term].nil? || direction_map[@direction].nil?

      term_map[@term] == direction_map[@direction] ? BUFF : NERF
    end

    def buff?
      @score == BUFF
    end

    def nerf?
      @score == NERF
    end

    def to_s
      score_text = case @score
              when NEUTRAL
                '(—) '
              when BUFF
                '(+1) '
              when NERF
                '(-1) '
              else
                ''
              end

      score_text + @text
    end

    def to_hash
      {
        text: @text, term: @term,
        direction: @direction, score: @score
      }
    end

    def self.from_hash(change_hash)
      Change.new(change_hash['text']).tap do |change|
        change.term = change_hash['term']
        change.direction = change_hash['direction']&.to_sym
        change.score = change_hash['score']
      end
    end
  end
end
