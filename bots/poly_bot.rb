class PolyBot < BaseBot
  include Automaton, Volatile, Threshold
  def initialize
    @a_star = Pathfinding::AStar.new
    @path = []

    def_automaton do
      state :coward do
        
        behaviour do
          
        end
      end

      state :warrior do

        behaviour do

        end
      end

      state :conqueror do

        behaviour do

        end
      end
  end

  def move state
    fade
    @game = Game.new state
    @me = @game.me
    @a_star.board = @game.board
    act
    follow_path
  end

  private
  def nearest(arr)
    nearest_el = arr.min_by { |el| el.manhattan([@me.x, @me.y]) }
  end

  def follow_path
    n = @path.shift
    if n.nil?
      return "Stay"
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

  def select_goal choice
    near = nearest(choice)
    unless near.nil?
      path = @game.board.passable_neighbours(near).map { |e| @a_star.search_path [@me.x, @me.y], e }.min_by { |path, score| score }
      unless path[1] == Float::INFINITY
        @path = path.first
        @path << near
        @path.shift
      end
    end
  end

  volatile :thirst, :violence, :greed, :nearest_enemy, :nearest_mine
  
  # Feelings
  def thirst
    @thirst ||= 0
  end

  def violence
    @violence ||= 0
  end

  def greed
    @greed ||= 0
  end

  def nearest_enemy
    @nearest_enemy ||= nil
  end

  def nearest_mine
    @nearest_mine ||= nil
  end
end

