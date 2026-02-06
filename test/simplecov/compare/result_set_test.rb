# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe ResultSet do
      describe "#files" do
        it "parses the JSON file and provides information on all the files in the file" do
          set = ResultSet.new("test/fixtures/sample_resultset.json")

          coverage_result = [
            ["/path/to/app/helpers/application_helper.rb", 100.0],
            ["/path/to/app/models/model_name.rb", 81.82],
            ["/path/to/app/models/other_model.rb", 50.0],
          ]
          assert_equal coverage_result, set.files.map { [_1.filename, _1.lines_covered_percent] }
        end
      end
    end
  end
end
