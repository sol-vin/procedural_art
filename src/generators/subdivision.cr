module ProceduralArt::Subdivision
  struct Rect
    property x, y, width, height = 0

    property divisions = 0

    def initialize(@x = 0, @y = 0, @width = 0, @height = 0)
    end

    def aspect_ratio
      numer, denom = @width, @height

      if denom == 0
        raise "Division by 0 - result undefined"
      end

      while denom != 0
        numer, denom = denom, numer % denom
      end
      # Remove greatest common divisor:
      common_divisor = numer
      reduced_num, reduced_den = @width / common_divisor, @height / common_divisor

      if reduced_den == 1
        [reduced_den, reduced_den]
      elsif common_divisor == 1
        [numer, denom]
      else
        [reduced_num, reduced_den]
      end
    end

    def to_rect
      self
    end

    def to_drawable
      r = Celestine::Rectangle.new
      r.x = @x
      r.y = @y
      r.width = @width
      r.height = @height

      r
    end
  end

  SIZE = 500

  class_property seed = 1

  def self.make_rects(ctx, perlin, levels)
    rects = [] of ProceduralArt::Subdivision::Rect
    # Add starter rect
    rects << ProceduralArt::Subdivision::Rect.new(width: SIZE, height: SIZE)
    new_rects = [] of ProceduralArt::Subdivision::Rect

    levels.times do |level|
      rects.each_with_index do |rect, i|
        if perlin.prng_int(rect.x + (rect.width / 2.0).to_i, rect.y + (rect.height / 2.0).to_i, i, 0, 5) != 0
          rect.width = (rect.width / 2.0).to_i
          rect.height = (rect.height / 2.0).to_i
          rect.divisions += 1
          new_rects << rect

          new_rect = rect.dup
          new_rect.x += new_rect.width
          new_rect.y += new_rect.height
          new_rects << new_rect 

          new_rect = rect.dup
          new_rect.y += new_rect.height
          new_rects << new_rect 

          new_rect = rect.dup
          new_rect.x += new_rect.width
          new_rects << new_rect 
        end
      end
      rects.clear
      rects += new_rects
      new_rects = [] of ProceduralArt::Subdivision::Rect
    end

    rects.each_with_index do |rect, i|
      drawable = rect.to_drawable
      drawable.x = rect.x + 2
      drawable.y = rect.y + 2      
      drawable.width = rect.width - 2
      drawable.height = rect.height - 2

      drawable.fill = perlin.item(rect.x + (rect.width / 2.0).to_i, rect.y + (rect.height / 2.0).to_i, i, ["#ff0000", "#ff4f00", "#ff6f00", 
                                                                                                           "#fecf00", "#feff00", "#94ff00", 
                                                                                                           "#45ff00", "#1fff7e", "#00ffe2", 
                                                                                                           "#00baf1", "#0075ff", "#0b3bff", 
                                                                                                           "#0f21ff", "#1500ff", "#4d00ff", 
                                                                                                           "#8400ff", "#b100ff", "#ff00fe", 
                                                                                                           "#ff0095", "#ff0068", "#ff0000"])
        ctx << drawable
    end
  end

  def self.make
    perlin = PerlinNoise.new(seed)
    perlin.octave = 100.0

    Celestine.draw do |ctx|
      ctx.view_box = {x: 0, y: 0, w: 500, h: 500}
      make_rects(ctx, perlin, 5)
    end
  end
end