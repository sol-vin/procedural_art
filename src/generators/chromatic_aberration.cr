class Art::Generator::ChromaticAberration
  property width = 800
  property height = 800

  property square_size = 20
  getter half_square = 0
  property padding = 10

  property colors = ["#FF0000", "#00FF00", "#0000FF"]

  BLEND_TYPE = "difference"

  def initialize(seed, @width = 800, @height = 800)
    @perlin = PerlinNoise.new(seed)
    @half_square = (square_size/2.0).to_i
  end

  def rotate_point(x, y, ox, oy, deg)
    angle = deg * (Math::PI/180)
    rx = Math.cos(angle) * (x - ox) - Math.sin(angle) * (y - oy) + ox
    ry = Math.sin(angle) * (x - ox) + Math.cos(angle) * (y - oy) + oy
    {x: rx, y: ry}
  end


  def next
    svg = String::Builder.new
    svg << %Q[<svg height="#{height}" width="#{width}">]

    svg << %Q[<rect id="background" x="0" y="0" height="#{height}" width="#{width}" style="fill:white"/>]

    (width/(square_size+padding*2)).to_i.times do |x|
      (height/(square_size+padding*2)).to_i.times do |y|
        colors.each_with_index do |color, index|
          
          x_padding = padding + (padding*2*x)
          y_padding = padding + (padding*2*y)
          
          origin_top_x = x * square_size + x_padding
          origin_top_y = y * square_size + y_padding

          origin_mid_point_x = origin_top_x + half_square
          origin_mid_point_y = origin_top_y + half_square

          ab_x_offset = @perlin.int(x, y, -half_square, half_square, x.to_f32*index.to_f32)
          ab_y_offset = @perlin.int(x, y, -half_square, half_square, y.to_f32*index.to_f32)

          ab_x = origin_top_x + ab_x_offset
          ab_y = origin_top_y + ab_y_offset

          ab_mid_point_x = ab_x + half_square
          ab_mid_point_y = ab_y + half_square

          deg = @perlin.int(x, y, index, 120*index, 120 + 120*index)

          rot_ab_mid_point = rotate_point(ab_mid_point_x, ab_mid_point_y, origin_mid_point_x, origin_mid_point_y, deg)
          final_ab_x = rot_ab_mid_point[:x] - half_square
          final_ab_y = rot_ab_mid_point[:y] - half_square

          svg << %Q[<rect x="#{final_ab_x}" y="#{final_ab_y}" height="#{square_size}" width="#{square_size}" style="fill:#{color};mix-blend-mode:#{BLEND_TYPE};"/>]
        end
      end
    end

    svg << %Q[</svg>]
    svg.to_s
  end
end
