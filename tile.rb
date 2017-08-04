class Tile

  attr_reader :val, :revealed

  def initialize(val)
    @revealed = false
    @val = val
  end

  def reveal
    @revealed = true
  end

  def ==(value)
    @val == value
  end

end
