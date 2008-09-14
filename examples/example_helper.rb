require File.dirname(__FILE__) << "/../lib/delve"

# Could just 'load' each, even if not required; this is a shortcut
# and uses $"
Delve.load_required!

def show(name)
  references = Delve[name]
  puts "#{name} was defined/modified in #{references.size} places(s)"
  references.each do |reference|
    puts "---",
         "On line ##{reference.line} of #{reference.filename}"
    puts "The assocated documentation was...\n"
    puts reference.comment
  end
end