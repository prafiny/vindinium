class PolyBot < BaseBot

  def initialize
    @a_star = Pathfinding::AStar.new
    @decision_needed = true
  end

  def move state
    @game = Game.new state
    @me = @game.heroes.first
    print @me.inspect
    @a_star.board = @game.board
    if @decision_needed
      near = nearest(@game.taverns_locs)
      @path = near.shift
      @path << near.pop
      @path.shift
      @path << 
      @decision_needed = false
    end
    follow_path
    #DIRECTIONS.sample
  end

  private
  def nearest(arr)
    path = arr.map { |el| @a_star.search_path([@me.x, @me.y], el) << el }.min_by { |path, score, pos| score }
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

