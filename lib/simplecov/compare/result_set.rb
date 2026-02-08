# frozen_string_literal: true

module Simplecov
  module Compare
    class ResultSet
      # https://github.com/simplecov-ruby/simplecov/blob/main/lib/simplecov/file_list.rb

      def initialize(coverage_data)
        @coverage_data = coverage_data
      end

      def files
        return @files if defined?(@files)

        @files =
          @coverage_data
          .map { |filename, coverage| FileResult.new(filename, coverage_data: JSON.parse(JSON.dump(coverage))) }
          .compact
          .sort_by { _1.filename }
      end

      def num_relevant_lines
        files.sum { _1.relevant_lines.size }
      end

      def num_covered_lines
        files.sum { _1.covered_lines.size }
      end

      def lines_covered_percent
        return 100 if num_relevant_lines.zero?

        ((num_covered_lines / num_relevant_lines.to_f) * 100).round(2)
      end
    end
  end
end
