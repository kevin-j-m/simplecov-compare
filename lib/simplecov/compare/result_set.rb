# frozen_string_literal: true

require "json"

module Simplecov
  module Compare
    class ResultSet
      # https://github.com/simplecov-ruby/simplecov/blob/main/lib/simplecov/file_list.rb

      def initialize(file_path: nil, coverage_data: nil)
        @file_path = file_path

        if coverage_data
          @coverage_data = coverage_data
        end
      end

      def files
        return @files if defined?(@files)

        @files =
          coverage_data
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

      private

      def coverage_data
        return @coverage_data if defined?(@coverage_data)

        @coverage_data =
          parse_file
          .map { |command_name, data| [[command_name], data.fetch("coverage")] }
          .first
          .last
      end

      def parse_file
        data = read_file
        parse_json(data)
      end

      def read_file
        return unless File.exist?(@file_path)

        data = File.read(@file_path)
        return if data.nil? || data.length < 2

        data
      end

      def parse_json(content)
        return {} unless content

        JSON.parse(content) || {}
      rescue StandardError
        {}
      end
    end
  end
end
