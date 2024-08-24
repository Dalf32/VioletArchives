module VioletArchives
  # A bonus for an ability from a talent
  class BonusValue
    def initialize(bonus_data)
      @bonus_data = bonus_data
    end

    def name
      @bonus_data['name']
    end

    def empty?
      name.empty?
    end

    def has_single_value?
      !value.nil?
    end

    def value
      @bonus_data['value']
    end

    def values
      @bonus_data['values']
    end

    def values_str
      values.map(&:to_s).join('/')
    end
  end
end
