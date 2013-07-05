module Ollie
  class Checker
    attr_accessor :checks

    def initialize(*checks)
      @checks = checks.flatten
    end

    def status
      check_instances.each_with_object({}) do |check, hash|
        hash[check.metric_group_name] = check.to_hash
      end || {}
    end

    def to_json(*option)
      status.to_json
    end

    private

    def check_instances
      checks.collect { |check| class_for_string(check).new }
    end

    def class_for_string(klass_string)
      class_name = klass_string.to_s.camelize
      Ollie.const_get(class_name, false)
    end
  end
end

# Thanks, Ollie
