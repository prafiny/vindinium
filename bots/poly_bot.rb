class PolyBot < BaseBot
  include Automaton, Threshold, Volatile
  extend Volatile
  def initialize threshold_file
    load_thresholds threshold_file
    @a_star = Pathfinding::AStar.new
    @objective = lambda do
      @me.gold.to_f / (@game.heroes.map{ |h| h.gold }.reduce(:+).to_f + 1.0)
    end
    @path = []

    def_automaton do
      state :conqueror do
        transition_to(:coward) { thirst > t(5) && nearness_tavern < t(6) }
        transition_to(:coward) { thirst > t(4) }
        transition_to(:coward) { nearest_mine.nil? }

        transition_to(:warrior) { nearness_enemy < t(7) && violence > t(16) }        
        behaviour do
          select_goal nearest_mine if current_state(:obj).activated? || path_needed && !nearest_mine.nil?
        end
      end

      state :coward do
        transition_to(:warrior) { thirst < t(8) && nearness_enemy < t(10) && violence > t(11) }
        transition_to(:conqueror) { thirst < t(12) && nearness_mine < t(13) }
        transition_to(:conqueror) { thirst < t(14) && greed > t(15) }

        behaviour do
          select_goal nearest(@game.taverns) if current_state(:obj).activated? || path_needed
        end
      end

      state :warrior do
        transition_to(:coward) { thirst > t(1) && nearness_tavern < t(9) }
        transition_to(:coward) { thirst > t(2) }
        transition_to(:coward) { violence < t(3) }

        behaviour do
          select_goal nearest_enemy.pos if current_state(:obj).activated? || path_needed
        end
      end
    end
  end

  def move state
    fade
    if @game.nil?
      @game = Game.new state
      @distance_max = Math.sqrt(2) * @game.board.size
      @a_star.board = @game.board
      @me = @game.me
    else
      @game.update state
    end
    evaluate_state
    act
    follow_path
  end

  private
  def path_needed
    @path.empty? || !@game.board.neighbours(@me.pos).include?(@path.first) 
  end

  def nearest(arr, *args)
    if args.include?(:distance)
      nearest_el = arr.map { |el| el.manhattan(@me.pos) }.min
    else
      nearest_el = arr.min_by { |el| el.manhattan(@me.pos) }
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
      path = @game.board.passable_neighbours(near).map { |e| @a_star.search_path @me.pos, e }.min_by { |path, score| score }
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
    @violence ||= @me.life.to_f / nearest_enemy.life * (@game.mines.select { |m| m.belongs_to? nearest_enemy }.count.to_f / @game.mines.count)
  end

  def greed
    score_total = @game.heroes.map{ |h| h.gold }.reduce(:+).to_f
    nb_mines_me = @game.mines.select { |m| m.belongs_to? @me }.count.to_f
    nb_mines = @game.mines.count.to_f
    @greed ||= (score_total - @me.gold) / (score_total+1) * (nb_mines - nb_mines_me) / nb_mines
  end

  def nearest_enemy
    @nearest_enemy ||= @game.heroes.select{ |h| h != @me }.min_by { |el| [el.x, el.y].manhattan(@me.pos) }
  end

  def nearness_enemy
    @neaness_enemy ||= nearest_enemy.pos.manhattan(@me.pos) / @distance_max
  end

  def nearest_mine
    if @nearest_mine.nil?
      n = @game.mines.select{ |m| !m.belongs_to? @me }
      unless n.nil?
        @nearest_mine = nearest(n.map{ |m| m.pos })
      else
        @nearest_mine = nil
      end
    end
    @nearest_mine
  end

  def nearness_mine
    @nearness_mine ||= (nearest_mine.nil? ? @distance_max : nearest_mine.manhattan(@me.pos)) / @distance_max
  end

  def nearest_tavern
    @nearest_tavern ||= nearest @game.taverns
  end

  def nearness_tavern
    @nearness_tavern ||= nearest_tavern.manhattan(@me.pos) / @distance_max
  end  
end

