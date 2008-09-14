require File.dirname(__FILE__) << "/test_helper"

class QueryingTest < Test::Unit::TestCase
      
  context "Querying" do
    setup { parse :structure }
    context "on a node" do
      context "for instance method" do
        setup { at 'Foo::Bar#bar' }
        should_find 1
      end
      context "for class method" do
        setup { at 'Foo::Bar.quux' }
        should_find 1
        context "results" do
          should "be found by full name" do
            assert_equal 'Foo::Bar.quux', result.first.full_name
          end
        end
        context "using normalization" do
          setup do
            @result1 = node['Foo::Bar.quux']
            @result2 = node['Foo::Bar::quux']
          end
          should "handle different invocation styles" do
            assert_equal @result1, @result2
          end
        end
      end
      context "for class method inside metaclass" do
        setup { at 'Foo::Bar.foo' }
        should_find 1
      end
    end
  end
    
end


