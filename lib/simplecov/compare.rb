# frozen_string_literal: true

require_relative "compare/version"
require_relative "compare/file_comparison"
require_relative "compare/file_line"
require_relative "compare/file_result"
require_relative "compare/formatter/markdown_formatter"
require_relative "compare/reporter/glamour_reporter"
require_relative "compare/reporter/simple_reporter"
require_relative "compare/result_file"
require_relative "compare/result_set"
require_relative "compare/result_set_comparison"

module Simplecov
  module Compare
    class NoPathError < StandardError
      def initialize(msg="Required path not provided")
        super
      end
    end

    def self.report(base_path:, to_path:, formatter_class: Formatter::MarkdownFormatter, reporter_class: Reporter::GlamourReporter)
      raise NoPathError, "Base path not provided" if base_path.nil?
      raise NoPathError, "To path not provided" if to_path.nil?

      base = ResultSet.new(ResultFile.new(base_path).coverage_data)
      other = ResultSet.new(ResultFile.new(to_path).coverage_data)
      comparison = ResultSetComparison.new(base, to: other)

      formatted = formatter_class.new.format(comparison)
      reporter_class.new.report(formatted)
    end
  end
end
