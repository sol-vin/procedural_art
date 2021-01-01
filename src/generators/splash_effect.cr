# Inspired by https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e43727eb-d265-4aec-9bbe-b803b3c0a367/splash-svg.html
module ProceduralArt::SplashEffect
  SIZE = 500
  class_property seed = 0

  def self.make
    perlin = PerlinNoise.new(seed &+ 1)

    Celestine.draw do |ctx|

      splash_filter = ctx.filter do |f|
        f.id = "splash-filter"
        f.width = 400
        f.width_units = "%"
        f.height = 400
        f.height_units = "%"
        f.x = -200
        f.x_units = "%"
        f.y = -200
        f.y_units = "%"

        f.flood do |f|
          f.color = "#16B5FF"
          f.result = "splash-color-blue"
          f
        end

        f.flood do |f|
          f.color = "#9800FF"
          f.result = "splash-color-violet"
          f
        end

        f.flood do |f|
          f.color = "#A64DFF"
          f.result = "splash-color-light-violet"
          f
        end

        f.turbulence do |f|
          f.base_freq = 0.05
          f.type = "fractalNoise"
          f.num_octaves = 1
          f.seed = 2
          f.result = "bottom-splash-1"
          f
        end

        f.blur do |f|
          f.input = Celestine::Filter::SOURCE_ALPHA
          f.standard_deviation = 6.5
          f.result = "bottom-splash-2"
          f
        end

        f.displacement_map do |f|
          f.input = "bottom-splash-2"
          f.input2 = "bottom-splash-1"
          f.scale = 420
          f.result = "bottom-splash-3"
          f
        end

        f.composite do |f|
          f.input = "splash-color-blue"
          f.input2 = "bottom-splash-3"
          f.operator = "in"
          f.result = "bottom-splash-4"
          f
        end

        f.turbulence do |f|
          f.base_freq = 0.1
          f.type = "fractalNoise"
          f.num_octaves = 1
          f.seed = 1
          f.result = "middle-splash-1"
          f
        end

        f.blur do |f|
          f.input = Celestine::Filter::SOURCE_ALPHA
          f.standard_deviation = 0.1
          f.result = "middle-splash-2"
          f
        end

        f.displacement_map do |f|
          f.input = "middle-splash-2"
          f.input2 = "middle-splash-1"
          f.scale = 25
          f.result = "middle-splash-3"
          f
        end

        f.composite do |f|
          f.input = "splash-color-light-violet"
          f.input2 = "middle-splash-3"
          f.operator = "in"
          f.result = "middle-splash-4"
          f
        end


        f.turbulence do |f|
          f.base_freq = 0.07
          f.type = "fractalNoise"
          f.num_octaves = 1
          f.seed = 1
          f.result = "top-splash-1"
          f
        end

        f.blur do |f|
          f.input = Celestine::Filter::SOURCE_ALPHA
          f.standard_deviation = 3.5
          f.result = "top-splash-2"
          f
        end

        f.displacement_map do |f|
          f.input = "top-splash-2"
          f.input2 = "top-splash-1"
          f.scale = 220
          f.result = "top-splash-3"
          f
        end

        f.composite do |f|
          f.input = "splash-color-violet"
          f.input2 = "top-splash-3"
          f.operator = "in"
          f.result = "top-splash-4"
          f
        end

        f.merge do |m|
          m.result = "light-effects-1"
          m.add_node "bottom-splash-4"
          m.add_node "middle-splash-4"
          m.add_node "top-splash-4"
          m
        end

        f.color_matrix do |f|
          f.type = "matrix"
          18.times do 
            f.values << 0
          end
          f.values << 1
          f.values << 0

          f.input = "light-effects-1"
          f.result = "light-effects-2"

          f
        end

        f.blur do |f|
          f.input = "light-effects-2"
          f.standard_deviation = 2
          f.result = "light-effects-3"
          f
        end

        f.specular_lighting do |f|
          f.surface_scale = 5
          f.constant = 0.75
          f.exponent = 30
          f.lighting_color = "white"
          f.input = "light-effects-3"
          f.result = "light-effects-4"
          f.add_point_light(-50, -100, 400)
          f
        end

        f.composite do |f|
          f.input = "light-effects-4"
          f.input2 = "light-effects-2"
          f.operator = "in"
          f.result = "light-effects-5"
          f
        end

        f.composite do |f|
          f.input = "light-effects-1"
          f.input2 = "light-effects-5"
          f.k1 = 0
          f.k2 = 1
          f.k3 = 1
          f.k4 = 0
          f.operator = "arithmetic"
          f.result = "light-effects-6"
          f
        end

        f
      end

      ctx.text do |t|
        t.x = 100
        t.y = 120
        t.text = "Hello World!"
        t.fill = "#16B5FF"
        t.color = "#16B5FF"
        t.font_size = 160
        t.font_size_units = "px"
        t.set_filter splash_filter
        t
      end
    end
  end
end