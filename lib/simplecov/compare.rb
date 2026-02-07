# frozen_string_literal: true

require_relative "compare/version"
require_relative "compare/file_comparison"
require_relative "compare/file_line"
require_relative "compare/file_result"
require_relative "compare/result_set"

module Simplecov
  module Compare
    class Error < StandardError; end
    # Your code goes here...
  end
end
