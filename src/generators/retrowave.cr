module ProceduralArt::Retrowave
  WIDTH              = 1200
  HEIGHT             =  800
  BG_GRADIENT_OFFSET =  250
  SUN_RADIUS         =  150
  SUN_OFFSET         =  200

  SUN_WAVE_TIME          = 20
  SUN_WAVES              =  8
  SUN_WAVE_TIME_FRACTION = SUN_WAVE_TIME/SUN_WAVES

  SUN_WAVE_POSITION_FRACTION = SUN_RADIUS / SUN_WAVES

  GRID_VERTICAL_LINES = 3
  GRID_ANGLE_DIMINISH = 1.25

  GRID_HORIZONTAL_LINES = 8
  GRID_MOVE_TIME = 20
  GRID_MOVE_TIME_FRACTION = GRID_MOVE_TIME/GRID_HORIZONTAL_LINES
  GRID_HORIZONTAL_POSITION_FRACTION = SUN_RADIUS / SUN_WAVES


  class_property seed : Int32 = 1

  def self.make
    perlin = PerlinNoise.new(@@seed)

    Celestine.draw do |ctx|
      ctx.width = 100
      ctx.width_units = "%"
      ctx.height = 100
      ctx.height_units = "%"
      ctx.view_box = {x: 0, y: 0, w: WIDTH, h: HEIGHT}

      # Make the bg-fill radial gradient
      bg_gradient = ctx.radial_gradient do |g|
        g.id = "bg-gradient"
        g.stop do |stop|
          stop.offset = 7
          stop.offset_units = "%"
          stop.color = "#dff9f9"
          stop
        end

        g.stop do |stop|
          stop.offset = 10
          stop.offset_units = "%"
          stop.color = "#94efed"
          stop
        end

        g.stop do |stop|
          stop.offset = 20
          stop.offset_units = "%"
          stop.color = "#4084c8"
          stop
        end

        g.stop do |stop|
          stop.offset = 50
          stop.offset_units = "%"
          stop.color = "#5b297e"
          stop
        end

        g.stop do |stop|
          stop.offset = 100
          stop.offset_units = "%"
          stop.color = "#14041f"
          stop
        end
        g
      end

      # Draw bg rectangle
      ctx.rectangle do |bg_rect|
        bg_rect.x = -BG_GRADIENT_OFFSET
        bg_rect.y = -BG_GRADIENT_OFFSET
        bg_rect.width = WIDTH + BG_GRADIENT_OFFSET*2
        bg_rect.height = HEIGHT + BG_GRADIENT_OFFSET*2
        bg_rect.set_fill bg_gradient
        bg_rect
      end

      # Floor rectangle
      ctx.rectangle do |floor_rect|
        floor_rect.x = 0
        floor_rect.y = HEIGHT/2.0
        floor_rect.width = WIDTH
        floor_rect.height = HEIGHT/2.0
        floor_rect.fill = "#1c1829"
        floor_rect
      end

      # Draw first half of lines
      vertical_grid_lines = ctx.group do |group|
        group.id = "vertical-grid-lines"
        ((GRID_VERTICAL_LINES*2)).times do |line_num|
          group.path do |path|
            path.a_move(WIDTH/2.0, HEIGHT/2.0)
            if line_num == 0
              path.a_line(WIDTH/2.0, HEIGHT)
            else
              x = line_num
              angle = 0
              angle_fraction = 90.0 / GRID_VERTICAL_LINES
              diminished_angle = angle_fraction
              while x > 0
                diminished_angle /= GRID_ANGLE_DIMINISH
                angle += diminished_angle
                x -= 1
              end
              point = Celestine::FPoint.new(WIDTH/2.0, HEIGHT*5) 
              rp = Celestine::Math.rotate_point(point, Celestine::FPoint.new(WIDTH/2.0, HEIGHT/2.0), angle)
              path.a_line(rp.x, rp.y)
            end
            path.stroke_width = 2.5 * ((GRID_VERTICAL_LINES*2) - line_num)/(GRID_VERTICAL_LINES*2)
            path.stroke = "white"
            path
          end
        end
        group
      end

      ctx.use(vertical_grid_lines) do |use|
        use.transform do |t|
          t.scale(-1, 1)
          t.translate(-WIDTH, 0)
          t
        end
        use
      end

      horizontal_grid_lines = ctx.group do |group|
        group
      end

      # Sun
      ctx.group do |sun_group|
        # Sun gradient
        sun_gradient = ctx.linear_gradient do |g|
          g.id = "sun-gradient"

          g.gradient_transform { |t| t.rotate(90, 0, 0); t }
          g.stop do |stop|
            stop.offset = 10
            stop.offset_units = "%"
            stop.color = "yellow"
            stop
          end

          g.stop do |stop|
            stop.offset = 25
            stop.offset_units = "%"
            stop.color = "orange"
            stop
          end

          g.stop do |stop|
            stop.offset = 66
            stop.offset_units = "%"
            stop.color = "red"
            stop
          end
          g
        end

        sun_wave_mask = ctx.mask do |mask|
          mask.id = "sun-mask"
          mask.rectangle do |r|
            r.x = 0
            r.y = 0
            r.width = WIDTH
            r.height = HEIGHT
            r.fill = "white"
            r
          end

          SUN_WAVES.times do |wave_level|
            mask.rectangle do |r|
              r.fill = "black"
              r.x = 0
              r.width = WIDTH

              r.animate do |anim_y|
                anim_y.attribute = "y"
                anim_y.from = HEIGHT/2.0 - SUN_OFFSET + SUN_RADIUS - (SUN_WAVE_POSITION_FRACTION * wave_level)
                anim_y.to = HEIGHT/2.0 - SUN_OFFSET + SUN_RADIUS - (SUN_WAVE_POSITION_FRACTION * (wave_level + 1))
                anim_y.duration = SUN_WAVE_TIME_FRACTION
                anim_y.repeat_count = "indefinite"
                anim_y
              end

              r.animate do |anim_y|
                anim_y.attribute = "height"
                anim_y.from = SUN_WAVE_POSITION_FRACTION * (SUN_WAVES - wave_level)/SUN_WAVES
                anim_y.to = SUN_WAVE_POSITION_FRACTION * (SUN_WAVES - wave_level - 1)/SUN_WAVES
                anim_y.duration = SUN_WAVE_TIME_FRACTION
                anim_y.repeat_count = "indefinite"
                anim_y
              end
              r
            end
          end

          mask
        end

        sun_wave_filter = ctx.filter do |f|
          f.id = "sun-filter"
          f.x = -1000
          f.y = -1000
          f.width = 1500
          f.height = 1001

          f.blur do |b|
            b.edge_mode = "none"
            b.standard_deviation = 5
            b.input = Celestine::Filter::SOURCE_GRAPHIC
            b.result = "sun-blur"
            b
          end

          f.merge do |m|
            m.add_node("sun-blur")
            m.add_node(Celestine::Filter::SOURCE_GRAPHIC)
            m.result = "sun-filter-result"
            m
          end

          f
        end

        # Sun
        sun_group.circle do |c|
          c.set_filter sun_wave_filter
          c.set_fill sun_gradient
          c.x = WIDTH/2.0
          c.y = HEIGHT/2.0 - SUN_OFFSET
          c.radius = SUN_RADIUS
          c.set_mask sun_wave_mask
          c
        end

        sun_group
      end

      # ctx.path do |path|
      #   path.a_move(0, (HEIGHT/2.0) + 1)
      #   path.a_line(0, (HEIGHT/2.0) - perlin.int(0, min: 20, max: 200))
      #   (100).times do |x|
      #     path.a_line(x * (WIDTH/100.0), (HEIGHT/2.0) - perlin.int(x, min: 20, max: 200))
      #   end
      #   path.a_line(WIDTH, (HEIGHT/2.0) + 1)
      #   path.close
      #   path.fill = "#1c1829"
      #   path
      # end
    end
  end
end
