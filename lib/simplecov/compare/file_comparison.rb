# frozen_string_literal: true

module Simplecov
  module Compare
    class FileComparison
      def initialize(base, to:)
        @base = base
        @other = to
      end

      def same_file?
        return false if @base.nil?

        @base.same_file?(@other)
      end

      def filename
        @base&.filename || @other&.filename
      end

      def lines_coverage_different?
        !lines_coverage_equal?
      end

      def lines_coverage_equal?
        lines_coverage_delta_points.zero?
      end

      def lines_coverage_increased?
        lines_coverage_delta_points.positive?
      end

      def lines_coverage_decreased?
        lines_coverage_delta_points.negative?
      end

      def lines_coverage_delta_points
        return @other.lines_covered_percent if @base.nil?
        return (-@base.lines_covered_percent) if @other.nil?

        (@other.lines_covered_percent - @base.lines_covered_percent).round(2)
      end

      def original_lines_covered_percent
        @base.lines_covered_percent
      end

      def original_num_relevant_lines
        @base.num_relevant_lines
      end

      def original_num_covered_lines
        @base.num_covered_lines
      end

      def new_lines_covered_percent
        @other.lines_covered_percent
      end

      def new_num_relevant_lines
        @other.num_relevant_lines
      end

      def new_num_covered_lines
        @other.num_covered_lines
      end
    end
  end
end
