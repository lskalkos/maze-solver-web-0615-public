require 'byebug'

class MazeSolver
  attr_reader :maze, :traveled_path, :visited_nodes, :solution_path
  attr_accessor :node_queue

  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @solution_path = []
  end

  def maze_array
    #split the string-based maze into an array of arrays
    maze.split("\n").map{|string| string.split("")}
  end

  def x_dimensions
    #find x dimensions
    maze_array.first.length
  end

  def y_dimensions
    #find y dimensions
    maze_array.length
  end

  def start_coordinates
    maze_array.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        if col == "→"
          return [col_index, row_index]
        end
      end
    end
  end

  def end_coordinates
    maze_array.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        if col == "@"
          return [col_index, row_index]
        end
      end
    end
  end

  def node_value(coords)
    #check node value based on maze_array coordinates
    col = coords[0]
    row = coords[1]
    if maze_array[row].nil?
      nil
    else
      maze_array[row][col]
    end
  end

  def valid_node?(coords)
    col = coords[0]
    row = coords[1]
    if maze_array[row].nil? || maze_array[row][col].nil?
      false
    elsif maze_array[row][col] != " "
      false
    else
      true
    end
  end

  def neighbors(coords)
    #find the neighbors of a set of coordinates
    neighbors = []
    col = coords[0]
    row = coords[1]

    potential_valid_nodes = [[col + 1, row], [col-1, row], [col, row+1], [col, row-1]]

    potential_valid_nodes.each do |node|
      if valid_node?(node) || node == end_coordinates
        neighbors << node
      end
    end

    neighbors

  end

  def add_to_queues(next_node, previous_node=nil)

    #if this node hasn't been visited
    if !visited_nodes.include?(next_node)
      #queue it to be visited
      node_queue << next_node
      #note it in the travelled path, along with the previous node
      traveled_path << [next_node, previous_node]
      #mark it as visited
      visited_nodes << next_node
    end

  end

  def move
    #gets the next node in the queue
    next_node = node_queue.shift
    #finds its neighbors
    neighbors = neighbors(next_node)
    #for each of those neighbors
    neighbors.each do |neighbor|
      #add to the queue (and send along the node its connected to)
      add_to_queues(neighbor, next_node)
      if neighbor == end_coordinates
        node_queue = []
        return
      end
    end

  end

  def find_solution_path(coordinates)
    while !solution_path.include?(start_coordinates)
      traveled_path.each do |pair|
        end_node = pair[0]
        previous_node = pair[1]
        if end_node == coordinates
          solution_path << end_node
          find_solution_path(previous_node)
        end
      end
    end
  end

  def solve
    #add the start coordinates to the queues
    add_to_queues(start_coordinates, start_coordinates)
    #if the node queue isn't empty
    while !node_queue.empty?
      #move through the maze
      move
    end

    #from the travelled path, backtrace to find the solution path
    find_solution_path(end_coordinates)
  end

  def display_solution_path

  end

end



