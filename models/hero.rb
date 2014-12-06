class Hero

  attr_accessor :name, :pos, :life, :gold, :x, :y

  def initialize hero
    self.name = hero['name']
    self.pos = hero['pos']
    self.life = hero['life'].to_i
    self.gold = hero['gold'].to_i
    self.x = self.pos['x'].to_i
    self.y = self.pos['y'].to_i
    self.id = hero['id']
  end

  def == hero
    self.id == hero.id
  end

end
