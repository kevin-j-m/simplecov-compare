# frozen_string_literal: true

require_relative "compare/version"
require_relative "compare/file_comparison"
require_relative "compare/file_line"
require_relative "compare/file_result"
require_relative "compare/reporter/simple_reporter"
require_relative "compare/result_set"
require_relative "compare/result_set_comparison"

module Simplecov
  module Compare
    # TODO: tests
    def self.differences(base_path:, to_path:)
      base = ResultSet.new(base_path)
      other = ResultSet.new(to_path)
      comparison = ResultSetComparison.new(base, to: other)
      comparison.differences
    end

    # TODO: tests
    def self.report(base_path:, to_path:, reporter_class: SimpleReporter)
      differences = differences(base_path:, to_path:)
      reporter_class.new.report(differences)
    end
  end
end
