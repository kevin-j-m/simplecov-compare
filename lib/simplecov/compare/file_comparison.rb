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

        @other.lines_covered_percent - @base.lines_covered_percent
      end
    end
  end
end
