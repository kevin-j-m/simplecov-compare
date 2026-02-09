# frozen_string_literal: true

module Simplecov
  module Compare
    module Formatter
      class MarkdownFormatter
        def format(result_set_comparison)
          <<~MARKDOWN
            #{heading}

            #{overall_impact(result_set_comparison)}
            #{file_differences(result_set_comparison)}
          MARKDOWN
        end

        private

        def heading
          "# Coverage Comparison"
        end

        def overall_impact(result_set_comparison)
          if result_set_comparison.lines_coverage_increased?
            overall_coverage_increased(result_set_comparison)
          elsif result_set_comparison.lines_coverage_decreased?
            overall_coverage_decreased(result_set_comparison)
          else
            overall_coverage_equal(result_set_comparison)
          end
        end

        def overall_coverage_increased(result_set_comparison)
          <<~OVERALL_IMPACT
            ## Overall Impact: 📈

            Coverage increased #{result_set_comparison.lines_coverage_delta_points} points from #{result_set_comparison.original_lines_covered_percent}% to #{result_set_comparison.new_lines_covered_percent}%.
          OVERALL_IMPACT
        end

        def overall_coverage_decreased(result_set_comparison)
          <<~OVERALL_IMPACT
            ## Overall Impact: 📉

            Coverage decreased #{result_set_comparison.lines_coverage_delta_points * -1} points from #{result_set_comparison.original_lines_covered_percent}% to #{result_set_comparison.new_lines_covered_percent}%.
          OVERALL_IMPACT
        end

        def overall_coverage_equal(result_set_comparison)
          <<~OVERALL_IMPACT
            ## Overall Impact: 🟰

            Coverage maintained at #{result_set_comparison.original_lines_covered_percent}%.
          OVERALL_IMPACT
        end

        def file_differences(result_set_comparison)
          if result_set_comparison.file_differences?
            <<~FILE_DIFF
              ## File Differences

              | File Name | Delta | From | To |
              | --------- | ----- | ---- | -- |
              #{file_differences_table_contents(result_set_comparison)}
            FILE_DIFF
          else
            <<~NO_FILE_DIFF
              ## File Differences

              All files maintained the same level of coverage.
            NO_FILE_DIFF
          end
        end

        def file_differences_table_contents(result_set_comparison)
          result_set_comparison
            .file_differences
            .sort_by { _1.lines_coverage_delta_points }
            .each_with_object(+"") do |file_difference, output|
              output << "| #{file_difference.filename} "\
                "| #{file_difference.lines_coverage_delta_points} "\
                "| #{file_difference.original_lines_covered_percent}% (#{file_difference.original_num_covered_lines}/#{file_difference.original_num_relevant_lines}) "\
                "| #{file_difference.new_lines_covered_percent}% (#{file_difference.new_num_covered_lines}/#{file_difference.new_num_relevant_lines}) |\n"
            end
        end
      end
    end
  end
end
