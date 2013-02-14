module Ollie
  class Base
    attr_accessor :errors

    def initialize
      @errors = []
    end

    def self.metrics
      @metrics ||= []
    end

    def self.metric(*metrics)
      @metrics = self.metrics + metrics
    end

    def metrics
      self.class.metrics
    end

    def to_hash
      metrics_to_hash.merge(errors_to_hash)
    end

    # The name of the metrics group that is being performed, this default implementation uses the name of the class
    #  but if you would like to have a better name, override it in the metric that's being implemented and return
    #  a String.  For example:
    #
    #  class CheckEverythingAboutEcomm < Ollie::Base
    #    def metric_group_name
    #      "ecomm_sanity_check"
    #    end
    #  end
    def metric_group_name
      self.class.to_s.split('::').last.downcase
    end

    private

    def metrics_to_hash
      @results_hash ||= metrics.each_with_object({}) do |metric, hash|
        hash[metric] = perform(metric)
      end
    end

    def errors_to_hash
      {
        errors: errors
      }
    end

    def perform(metric)
      begin
        send(metric)
      rescue Exception => e
        errors << e.to_s
        nil
      end
    end


  end
end

# Thanks, Ollie
