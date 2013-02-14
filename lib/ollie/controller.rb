module Ollie
  module Controller

    module ClassMethods
      def reports
        @reports ||= []
      end

      def report_on(*reports)
        @reports = self.reports + reports
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end


    def server_status
      render json: ollie_checker
    end

    def ollie_checker
      @checker ||=  Ollie::Checker.new(self.class.reports)
    end

  end
end

# Thanks, Ollie
