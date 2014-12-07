class Hero

  attr_accessor :name, :pos, :life, :gold, :x, :y, :id

  def initialize hero
    self.name = hero['name']
    self.life = hero['life']
    self.gold = hero['gold']
    self.x = hero['pos']['x']
    self.y = hero['pos']['y']
    self.pos = [self.x, self.y]
    self.id = hero['id']
  end

  def == hero
    self.id == hero.id
  end

end
