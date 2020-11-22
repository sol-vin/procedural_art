# Inspired by https://www.openprocessing.org/sketch/566168
module Art::Hypnos
  SIZE = 500
  SIDES = [0, 3, 4, 5, 6, 7, 8]
  FG_MASK_SHAPE_ID = "fg-mask-shape"
  BG_MASK_SHAPE_ID = "bg-mask-shape"

  FG_MASK_OUTER_ID = "fg-mask-outer"
  BG_MASK_OUTER_ID = "bg-mask-outer"

  FG_MASK_RADIUS = 140.0

  MAX_STROKE_WIDTH = 5
  CIRCLE_SPACING = 10
  MAX_CIRCLE_SIZE = FG_MASK_RADIUS + (CIRCLE_SPACING * 2)

  class_property seed = 0

  @@perlin = PerlinNoise.new(1000)

  def self.make
    sides = @@perlin.prng_item(@@seed+20, 10, SIDES, 4.2)

    Celestine.draw do |ctx|
      ctx.view_box = {x: 0, y: 0, w: 500, h: 500}
      ctx.width = 50.percent
      ctx.height = 50.percent

      # Draw BG
      ctx.rectangle do |r|
        r.id = "bg"
        r.x = 0
        r.y = 0
        r.width = 500
        r.height = 500
        r.fill = "white"
        r.stroke = "none"
        r
      end

      bg_mask_shape = ctx.rectangle(define: true) do |r|
        r.id = BG_MASK_SHAPE_ID
        r.x = 0
        r.y = 0
        r.width = 500
        r.height = 500
        r.fill = "black"
        r.stroke = "none"
        r
      end



      fg_mask_shape = if sides == 0
        ctx.circle(define: true) do |c|
          c.id = FG_MASK_SHAPE_ID
          c.x = SIZE/2
          c.y = c.x
          c.radius = FG_MASK_RADIUS
          c.fill = "white"

          c
        end
      else
        ctx.path(define: true) do |path|
          path.id = FG_MASK_SHAPE_ID

          path.fill = "white"
          path.a_move(0, FG_MASK_RADIUS)

          sides.times do |x|
            point = Celestine::FPoint.new(0, FG_MASK_RADIUS)
            deg_inc = 360.to_f/sides
            rp = Celestine::Math.rotate_point(point, Celestine::FPoint::ZERO, deg_inc*x)
            path.a_line(rp.x.floor, rp.y.floor)
          end

          path.transform do |t|
            t.translate(250, 250)
            t
          end

          path
        end
      end

      bg_mask_outer = ctx.rectangle(define: true) do |r|
        r.id = BG_MASK_OUTER_ID
        r.x = 0
        r.y = 0
        r.width = 500
        r.height = 500
        r.fill = "white"
        r.stroke = "none"
        r
      end

      
      fg_mask_outer = if sides == 0
        ctx.circle(define: true) do |c|
          c.id = FG_MASK_OUTER_ID
          c.x = SIZE/2
          c.y = c.x
          c.radius = FG_MASK_RADIUS
          c.fill = "black"

          c
        end
      else
        ctx.path(define: true) do |path|
          path.id = FG_MASK_OUTER_ID

          path.fill = "black"
          path.a_move(0, FG_MASK_RADIUS)

          sides.times do |x|
            point = Celestine::FPoint.new(0, FG_MASK_RADIUS)
            deg_inc = 360.to_f/sides
            rp = Celestine::Math.rotate_point(point, Celestine::FPoint::ZERO, deg_inc*x)
            path.a_line(rp.x.floor, rp.y.floor)
          end

          path.transform do |t|
            t.translate(250, 250)
            t
          end

          path
        end
      end

      fg_mask = ctx.mask do |mask|
        mask.id = "fg-mask"
        mask.use bg_mask_shape
        mask.use(fg_mask_shape) do |u|
          u.animate_transform do |anim|
            anim.type = "rotate"
            anim.from = "0 250 250"
            anim.to = "360 250 250"
            anim.duration = "10s"
            anim.repeat_count = "indefinite"
            anim
          end
          u
        end
        mask
      end

      bg_mask = ctx.mask do |mask|
        mask.id = "bg-mask"
        mask.use bg_mask_outer
        mask.use(fg_mask_outer) do |u|
          u.animate_transform do |anim|
            anim.type = "rotate"
            anim.from = "0 250 250"
            anim.to = "360 250 250"
            anim.duration = "10s"
            anim.repeat_count = "indefinite"
            anim
          end
          u
        end
        mask
      end

      # Inner concentric circles
      ctx.group do |group|
        group.id = "concentric-circles"
        group.set_mask fg_mask
        
        (MAX_CIRCLE_SIZE / CIRCLE_SPACING.to_f).to_i.times do |x|
          circle = Celestine::Circle.new
          circle.stroke = "black"
          circle.fill = "none"
          circle.x = circle.y = SIZE/2
          if x.zero?
            circle.animate do |anim|
              anim.attribute = Celestine::Circle::Attrs::STROKE_WIDTH
              anim.duration = "5s"
              anim.values = [0, MAX_STROKE_WIDTH.px, MAX_STROKE_WIDTH.px] of SIFNumber
              anim.repeat_count = "indefinite"
              anim
            end

            circle.animate do |anim|
              anim.attribute = Celestine::Circle::Attrs::RADIUS
              anim.duration = "5s"
              anim.from = 0
              anim.to = 10.px
              anim.repeat_count = "indefinite"
              anim
            end

            group << circle

            circle2 = Celestine::Circle.new
            circle2.stroke_width = MAX_STROKE_WIDTH.px
            circle2.stroke = "red"
            circle2.fill = "none"
            circle2.x = circle2.y = SIZE/2
            circle2.animate do |anim|
              anim.attribute = Celestine::Circle::Attrs::RADIUS
              anim.duration = "5s"
              anim.from = 0
              anim.to = CIRCLE_SPACING
              anim.repeat_count = "indefinite"
              anim
            end
          else
            circle.stroke_width = MAX_STROKE_WIDTH.px

            circle.animate do |anim|
              anim.attribute = Celestine::Circle::Attrs::RADIUS
              anim.duration = "5s"
              anim.from = x * CIRCLE_SPACING
              anim.to = (x+1) * CIRCLE_SPACING
              anim.repeat_count = "indefinite"
              anim
            end
          end
          group << circle
        end
        group
      end

      # Outer lines
      ctx.group do |group|
        group.id = "outer-lines"
        group.set_mask bg_mask


        50.times do |x|
          point = Celestine::FPoint.new(0, 500)
          deg_inc = 360.to_f/50
          rp = Celestine::Math.rotate_point(point, Celestine::FPoint::ZERO, deg_inc*x)
          group.path do |path|
            path.id = "raypath-#{x}"
            path.stroke = "black"
            path.stroke_width = 3.px
            path.fill = "none"
            path.a_move(250, 250)
            path.r_line(rp.x.floor, rp.y.floor)
            a = [] of SIFNumber
            20.times do
              path.dash_array << rand(50) + 5 
              path.dash_array << rand(10) + 5
            end
            path.line_cap = "round"

            path.animate do |anim|
              anim.attribute = "stroke-dashoffset"
              random_offset = rand(100)
              anim.from = random_offset
              anim.to =  100000 + random_offset
              anim.duration = "10000s"
              anim.repeat_count = "indefinite"
              anim
            end
            path
          end
        end

        group
      end
    end
  end
end