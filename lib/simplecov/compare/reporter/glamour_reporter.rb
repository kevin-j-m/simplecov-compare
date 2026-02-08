# frozen_string_literal: true

require "glamour"

module Simplecov
  module Compare
    module Reporter
      class GlamourReporter
        def report(output)
          puts Glamour.render(output)
        end
      end
    end
  end
end
