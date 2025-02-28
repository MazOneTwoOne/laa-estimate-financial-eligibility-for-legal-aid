class FeatureFlags
  ENABLED_AFTER_DATE = {
    example_2125_flag: "2125-01-01",
  }.freeze

  FLIPPER_FLAGS = %i[sentry controlled asylum_and_immigration].freeze

  class << self
    def enabled?(flag)
      if ENABLED_AFTER_DATE.key?(flag)
        Time.current.beginning_of_day >= ENABLED_AFTER_DATE[flag]
      elsif FLIPPER_FLAGS.include?(flag)
        Flipper.enabled?(flag)
      else
        raise "Unrecognised flag '#{flag}'"
      end
    end
  end
end
