# frozen_string_literal: true

module Simplecov
  module Compare
    class ResultSetComparison
      def initialize(base, to:)
        @base = base
        @other = to
      end

      def original_lines_covered_percent
        @base.lines_covered_percent
      end

      def new_lines_covered_percent
        @other.lines_covered_percent
      end

      def lines_coverage_increased?
        lines_coverage_delta_points.positive?
      end

      def lines_coverage_decreased?
        lines_coverage_delta_points.negative?
      end

      def lines_coverage_delta_points
        return new_lines_covered_percent if @base.nil?
        return -original_lines_covered_percent if @other.nil?

        (new_lines_covered_percent - original_lines_covered_percent).round(2)
      end

      def file_differences
        return @file_differences if defined?(@file_differences)

        compare
        @file_differences
      end

      def file_differences?
        !file_differences.empty?
      end

      def num_file_differences
        file_differences.size
      end

      private

      def compare
        @file_differences = []
        add_differences_from_base
        add_new_files_from_other
      end

      def add_differences_from_base
        base_file_set.each do |base_file|
          match = other_file_set.find { base_file.same_file?(_1) }
          if match
            other_file_set.delete(match)
          end

          file_comparison = FileComparison.new(base_file, to: match)
          if file_comparison.lines_coverage_different?
            @file_differences << file_comparison
          end
        end
      end

      def add_new_files_from_other
        other_file_set.each do |other_file|
          file_comparison = FileComparison.new(nil, to: other_file)
          @file_differences << file_comparison
        end
      end

      def base_file_set
        @base_file_set ||= @base.files.dup
      end

      def other_file_set
        @other_file_set ||= @other.files.dup
      end
    end
  end
end
