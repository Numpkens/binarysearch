class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

# Tree class
class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    root = Node.new(array[mid])

    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[(mid + 1)..-1])

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    @root = insert_recursive(@root, value)
  end

  def delete(value)
    @root = delete_recursive(@root, value)
  end

  def find(value)
    find_recursive(@root, value)
  end

  def level_order
    return [] if @root.nil?

    result = []
    queue = [@root]

    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : result << current.data
      queue << current.left if current.left
      queue << current.right if current.right
    end

    result unless block_given?
  end

  def inorder(node = @root, result = [], &block)
    return result if node.nil?

    inorder(node.left, result, &block)
    block_given? ? yield(node) : result << node.data
    inorder(node.right, result, &block)

    result unless block_given?
  end

  def preorder(node = @root, result = [], &block)
    return result if node.nil?

    block_given? ? yield(node) : result << node.data
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)

    result unless block_given?
  end

  def postorder(node = @root, result = [], &block)
    return result if node.nil?

    postorder(node.left, result, &block)
    postorder(node.right, result, &block)
    block_given? ? yield(node) : result << node.data

    result unless block_given?
  end

  def height(node = @root)
    return -1 if node.nil?

    [height(node.left), height(node.right)].max + 1
  end

  def depth(node)
    return 0 if node == @root

    current = @root
    depth = 0

    until current.nil? || current.data == node.data
      depth += 1
      current = node.data < current.data ? current.left : current.right
    end

    depth
  end

  def balanced?
    balanced_recursive?(@root)
  end

  def rebalance
    @root = build_tree(inorder)
  end

  private

  def insert_recursive(node, value)
    return Node.new(value) if node.nil?
    return node if value == node.data

    if value < node.data
      node.left = insert_recursive(node.left, value)
    else
      node.right = insert_recursive(node.right, value)
    end

    node
  end

  def delete_recursive(node, value)
    return nil if node.nil?

    if value < node.data
      node.left = delete_recursive(node.left, value)
    elsif value > node.data
      node.right = delete_recursive(node.right, value)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      successor = find_min(node.right)
      node.data = successor.data
      node.right = delete_recursive(node.right, successor.data)
    end

    node
  end

  def find_recursive(node, value)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find_recursive(node.left, value) : find_recursive(node.right, value)
  end

  def find_min(node)
    current = node
    current = current.left while current.left
    current
  end

  def balanced_recursive?(node)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return false if (left_height - right_height).abs > 1

    balanced_recursive?(node.left) && balanced_recursive?(node.right)
  end
end

# Driver Script
puts "Creating a binary search tree from random numbers..."
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

puts "\nInitial tree:"
tree.pretty_print

puts "\nIs the tree balanced? #{tree.balanced?}"

puts "\nLevel order traversal: #{tree.level_order}"
puts "Preorder traversal: #{tree.preorder}"
puts "Postorder traversal: #{tree.postorder}"
puts "Inorder traversal: #{tree.inorder}"

puts "\nAdding numbers > 100 to unbalance the tree..."
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
tree.insert(105)

puts "\nUnbalanced tree:"
tree.pretty_print

puts "\nIs the tree balanced? #{tree.balanced?}"

puts "\nRebalancing tree..."
tree.rebalance

puts "\nRebalanced tree:"
tree.pretty_print

puts "\nIs the tree balanced? #{tree.balanced?}"

puts "\nLevel order traversal: #{tree.level_order}"
puts "Preorder traversal: #{tree.preorder}"
puts "Postorder traversal: #{tree.postorder}"
puts "Inorder traversal: #{tree.inorder}"
