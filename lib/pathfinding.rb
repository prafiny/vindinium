class Array
  def manhattan with
    x1, y1 = self
    x0, y0 = with
    (x1 - x0).abs + (y1 - y0).abs
  end
end

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
      
    end

    def compute_adjacency board

    end

    def iter_over_adjacency

    end

    def get_shortest_path from, to
      
    end

    def get_shortest_length from, to

    end
  private
    def get_id pos
      
    end
  end
end
