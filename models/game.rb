class Game

  attr_accessor :state, :board, :heroes, :mines, :taverns, :me

  def initialize state
 
    self.state = state
    puts "Turn #{state['game']['turn'] / 4}"
    self.board = Board.new state['game']['board']
    self.mines = []
    self.taverns = []
    self.heroes = []

    state['game']['heroes'].each do |hero|
      h = Hero.new(hero)
      self.heroes << h
      self.me = h if h.id == state['hero']['id']
    end

    self.board.tiles.each_with_index do |row, row_idx|

      row.each_with_index do |col, col_idx|
        # what kinda tile?
        obj = col 
        if obj.is_a? MineTile
          self.mines << Mine.new([row_idx, col_idx], obj.hero_id)
        elsif obj == TAVERN
          self.taverns << [row_idx, col_idx]
        end

      end

    end

  end

  def update state
    self.state = state
    puts "Turn #{state['game']['turn'] / 4}"
    self.mines.each do |m|
      m.hero_id = get_char_at(m.pos)[1]
    end
    
    state['game']['heroes'].each.with_index do |h, i|
      self.heroes[i].update h
    end
  end

  private
  def get_char_at pos
    beg = pos[0]*((self.board.size)*2)+pos[1]*2
    self.state['game']['board']['tiles'][beg..beg+1]
  end
end
