module SingleLine

  # A line for SingleComponentModule
  module SingleComponentModule
  end

  # A line for Multiple::ComponentModule
  module Multiple::ComponentModule
  end

  # A line for SingleComponentClass
  class SingleComponentClass
  end

  # A line for  Multiple::ComponentClass
  class Multiple::ComponentClass
  end
  
  class Methods

    # A line for self.class_method
    def self.class_method
    end

    class << self

      # A line for method_inside_metaclass
      def method_inside_metaclass
      end

    end

    # A line for instance_method
    def instance_method
    end

  end
  
end

module MultipleLines

  # Multiple lines
  # for SingleComponentModule
  module SingleComponentModule
  end

  # Multiple lines
  # for Multiple::ComponentModule
  module Multiple::ComponentModule
  end

  # Multiple lines
  # for SingleComponentClass
  class SingleComponentClass
  end

  # Multiple lines
  # for Multiple::ComponentClass
  class Multiple::ComponentClass
  end
  
  class Methods

    # Multiple lines
    # for self.class_method
    def self.class_method
    end

    class << self

      # Multiple lines
      # for method_inside_metaclass
      def method_inside_metaclass
      end

    end

    # Multiple lines
    # for instance_method
    def instance_method
    end

  end
  
end

module Undocked
  
  # Undocked

  module SingleComponentModule
  end
  
  # Undocked

  module Multiple::ComponentModule
  end

  # Undocked

  class SingleComponentClass
  end
  
  # Undocked

  class Multiple::ComponentClass
  end
  
  class Methods

    # Undocked

    def self.class_method
    end

    class << self
      
      # Undocked

      def method_inside_metaclass
      end

    end
    
    # Undocked

    def instance_method
    end

  end
  
end