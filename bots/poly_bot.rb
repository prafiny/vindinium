class PolyBot < BaseBot

  def initialize
    @a_star = Pathfinding::AStar.new
    @decision_needed = true
    @path = []
  end

  def move state
    @game = Game.new state
    @me = @game.heroes.first
    @a_star.board = @game.board
    if @decision_needed
      near = nearest(@game.mines_locs.keep_if{ |k, v| v != "1" }.map{ |k,v| k })
      @path = @game.board.passable_neighbours(near).map { |e| @a_star.search_path [@me.x, @me.y], e }.min_by { |path, score| score }.first
      @path << near
      @decision_needed = false
    end
    if @path.empty?
      @decision_needed = true
    end
    follow_path
  end

  private
  def nearest(arr)
    nearest_el = arr.min_by { |el| el.manhattan([@me.x, @me.y]) }
  end

  def follow_path
    n = @path.shift
    if n.nil?
      "Stay"
    end
    x, y = n
    if x == @me.x
      return "East" if @me.y < y
      return "West" if @me.y > y
    end
    if y == @me.y
      return "South" if @me.x < x
      return "North" if @me.x > x
    end
    "Stay"
  end
end

