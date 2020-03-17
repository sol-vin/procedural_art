class Art::Generator::Inward
  COLOR_PALETTES = {
    "substantial" => ["#154148", "#64c5c3", "#e7b576", "#fe8f22"],
    "business" => ["#222831", "#393e46", "#00adb5", "#eeeeee"],
    "vibrant_sunset" => ["#f9ed69", "#f08a5d", "#b83b5e", "#6a2c70"],
    "faded_desert" => ["#f38181", "#fce38a", "#eaffd0", "#95e1d3"],
    "sleek_contrast" => ["#252a34", "#08d9d6", "#ff2e63", "#eaeaea"],
    "bomb_pop" => ["#364f6b", "#3fc1c9", "#f5f5f5", "#fc5185"],
    "easter_pastel" => ["#a8d8ea", "#aa96da", "#fcbad3", "#ffffd2"],
    "misty_morning" => ["#e3fdfd", "#cbf1f5", "#a6e3e9", "#71c9ce"],
    "future_vision" => ["#e4f9f5", "#30e3ca", "#11999e", "#40514e"],
    "pass_out" => ["#f9f7f7", "#cbf1f5", "#a6e3e9", "#71c9ce"],
    "red_river" => ["#2b2e4a", "#e84545", "#903749", "#53354a"],
    "retro_ideas" => ["#00b8a9", "#f8f3d4", "#f6416c", "#ffde7d"],
    "deep_sea" => ["#48466d", "#3d84a8", "#46cdcf", "#abedd8"],
    "trout" => ["#ffb6b9", "#fae3d9", "#bbded6", "#61c0bf"],
    "mystic_red" => ["#e23e57", "#88304e", "#522546", "#311d3f"],
    "child_like" => ["#ffcfdf", "#fefdca", "#e0f9b5", "#a5dee5"],
    "mystic_diamond" => ["#212121", "#323232", "#0d7377", "#14ffec"],
    "lost_mystery" => ["#a8e6cf", "#dcedc1", "#ffd3b6", "#ffaaa5"],
    "purple_pastel" => ["#defcf9", "#cadefc", "#c3bef0", "#cca8e9"],
    "endless_red" => ["#f67280", "#c06c84", "#6c5b7b", "#355c7d"],
    "salmon_stingray" => ["#ffc8c8", "#ff9999", "#6c5b7b", "#355c7d"],
    "alaskan_salmon" => ["#ffc8c8", "#ff9999", "#444f5a", "#3e4149"],
    "ideas" => ["#3ec1d3", "#f6f7d7", "#ff9a00", "#ff165d"],
    "twilight_sunset" => ["#2d4059", "#ea5455", "#f07b3f", "#ffd460"],
    "oceans_heart" => ["#6fe7dd", "#3490de", "#6639a6", "#521262"],
    "asimov" => ["#303841", "#00adb5", "#eeeeee", "#ff5722"],
    "seafarer" => ["#384259", "#f73859", "#7ac7c4", "#c4edde"],
    "negatron" => ["#f0f5f9", "#c9d6df", "#52616b", "#1e2022"],
    "firework" => ["#f85f73", "#fbe8d3", "#928a97", "#283c63"],
    "cream_ale" => ["#07689f", "#a2d5f2", "#fafafa", "#ff7e67"],
  } 

  TYPES = ("a".."g")

  property width = 200
  property height = 100
  property tri_size = 8

  def initialize(seed, @width = 200, @height = 100, @tri_size = 8)
    @perlin = PerlinNoise.new(seed)
  end

  def next
    colors = COLOR_PALETTES[color_name = @perlin.prng_item(2010, 2034, COLOR_PALETTES.keys)].clone
    bg_color = @perlin.prng_item(2211, 2234, colors)
    colors.delete bg_color

    svg = String::Builder.new
    svg << %Q[<svg height="#{height*tri_size}" width="#{width*tri_size}">]
    svg << %Q[<rect x="0" y="0" height="#{height*tri_size}" width="#{width*tri_size}" style="fill:#{bg_color}"/>]
    
    g_type = @perlin.prng_item(3010, 3010, TYPES.to_a)
    puts "using type #{g_type} with #{color_name}"
    
    d_tri_size = tri_size

    5.times do |g|
      (width/(2**g)/2.0).floor.to_i.times do |x|
        (height/(2**g)/2.0).floor.to_i.times do |y|
          x_com = x
          y_com = y
          chance = 0
          color = "#ffffff"
          case g_type

          when "a"
            x_com = (x & y)
            y_com = (y & x)
            chance = @perlin.prng_int(x_com, y_com, 2, 20)
            color = @perlin.prng_item(x_com + g, y_com + g, colors)
          when "b"
            x_com = (x | y)
            y_com = (y | x)
            chance = @perlin.prng_int(x_com, y_com, 2, 20)
            color = @perlin.prng_item(x_com + g, y_com, colors)
          when "c"
            x_com = (x ^ y)
            y_com = (y ^ x)
            chance = @perlin.prng_int(x_com, y_com, 2, 20)
            color = @perlin.item(x_com + g, y_com, colors)
          when "d"
            x_com = (x << y)
            y_com = (y << x)
            chance = @perlin.int(x_com, y_com, 2, 20)
            color = @perlin.item(x_com + g, y_com + g, colors)
          when "e"
            x_com = (x >> y)
            y_com = (y >> x)
            chance = 1 + g
            color = @perlin.prng_item(x_com + g, y_com, colors)
          when "f"
            x_com = (x << y)
            y_com = (y >> x)
            chance = @perlin.prng_int(x_com, y_com, 2, 8)
            color = @perlin.prng_item(x_com + g, y_com + g, colors)
          when "g"
            x_com = (x << y)
            y_com = (y >> x)
            chance = @perlin.prng_int(x_com, y_com, 2, 8)
            color = @perlin.prng_item(x_com, y_com, colors)
          end

          if chance == 1 || @perlin.prng_int(x_com, y_com, 0, chance, 0.1234) == 0
            offset = 0

            origin_x = x * d_tri_size + offset
            origin_y = y * d_tri_size + offset

            left_x = origin_x - d_tri_size
            right_x = origin_x + d_tri_size

            up_y = origin_y - d_tri_size
            down_y = origin_y + d_tri_size

            mirror_origin_x = (width/(2**g) - x) * d_tri_size + offset
            mirror_origin_y = (height/(2**g) - y) * d_tri_size + offset

            mirror_left_x = mirror_origin_x - d_tri_size
            mirror_right_x = mirror_origin_x + d_tri_size

            mirror_up_y = mirror_origin_y - d_tri_size
            mirror_down_y = mirror_origin_y + d_tri_size

            a1x = origin_x
            a1y = origin_y
            a2x = origin_x
            a2y = up_y
            a3x = left_x
            a3y = origin_y
            svg << %Q[<polygon points="#{a1x},#{a1y} #{a2x},#{a2y} #{a3x},#{a3y}" style="fill:#{color};stroke-width:0"/>]

            b1x = mirror_origin_x 
            b1y = origin_y  
            b2x = mirror_origin_x 
            b2y = up_y  
            b3x = mirror_right_x 
            b3y = origin_y
            svg << %Q[<polygon points="#{b1x},#{b1y} #{b2x},#{b2y} #{b3x},#{b3y}" style="fill:#{color};stroke-width:0"/>]

            c1x = mirror_origin_x 
            c1y = mirror_origin_y  
            c2x = mirror_origin_x 
            c2y = mirror_down_y  
            c3x = mirror_right_x 
            c3y = mirror_origin_y  
            svg << %Q[<polygon points="#{c1x},#{c1y} #{c2x},#{c2y} #{c3x},#{c3y}" style="fill:#{color};stroke-width:0"/>]

            d1x = origin_x
            d1y = mirror_origin_y 
            d2x = origin_x
            d2y = mirror_down_y 
            d3x = left_x
            d3y = mirror_origin_y 
            svg << %Q[<polygon points="#{d1x},#{d1y} #{d2x},#{d2y} #{d3x},#{d3y}" style="fill:#{color};stroke-width:0"/>]
          end
        end
      end
      d_tri_size *= 2
    end
    svg << %Q[</svg>]
    svg.to_s
  end
end
