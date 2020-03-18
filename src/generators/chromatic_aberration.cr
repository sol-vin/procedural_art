class Art::Generator::ChromaticAberration
  property width = 1600
  property height = 800

  property smallest_square_size = 8
  property square_size = 60
  property padding = 5

  property colors = ["#FF0000", "#00FF00", "#0000FF"]

  BLEND_TYPE = "difference"

  def initialize(seed, @width = 1600, @height = 800)
    @perlin = PerlinNoise.new(seed)
    @perlin.step = 1.0
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
        p_square_size = ((((@perlin.noise(x, y)+1.0)/2.0) * ((square_size-10)-smallest_square_size)) + smallest_square_size)
        ab_offset = (p_square_size*0.4) - (((@perlin.noise(x, y)+1.0)/2.0) * (p_square_size*0.4))

        p_half_square = p_square_size/2.0

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

          svg << %Q[
            <rect height="#{p_square_size}" width="#{p_square_size}" style="fill:#{color};mix-blend-mode:#{BLEND_TYPE};">
              <animate attributeName="rx" values="0;#{p_square_size/2.0};0" dur="10s" repeatCount="indefinite" />
              <animateMotion dur="5s" repeatCount="indefinite" path="M#{ab_x},#{ab_y} L#{final_ab_x},#{final_ab_y} z" />
            </rect>
        ]
        end
      end
    end

    svg << %Q[</svg>]
    svg.to_s
  end
end
