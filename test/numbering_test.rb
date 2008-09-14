require File.dirname(__FILE__) << "/test_helper"

class NumberingTest < Test::Unit::TestCase
  
  def self.should_be_at_line(number)
    should_find 1
    should "be at the correct line number (#{number})" do
      assert_equal number, result.first.line
    end
  end
      
  context "Numbering" do
    setup { parse :structure }
    context "for instance methods" do
      setup { at 'Foo::Bar#bar' }
      should_be_at_line 15
    end
    context "for class methods" do
      setup { at 'Foo::Bar.quux' }
      should_be_at_line 5
    end
    context "for class methods inside a metaclass" do
      setup { at 'Foo::Bar.foo' }
      should_be_at_line 10
    end
    context "for classes" do
      setup { at 'Baz' }
      should_be_at_line 22
    end
    context "for modules" do
      setup { at 'Foo::Bar::Spam::Eggs' }
      should_be_at_line 28
    end
    
  end
  
end