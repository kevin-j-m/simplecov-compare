# frozen_string_literal: true

require_relative "file_line"

module Simplecov
  module Compare
    class FileResult
      # https://github.com/simplecov-ruby/simplecov/blob/main/lib/simplecov/source_file.rb
      attr_reader :filename

      def initialize(filename, coverage_data:)
        @filename = filename
        @coverage_data = coverage_data
      end

      def lines
        return @lines if defined?(@lines)
        return @lines = [] unless @coverage_data
        lines_coverage = @coverage_data["lines"]

        if lines_coverage
          @lines = lines_coverage.map.with_index do |coverage, index|
            FileLine.new(line_number: index + 1, covered_count: coverage)
          end
        else
          @lines = []
        end
      end

      def relevant_lines
        lines.select { _1.relevant? }
      end

      def covered_lines
        lines.select { _1.covered? }
      end

      def lines_covered_percent
        return 100 if relevant_lines.size.zero?

        ((covered_lines.size / relevant_lines.size.to_f) * 100).round(2)
      end
    end
  end
end
