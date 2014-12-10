class Hero

  attr_accessor :name, :pos, :life, :gold, :x, :y, :id, :mine_count

  def initialize hero
    self.name = hero['name']
    self.life = hero['life']
    self.gold = hero['gold']
    self.x = hero['pos']['x']
    self.y = hero['pos']['y']
    self.mine_count = hero['mineCount']
    self.pos = [self.x, self.y]
    self.id = hero['id']
  end

  def == hero
    self.id == hero.id
  end

  def update hero
    self.life = hero['life']
    self.gold = hero['gold']
    self.x = hero['pos']['x']
    self.y = hero['pos']['y']
    self.mine_count = hero['mineCount']
    self.pos = [self.x, self.y]
  end
end
