require 'minitest/autorun'

# This recusrsive regexps matches sequences of nested pairs of [], {}, or ().
RE = %r_
  ^(
  \(\g<1>\)\g<1>+| # parens
  \[\g<1>\]\g<1>+| # brackets
  {\g<1>}\g<1>+|   # braces
                   # nothing
  )$
_x

def balanced?(expr)
  !!(RE =~ expr)
end

class BalanceTest < Minitest::Test
  CASES = {
    ""                         => true,   # empty
    "()"                       => true,   # basic
    "()[]"                     => true,   # sequence
    "([])"                     => true,   # nesting
    "[{[]()}]{[()[]]}([{}])()" => true,   # complex
    "()("                      => false,  # missing closing
    "([)"                      => false,  # missing closing
    "{()"                      => false,  # missing closing
    ")[]"                      => false,  # missing opening
    "[]]"                      => false,  # missing opening
    "(){"                      => false,  # missing opening
  }

  def test_cases
    CASES.each do |expr, expected_result|
      assert(expected_result == balanced?(expr), <<~MSG)
        balanced?('#{expr}') was not '#{expected_result.inspect}'
      MSG
    end
  end
end
