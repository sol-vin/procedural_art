class Art::ChromaticAberration
  property width = 1600
  property height = 800

  property smallest_square_size = 8
  property square_size = 40
  property padding = 2

  property colors = ["#FF0000", "#00FF00", "#0000FF"]

  BLEND_TYPE = "difference"

  class_property seed = 0
  def self.make
    ca = self.new(@@seed)
    ca.make
  end

  def initialize(seed, @width = 800, @height = 600)
    @perlin = PerlinNoise.new(seed)
    @perlin.step = 1.0
  end

  def rotate_point(x, y, ox, oy, deg)
    angle = deg * (Math::PI/180)
    rx = Math.cos(angle) * (x - ox) - Math.sin(angle) * (y - oy) + ox
    ry = Math.sin(angle) * (x - ox) + Math.cos(angle) * (y - oy) + oy
    {x: rx, y: ry}
  end

  def make
    Celestine.draw do |ctx|
      ctx.view_box = {x: 0, y: 0, w: width, h: height}

      ctx.rectangle do |rect|
        rect.id = "bg"
        rect.x = 0
        rect.y = 0
        rect.width = width
        rect.height = height
        rect.fill = "white"
        rect
      end

      (width/(square_size+padding*2)).to_i.times do |x|
        (height/(square_size+padding*2)).to_i.times do |y|
          p_square_size = ((((@perlin.noise(x, y)+1.0)/2.0) * ((square_size-10)-smallest_square_size)).to_i + smallest_square_size).to_i
          ab_offset = ((p_square_size*0.4) - (((@perlin.noise(x, y)+1.0)/2.0) * (p_square_size*0.4))).to_i
          ab_timing = 5 + (((@perlin.noise(x, y)+1.0)/2.0) * 10).to_i


          p_half_square = (p_square_size/2.0)

          x_padding = padding.to_f + (padding*2*x)
          y_padding = padding.to_f + (padding*2*y)

          origin_x = x * square_size.to_f + x_padding
          origin_y = y * square_size.to_f + y_padding

          origin_mid_point_x = origin_x + (square_size/2.0)
          origin_mid_point_y = origin_y + (square_size/2.0)

          ab_x = origin_x + ((square_size - p_square_size)/2.0)
          ab_y = origin_y + ((square_size - p_square_size)/2.0)

          ab_mid_point_x = ab_x + p_half_square
          ab_mid_point_y = ab_y + p_half_square - ab_offset

          colors.each_with_index do |color, index|
            deg =  120*index
  
            rot_ab_mid_point = rotate_point(ab_mid_point_x, ab_mid_point_y, origin_mid_point_x, origin_mid_point_y, deg)
            final_ab_x = rot_ab_mid_point[:x] - p_half_square
            final_ab_y = rot_ab_mid_point[:y] - p_half_square

            ctx.rectangle do |rect|
              rect.height = p_square_size
              rect.width = p_square_size
              rect.fill = color
              rect.style["mix-blend-mode"] = "difference"

              rect.animate do |anim|
                anim.attribute = "rx"
                anim.values << 0
                anim.values << p_half_square.to_i
                anim.values << 0
                anim.duration = (@perlin.prng_int(90, 90, 0, 2, 0.5152) == 0 ? 10.s : ab_timing.s)
                anim.repeat_count = "indefinite"
                anim
              end

              rect.animate_motion do |anim|
                anim.duration = 5.s
                anim.repeat_count = "indefinite"

                anim.mpath do |path|
                  path.a_move(ab_x.to_i, ab_y.to_i)
                  path.a_line(final_ab_x.to_i, final_ab_y.to_i)
                  path.close
                  path
                end
                anim
              end
              rect
            end
          end
        end
      end
    end
  end
end