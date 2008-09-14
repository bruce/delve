require File.dirname(__FILE__) << "/../lib/delve"

node = Delve.parse(<<EOT, __FILE__, __LINE__ + 1)
# This is a comment
class Foo
  class << self    
    # A singleton method
    def bar
    end
  end
end
class Foo
  # Redefining it
  def self.bar
  end
end
EOT

p node['Foo.bar'].size
# Outputs:
# 2

node['Foo.bar'].each do |signature|
  p [signature.filename, signature.line]
end
# Outputs:
# ["examples/ad_hoc.rb", 8]
#  ["examples/ad_hoc.rb", 14]

p node['Foo.bar'].map(&:comment)
# Outputs:
# ["# A singleton method\n", "# Redefining it\n"]



