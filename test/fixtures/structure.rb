module Foo
  
  module Bar
    
    def self.quux
    end
    
    class << self
      
      def foo
      end
      
    end
    
    def bar
    end
    
  end
  
end

class Baz
end

class Foo::Bar::Spam
end

module Foo::Bar::Spam::Eggs
end