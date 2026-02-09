# frozen_string_literal: true

require "test_helper"

describe Simplecov::Compare do
  describe ".report" do
    it "outputs the difference in the two files" do
      expected_output = <<~EXPECTED_OUTPUT
        # Coverage Comparison

        ## Overall Impact: 📈

        Coverage increased 66.67 points from 0.0% to 66.67%.

        ## File Differences

        | File Name | Delta | From | To |
        | --------- | ----- | ---- | -- |
        | /path/to/app/models/other_model.rb | 50.0 | 0% (0/0) | 50.0% (6/12) |
        | /path/to/app/models/model_name.rb | 81.82 | 0% (0/0) | 81.82% (9/11) |
        | /path/to/app/helpers/application_helper.rb | 100.0 | 0.0% (0/1) | 100.0% (1/1) |


      EXPECTED_OUTPUT

      assert_output(expected_output) do
        Simplecov::Compare.report(
          base_path: "test/fixtures/empty_resultset.json",
          to_path: "test/fixtures/sample_resultset.json",
          formatter_class: Simplecov::Compare::Formatter::MarkdownFormatter,
          reporter_class: Simplecov::Compare::Reporter::SimpleReporter,
        )
      end
    end

    it "raises an exception when no base path is provided" do
      assert_raises(Simplecov::Compare::NoPathError, "Base path not provided") do
        Simplecov::Compare.report(
          base_path: nil,
          to_path: "test/fixtures/sample_resultset.json",
          formatter_class: Simplecov::Compare::Formatter::MarkdownFormatter,
          reporter_class: Simplecov::Compare::Reporter::SimpleReporter,
        )
      end

    end

    it "raises an exception when no to path is provided" do
      assert_raises(Simplecov::Compare::NoPathError, "To path not provided") do
        Simplecov::Compare.report(
          base_path: "test/fixtures/sample_resultset.json",
          to_path: nil,
          formatter_class: Simplecov::Compare::Formatter::MarkdownFormatter,
          reporter_class: Simplecov::Compare::Reporter::SimpleReporter,
        )
      end
    end
  end

  it "has a version number" do
    assert !Simplecov::Compare::VERSION.nil?
  end
end
