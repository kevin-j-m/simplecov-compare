# frozen_string_literal: true

module Simplecov
  module Compare
    class FileLine
      # https://github.com/simplecov-ruby/simplecov/blob/main/lib/simplecov/source_file/line.rb
      attr_reader :line_number

      def initialize(line_number:, covered_count:)
        @line_number = line_number
        @covered_count = covered_count
      end

      def covered?
        relevant? && @covered_count.positive?
      end

      def missed?
        relevant? && @covered_count.zero?
      end

      def relevant?
        !irrelevant?
      end

      def irrelevant?
        @covered_count.nil?
      end
    end
  end
end
