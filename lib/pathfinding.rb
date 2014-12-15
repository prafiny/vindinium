class Array
  def manhattan with
    x1, y1 = self
    x0, y0 = with
    (x1 - x0).abs + (y1 - y0).abs
  end
end

class Array2D
  def initialize(width, height)
    @data = Array.new(width) { Array.new(height) }
  end
  def [](x, y)
    @data[x][y]
  end
  def []=(x, y, value)
    @data[x][y] = value
  end
end

require 'matrix'

module Pathfinding
  class AStar
    attr_writer :board

    def search_path from, to
      init_struct from, to
      until @open_set.empty?
        current = @open_set.min_by { |e| @f_score[e] }
        return [backtrack(to), @g_score[to]] if current == to
        @closed_set << @open_set.delete(current)
        @board.passable_neighbours(current).each { |n|
          unless @closed_set.include?(n)
            tentative_g_score = @g_score[current] + 1
            if !@open_set.include?(n) || tentative_g_score < @g_score[n]
              @came_from[n] = current
              @g_score[n] = tentative_g_score
              @f_score[n] = @g_score[n] + n.manhattan(to)
              unless @open_set.include?(n)
                @open_set << n
              end
            end
          end
        }
      end
      [nil, Float::INFINITY]
    end

    private
    def init_struct origin, goal
      @closed_set = []
      @open_set = [origin]
      @came_from = {}

      @g_score = {origin => 0}
      @f_score = {origin => @g_score[origin] + origin.manhattan(goal)}
    end

    def backtrack p
      path = [p]
      while @came_from.include?(p)
        p = @came_from[p]
        path.unshift p
      end
      path
    end
  end

  class Floyd
    attr_writer :board
    def initialize
      @board = nil
      @next = nil
      @length = nil
    end

    def compute
      raise Exception, "No board defined" if @board.nil?
      init
      iter_over_adjacency
    end

    def search_path from, to
      u, v = get_id(from), get_id(to)
      return nil if @next[u, v].nil?
      path = [from]
      until u == v
        u = @next[u, v]
        path.push get_pos(@next[u, v])
      end
      path
    end

    def search_length from, to
      @length[get_id(from), get_id(to)]
    end
  private
    def get_id pos
      pos[0]*@board.size + pos[1]
    end

    def get_pos id
      [id % @board.size, id / @board.size]
    end

    def iter_over_adjacency
      size = @board.size
      size.times do |k|
        size.times do |i|
          next if @length[i, k].nil?
          size.times do |j|
            next if @length[k, j].nil?
            new_e = @length[i, k] + @length[k, j]
            if new_e < @length[i, j]
              @length[i, j] = new_e
              @next[i, j] = @next[i, k]
            end
          end
        end
      end
    end

    def init
      size = @board.size
      @next = Array2D.new(size, size)
      @length = Array2D.new(size, size)
      size.times do |i|
        size.times do |j|
          if i == j
            @next[i, j] = j
            @length[i, j] = 0 
          elsif @board.passable_neighbours(get_pos(i)).include?(get_pos(j))
            @next[i, j] = j
            @length[i, j] = 1
          else
            @next[i, j] = nil
            @length[i, j] = Float::INFINITY
          end
        end
      end
    end
  end
end
