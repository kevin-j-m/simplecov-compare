# frozen_string_literal: true

require "json"

module Simplecov
  module Compare
    class ResultFile
      def initialize(file_path)
        @file_path = file_path
      end

      def coverage_data
        return @coverage_data if defined?(@coverage_data)

        @coverage_data =
          parse_file
          .map { |command_name, data| [[command_name], data.fetch("coverage")] }
          .first
          .last
      end

      private

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
