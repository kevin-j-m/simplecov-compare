# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe ResultFile do
      describe "#coverage_data" do
        it "extracts the coverage data out of the provided file as a hash" do
          file = ResultFile.new("test/fixtures/sample_resultset.json")

          hash_from_file = {
            "/path/to/app/helpers/application_helper.rb" => {
              "lines" => [1, nil],
            },
            "/path/to/app/models/model_name.rb" => {
              "lines" => [1, 1, nil, 1, 1, nil, 1, 6, nil, nil, nil, 1, nil, 7, 12, 0, nil, 0, nil, nil, nil, nil],
            },
            "/path/to/app/models/other_model.rb" => {
              "lines" => [7, 5, 5, 4, 4, 4, nil, 0, 0, 0, nil, 0, 0, 0, nil],
              "branches" => {}},
          }

          assert_equal(hash_from_file, file.coverage_data)
        end
      end
    end
  end
end
