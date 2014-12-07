class Mine

  attr_reader :pos, :hero_id

  def hero_id= (id)
    @hero_id = id.to_i
  end

  def initialize pos, hero_id
    @pos = pos
    @hero_id = hero_id.to_i
  end

  def belongs_to? hero
    @hero_id == hero.id
  end

end

