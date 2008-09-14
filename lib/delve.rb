$LOAD_PATH.unshift File.dirname(__FILE__)

require 'delve/builder'
require 'delve/node'

module Delve
  
  def self.store
    @store ||= []
  end
  
  def self.[](name)
    store.map { |root| root[name] }.flatten.uniq
  end
  
  def self.load(filename)
    store << parse(File.read(filename), filename)
  end
  
  def self.load_required!
    $".each do |filename|
      if filename =~ /\.rb$/
        load filename
      end
    end
  end
  
  def self.parse(src, filename = '-', lineno = 1)
    builder = Builder.new(src, filename, lineno)
    Node.new(nil, builder.parse, builder).tap do |node|
      node.filename = filename
    end
  end
  
end
  
 