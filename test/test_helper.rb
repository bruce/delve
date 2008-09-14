require 'test/unit'
require 'shoulda'

require File.dirname(__FILE__) << "/../lib/delve"

class Test::Unit::TestCase  
  
  attr_reader :node, :result
  
  def self.should_find(number)
    should "find #{number} result(s)" do
      assert result
      assert result.is_a?(Enumerable)
      assert result.all? { |r| r.kind_of?(Delve::AddressableNode) }
      assert_equal number, result.size
    end
  end
  
  private
  
  def parse(example)
    text = File.read(File.dirname(__FILE__) << "/fixtures/#{example}.rb")
    @node = Delve.parse(text)
  end
    
  def at(query)
    @result = node[query]
  end
  
end