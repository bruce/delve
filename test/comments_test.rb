require File.dirname(__FILE__) << "/test_helper"

class CommentTest < Test::Unit::TestCase
    
  def self.should_find_comments(lines = 1)
    should "be found" do
      assert_equal 1, result.size
      assert result.first.comment
      assert_kind_of String, result.first.comment
      assert_equal lines, result.first.comment.split("\n").size
    end
  end
  
  def self.should_not_find
    should "not be found" do
      assert_equal 1, result.size
      assert !result.first.comment
    end
  end
      
  context "Comments" do
    setup do
      parse :comments
    end
    context "single-line comments" do
      context "on classes" do
        context "with single-component constant" do
          setup { at 'SingleLine::SingleComponentClass' }
          should_find_comments
        end
        context "with multiple-component constant" do
          setup { at 'SingleLine::Multiple::ComponentClass' }
          should_find_comments
        end
      end
      context "on modules" do
        context "with single-component constant" do
          setup { at 'SingleLine::SingleComponentModule' }
          should_find_comments
        end
        context "with multiple-component constant" do
          setup { at 'SingleLine::Multiple::ComponentModule' }
          should_find_comments
        end
      end
      context "on instance methods" do
        setup { at 'SingleLine::Methods#instance_method' }
        should_find_comments
      end
      context "on normal class methods" do
        setup { at 'SingleLine::Methods.class_method' }
        should_find_comments
      end
      context "on class methods inside metaclass scope" do
        setup { at 'SingleLine::Methods.method_inside_metaclass' }
        should_find_comments
      end
    end
    context "multiple-line comments" do
      context "on classes" do
        context "with multiple-component constant" do
          setup { at 'MultipleLines::SingleComponentClass' }
          should_find_comments 2
        end
        context "with multiple-component constant" do
          setup { at 'MultipleLines::Multiple::ComponentClass' }
          should_find_comments 2
        end
      end
      context "on modules" do
        context "with single-component constant" do
          setup { at 'MultipleLines::SingleComponentModule' }
          should_find_comments 2
        end
        context "with multiple-component constant" do
          setup { at 'MultipleLines::Multiple::ComponentModule' }
          should_find_comments 2
        end
      end
      context "on instance methods" do
        setup { at 'MultipleLines::Methods#instance_method' }
        should_find_comments 2
      end
      context "on normal class methods" do
        setup { at 'MultipleLines::Methods.class_method' }
        should_find_comments 2
      end
      context "on class methods inside metaclass scope" do
        setup { at 'MultipleLines::Methods.method_inside_metaclass' }
        should_find_comments 2
      end
    end
    context "undocked comments" do
      context "on classes" do
        context "with multiple-component constant" do
          setup { at 'Undocked::SingleComponentClass' }
          should_not_find
        end
        context "with multiple-component constant" do
          setup { at 'Undocked::Multiple::ComponentClass' }
          should_not_find
        end
      end
      context "on modules" do
        context "with single-component constant" do
          setup { at 'Undocked::SingleComponentModule' }
          should_not_find
        end
        context "with multiple-component constant" do
          setup { at 'Undocked::Multiple::ComponentModule' }
          should_not_find
        end
      end
      context "on instance methods" do
        setup { at 'Undocked::Methods#instance_method' }
        should_not_find
      end
      context "on normal class methods" do
        setup { at 'Undocked::Methods.class_method' }
        should_not_find
      end
      context "on class methods inside metaclass scope" do
        setup { at 'Undocked::Methods.method_inside_metaclass' }
        should_not_find
      end
    end
    
  end
    
end