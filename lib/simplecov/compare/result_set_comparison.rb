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

      def lines_covered_percent_delta_points
        return new_lines_covered_percent if @base.nil?
        return -original_lines_covered_percent if @other.nil?

        new_lines_covered_percent - original_lines_covered_percent
      end

      def differences
        return @differences if defined?(@differences)

        compare
        @differences
      end

      private

      def compare
        @differences = []
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
            @differences << file_comparison
          end
        end
      end

      def add_new_files_from_other
        other_file_set.each do |other_file|
          file_comparison = FileComparison.new(nil, to: other_file)
          @differences << file_comparison
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
