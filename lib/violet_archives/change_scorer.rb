module VioletArchives
  # Processes Changes to score them as buffs, nerfs, or neutral/indeterminate
  class ChangeScorer
    def self.score_changes(changes)
      terms = TERMS_MAP.keys.sort_by(&:length).reverse
      directions = DIRECTIONS_MAP.keys.sort_by(&:length).reverse

      changes.each do |change|
        change.term = change.find_term(terms)
        change.direction = change.find_direction(directions)
        change.score = change.calc_score(TERMS_MAP, DIRECTIONS_MAP)
      end
    end

    TERMS_MAP = {
      'intelligence' => :positive,
      'agility' => :positive,
      'strength' => :positive,
      'attributes' => :positive,
      'movement speed' => :positive,
      'duration' => :positive,
      'damage' => :positive,
      'cast range' => :positive,
      'attack speed' => :positive,
      'dps' => :positive,
      'radius' => :positive,
      'armor' => :positive,
      'mana cost' => :negative,
      'health' => :positive,
      'cooldown' => :negative,
      'armor loss' => :positive,
      'base attack time' => :negative,
      'health cost' => :negative,
      'cooldown reduction' => :positive,
      'distance' => :positive,
      'range' => :positive,
      'health regen' => :positive,
      'stun duration' => :positive,
      'attacks' => :positive,
      'proc chance' => :positive,
      'attack range' => :positive,
      'turn rate' => :positive,
      'heal' => :positive,
      'multiplier' => :positive,
      'animation speed' => :positive,
      'attack speed slow' => :positive,
      'heal amplification' => :positive,
      'bonus' => :positive,
      'damage reduction' => :positive,
      'slow resistance' => :positive,
      'vision range' => :positive,
      'mana regen' => :positive,
      'cast point' => :negative,
      'mana restore' => :positive,
      'health threshold' => :negative,
      'recipe' => :negative,
      'cost' => :negative,
      'manacost' => :negative,
      'max souls' => :positive,
      'slow' => :positive,
      'backswing' => :negative,
      'evasion' => :positive,
      'mana steal' => :positive,
      'mana burn' => :positive,
      'mana' => :positive,
      'root' => :positive,
      'stun' => :positive,
      'damage per second' => :positive,
      'hp regen' => :positive,
      'magic resistance' => :positive,
      'resistance' => :positive,
      'spell immunity' => :positive,
      'immunity' => :positive,
      'damage block' => :positive,
      'armor reduction' => :positive,
      'aoe' => :positive,
      'gold' => :positive,
      'bounty' => :negative,
      'attack slow' => :positive,
      'attack count' => :positive,
      'maledict instance' => :positive,
      'stat loss' => :positive,
      'charge restore time' => :negative,
      'attack speed reduction' => :positive,
      'damage shield' => :positive,
      'max stack' => :positive,
      'spell lifesteal' => :positive,
      'lifesteal' => :positive,
      'flying vision' => :positive,
      'movement speed slow' => :positive,
      'damage interval' => :negative,
      'chance of deadly focus' => :positive,
      'vanish radius' => :negative,
      'reduction per unit' => :negative,
      'reduction per bounce' => :negative,
      'projectile speed' => :positive,
      'aoe increase' => :positive,
      'bounces' => :positive
    }.freeze

    DIRECTIONS_MAP = {
      'increased' => :positive,
      'decreased' => :negative,
      'increases' => :positive,
      'decreases' => :negative,
      'improved' => :buff,
      'rescaled' => :neutral,
      'replaced' => :neutral,
      'reduced' => :negative,
      'changed' => :neutral,
      'removed' => :negative,
      'now' => :positive,
      'no longer' => :negative
    }.freeze
  end
end
