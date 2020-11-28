struct ProceduralArt::Mineshift::Rectangle
  property x : IFNumber = 0
  property y : IFNumber = 0
  property width : IFNumber = 0
  property height : IFNumber = 0
  
  def left
    x
  end

  def right
    left + width
  end

  def top
    y
  end

  def bottom
    top + height
  end
end