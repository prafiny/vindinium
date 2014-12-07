class PolyBot < BaseBot
  include Automaton, Threshold, Volatile
  extend Volatile
  def initialize
    @a_star = Pathfinding::AStar.new
    @objective = lambda do
      chart = @game.heroes.sort { |h1, h2| -h1.gold <=> -h2.gold }
      score_max = chart.first.gold
      return (score_max - @me.gold) / score_max unless chart.first == @me
      (chart[1] - score_max) / score_max
    end
    @path = []

    def_automaton do
      state :conqueror do
        transition_to(:coward) { thirst > t(5) && nearness_tavern < t(6) }
        transition_to(:coward) { thirst > t(4) }

        transition_to(:warrior) { nearness_enemy < t(7) && violence > t(16) }        
        behaviour do
          select_goal nearest_mine if current_state(:obj).activated? || path_needed
        end
      end

      state :coward do
        transition_to(:warrior) { thirst < t(8) && nearness_enemy < t(10) && violence > t(11) }
        transition_to(:conqueror) { thirst < t(12) && nearness_mine < t(13) }
        transition_to(:conqueror) { thirst < t(14) && greed > t(15) }

        behaviour do
          select_goal nearest(@game.taverns_locs) if current_state(:obj).activated? || path_needed
        end
      end

      state :warrior do
        transition_to(:coward) { thirst > t(1) && nearness_tavern < t(9) }
        transition_to(:coward) { thirst > t(2) }
        transition_to(:coward) { violence < t(3) }

        behaviour do
          select_goal nearest_enemy if current_state(:obj).activated? || path_needed
        end
      end
    end
  end

  def move state
    fade
    @game = Game.new state
    @distance_max = Math.sqrt(2) * @game.board.size
    @me = @game.me
    @a_star.board = @game.board
    evaluate_state
    puts @@volatiles.map { |e| puts e; "#{e} => #{send(e.to_s.delete('@').to_sym)}" }.inspect
    puts current_state
    act
    follow_path
  end

  private
  def path_needed
    @path.empty? || !@game.board.neighbours([@me.x, @me.y]).include?(@path.first) 
  end

  def nearest(arr, *args)
    if args.include?(:distance)
      nearest_el = arr.map { |el| el.manhattan([@me.x, @me.y]) }.min
    else
      nearest_el = arr.min_by { |el| el.manhattan([@me.x, @me.y]) }
    end
    nearest_el
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

  def select_goal near
    unless near.nil?
      path = @game.board.passable_neighbours(near).map { |e| @a_star.search_path [@me.x, @me.y], e }.min_by { |path, score| score }
      unless path[1] == Float::INFINITY
        @path = path.first
        @path << near
        @path.shift
      end
    end
  end

  volatile :thirst, :violence, :greed, :nearest_enemy, :nearest_mine, :nearest_tavern, :nearness_enemy, :nearness_mine,
           :nearness_tavern
  
  # Feelings
  def thirst
    @thirst ||= (100.0 - @me.life) / 100.0
  end

  def violence
    @violence ||= @me.life.to_f / nearest_enemy.life * (@game.mines_locs.select { |pos, id| id == nearest_enemy().id.to_s }.count.to_f / @game.mines_locs.count)
  end

  def greed
    score_max = @game.heroes.map { |h| h.gold }.max.to_f
    nb_mines_me = @game.mines_locs.select { |k, v| v == @me.id.to_s }.count.to_f
    nb_mines = @game.mines_locs.count.to_f
    @greed ||= (score_max - @me.gold) / (score_max+1) * (nb_mines - nb_mines_me) / nb_mines
  end

  def nearest_enemy
    @nearest_enemy ||= @game.heroes.select{ |h| h != @me }.min_by { |el| [el.x, el.y].manhattan([@me.x, @me.y]) }
  end

  def nearness_enemy
    @neaness_enemy ||= nearest_enemy.pos.manhattan([@me.x, @me.y]) / @distance_max
  end

  def nearest_mine
    @nearest_mine ||= nearest(@game.mines_locs.select{ |k, v| v != @me.id.to_s }.map{ |k,v| k })
  end

  def nearness_mine
    @nearness_mine ||= nearest_mine.manhattan([@me.x, @me.y]) / @distance_max
  end

  def nearest_tavern
    @nearest_tavern ||= nearest @game.taverns_locs, :distance
  end

  def nearness_tavern
    @nearness_tavern ||= nearest_tavern / @distance_max
  end  
end

