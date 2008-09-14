module Delve
  
  class Node

    def self.handlers
      @handlers ||= Hash.new(Node)
    end

    def self.handles(kind)
      Node.handlers[kind] = self
    end

    attr_reader :children, :data, :kind
    attr_accessor :parent, :filename
    def initialize(parent, data, builder = nil)
      @parent = parent
      @kind = data.first
      @data = data
      @builder = builder
      @children = []
      parse
    end
    
    def [](name)
      descendants.select do |node|
        node.respond_to?(:matches?) && node.matches?(name)
      end
    end

    def builder
      @builder ||= parent.builder
    end
    
    def filename
      @filename ||= parent.filename
    end

    # Convenience; assume data[1] is the value for this node
    def value
      data[1]
    end

    def line
      if data[2].is_a?(Array) && data[2].size == 2 && data[2].all? { |n| n.is_a?(Fixnum) }
        data[2][0]
      end
    end

    # Find node in children with matching kind
    def find(kind, recurse = false, &block)
      children.each do |node|
        if node.kind == kind
          yield node
        elsif recurse
          node.find(kind, true, &block)
        end
      end
    end

    def descendants
      children + children.map { |child| child.descendants }.flatten
    end

    def valid?
      true
    end

    # This allows nodes to transform the kind of a descendant node
    def transform_child_kind(kind)
      if parent
        parent.transform_child_kind(kind)
      else
        kind
      end
    end

    private

    # Override
    def parse
      data[1..-1].each do |possible_child|
        traverse possible_child
      end
    end

    def traverse(raw_node)
      return unless raw_node.is_a?(Array)
      if raw_node.first.is_a?(Symbol)
        kind = transform_child_kind(raw_node.first)
        handler = Node.handlers[kind]
        add_child handler.new(self, raw_node)
      else
        raw_node.each do |deeper_child|
          traverse deeper_child
        end
      end
    end

    def add_child(child)
      if child.is_a?(CompositeNode)
        child.children.each do |grandchild|
          add_child grandchild
        end
      else
        if child.valid?
          children << child
        else
          add_child Node.new(self, child.data)
        end
      end
    end

  end

  class AddressableNode < Node
    attr_reader :name, :line

    def name_separator
      '::'
    end

    def full_name
      if addressable_ancestor
        [addressable_ancestor.full_name, name].join(name_separator)
      else
        name
      end
    end

    def addressable_ancestor(check = parent)
      return nil unless check
      @addressable_ancestor ||= begin
        if check.is_a?(AddressableNode)
          check
        else
          addressable_ancestor check.parent
        end
      end
    end
    
    def matches?(candidate)
      full_name == candidate
    end

    def valid?
      @name
    end

    def comment
      builder.comments[line]
    end

  end

  class InstanceMethodNode < AddressableNode
    handles :def

    def name_separator
      '#'
    end

    def parse
      super
      find :@ident do |ident|
        @name, @line = ident.value, ident.line
        return
      end
    end

  end

  class SingletonMethodNode < AddressableNode
    handles :defs

    def name_separator
      '.'
    end
    
    def matches?(candidate)
      [full_name, alternate_full_name].include?(candidate)
    end
    
    def alternate_full_name
      @alternate_full_name ||= full_name.sub(/\.#{Regexp.quote name}$/, "::#{name}")
    end

    def parse
      super
      # If the variable reference is an @ident instead of a 'self' @kw,
      # this node isn't addressable (so skip)
      find :var_ref do |ref|
        ref.find :@ident do |ident|
          return 
        end
      end
      find :@ident do |ident|
        @name = ident.value
        @line = ident.line
      end
    end

  end

  module ConstPathing

    def parse
      super
      name_from_const_ref
      name_from_const_path_ref unless @name && @line
    end

    def name_from_const_ref
      find :const_ref do |const_ref|
        const_ref.find :@const do |const|
          @name, @line = const.value, const.line
        end
      end
    end

    def name_from_const_path_ref
      find :const_path_ref do |path_ref|
        components = []
        path_ref.find(:@const, true) do |const|
          components << const.value
          @line = const.line
        end
        unless components.empty?        
          @name = components.join('::')
        end
      end
    end

  end

  class ModuleNode < AddressableNode
    include ConstPathing
    handles :module
  end

  class ClassNode < AddressableNode
    include ConstPathing
    handles :class
  end

  # Abstract 
  class CompositeNode < AddressableNode

    def parse
      super
      children.each do |child|
        child.parent = parent
      end
    end

  end

  class SingletonClassNode < CompositeNode
    handles :sclass

    def transform_child_kind(kind)
      kind == :def ? :defs : kind
    end

  end

end
