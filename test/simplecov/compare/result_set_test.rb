# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe ResultSet do
      describe "#files" do
        it "parses the JSON file and provides information on all the files in the file" do
          set = ResultSet.new(file_path: "test/fixtures/sample_resultset.json")

          coverage_result = [
            ["/path/to/app/helpers/application_helper.rb", 100.0],
            ["/path/to/app/models/model_name.rb", 81.82],
            ["/path/to/app/models/other_model.rb", 50.0],
          ]
          assert_equal coverage_result, set.files.map { [_1.filename, _1.lines_covered_percent] }
        end

        it "coverts the provided coverage data hash into file results" do
          set = ResultSet.new(
            coverage_data: {
              "/path/to/app/helpers/application_helper.rb" => {
                "lines" => [
                  1,
                  nil,
                ]
              },
              "/path/to/app/models/model_name.rb" => {
                "lines" => [
                  1,
                  1,
                  nil,
                  1,
                  1,
                  nil,
                  1,
                  6,
                  nil,
                  nil,
                  nil,
                  1,
                  nil,
                  7,
                  12,
                  0,
                  nil,
                  0,
                  nil,
                  nil,
                  nil,
                  nil,
                ],
              },
              "/path/to/app/models/other_model.rb" => {
                "lines" => [
                  7,
                  5,
                  5,
                  4,
                  4,
                  4,
                  nil,
                  0,
                  0,
                  0,
                  nil,
                  0,
                  0,
                  0,
                  nil
                ],
                "branches": {}
              }
            },
          )

          coverage_result = [
            ["/path/to/app/helpers/application_helper.rb", 100.0],
            ["/path/to/app/models/model_name.rb", 81.82],
            ["/path/to/app/models/other_model.rb", 50.0],
          ]
          assert_equal coverage_result, set.files.map { [_1.filename, _1.lines_covered_percent] }
        end
      end

      describe "#num_relevant_lines" do
        it "counts the relevant lines across files" do
          set = ResultSet.new(
            coverage_data: {
              "file1.rb" => {
                "lines" => [
                  1,
                  nil,
                ]
              },
              "file2.rb" => {
                "lines" => [
                  1,
                  0,
                  0,
                  nil,
                ],
              },
            },
          )

          assert_equal 4, set.num_relevant_lines
        end
      end

      describe "#num_covered_lines" do
        it "counts the covered lines across files" do
          set = ResultSet.new(
            coverage_data: {
              "file1.rb" => {
                "lines" => [
                  1,
                  nil,
                ]
              },
              "file2.rb" => {
                "lines" => [
                  1,
                  0,
                  0,
                  nil,
                ],
              },
            },
          )

          assert_equal 2, set.num_covered_lines
        end
      end

      describe "#lines_covered_percent" do
        it "calculates the lines coverage for the full set" do
          set = ResultSet.new(
            coverage_data: {
              "file1.rb" => {
                "lines" => [
                  1,
                  nil,
                ]
              },
              "file2.rb" => {
                "lines" => [
                  1,
                  0,
                  0,
                  nil,
                ],
              },
            },
          )

          assert_equal 50.0, set.lines_covered_percent
        end
      end
    end
  end
end
