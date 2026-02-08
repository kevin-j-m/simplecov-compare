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
    def self.report(base_path:, to_path:, formatter_class: Formatter::MarkdownFormatter, reporter_class: Reporter::GlamourReporter)
      base = ResultSet.new(ResultFile.new(base_path).coverage_data)
      other = ResultSet.new(ResultFile.new(to_path).coverage_data)
      comparison = ResultSetComparison.new(base, to: other)

      formatted = formatter_class.new.format(comparison)
      reporter_class.new.report(formatted)
    end
  end
end
