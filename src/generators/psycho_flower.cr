# Inspired by https://www.openprocessing.org/sketch/941217
module ProceduralArt::PsychoFlower
  SCREEN_SIZE = 500

  MIN_CIRCLE_SIZE = 10
  MAX_CIRCLE_SIZE = 20

  def self.make
    Celestine.draw do |ctx|
      ctx.view_box = {x: 0, y: 0, w: SCREEN_SIZE, h: SCREEN_SIZE}

      circles_count = (SCREEN_SIZE/(MIN_CIRCLE_SIZE*2)).to_i
      middle = ((SCREEN_SIZE/(MIN_CIRCLE_SIZE*2))/2.0).ceil.to_i
      (circles_count + 1).times do |y|
        circles_count.times do |x|
          ctx.circle do |circle|
            circle.id = "circle-#{x}-#{y}"
            circle.y = y * (MIN_CIRCLE_SIZE*2) - (y * MIN_CIRCLE_SIZE*0.2)
            circle.x = (y.odd? ? x * (MIN_CIRCLE_SIZE*2) : MIN_CIRCLE_SIZE + (x * (MIN_CIRCLE_SIZE*2)))
            circle.stroke_width = 3
            circle.fill = "none"

            circle.animate do |a|
              a.attribute = Celestine::Circle::Attrs::RADIUS
              a.values << MIN_CIRCLE_SIZE.to_f64
              a.values << MIN_CIRCLE_SIZE.to_f64
              a.values << MAX_CIRCLE_SIZE.to_f64
              a.values << MIN_CIRCLE_SIZE.to_f64
              a.values << MIN_CIRCLE_SIZE.to_f64

              # Get distance
              middle_x = (middle.odd? ? middle * (MIN_CIRCLE_SIZE*2) : MIN_CIRCLE_SIZE + (middle * (MIN_CIRCLE_SIZE*2)))
              middle_y = (middle * (MIN_CIRCLE_SIZE*2) - (middle * MIN_CIRCLE_SIZE*0.2))
              distance = Math.sqrt((middle_x - circle.x.as(Number))**2 + (middle_y - circle.y.as(Number))**2).floor
              
              a.key_times << 0.0
              start_time = (distance/SCREEN_SIZE) * 0.5
              a.key_times << start_time
              a.key_times << start_time + 0.3
              a.key_times << start_time + 0.4
              a.key_times << 1.0

              # ctx.text do |t|
              #   t.text = distance.to_s
              #   t.x = circle.x.as(Number)-5
              #   t.y = circle.y
              #   t.font_size = 5
              #   t.font_size_units = "px"
              #   t
              # end


              a.duration = 5
              a.duration_units = "s"
              a.repeat_count = "indefinite"
              a
            end

            circle.animate do |a|
              a.attribute = Celestine::Circle::Attrs::STROKE

              # Get distance
              middle_x = (middle.odd? ? middle * (MIN_CIRCLE_SIZE*2) : MIN_CIRCLE_SIZE + (middle * (MIN_CIRCLE_SIZE*2)))
              middle_y = (middle * (MIN_CIRCLE_SIZE*2) - (middle * MIN_CIRCLE_SIZE*0.2))
              distance = Math.sqrt((middle_x - circle.x.as(Number))**2 + (middle_y - circle.y.as(Number))**2).floor

              colors = ["#ff0000", "#ff4f00", "#ff6f00", 
                        "#fecf00", "#feff00", "#94ff00", 
                        "#45ff00", "#1fff7e", "#00ffe2", 
                        "#00baf1", "#0075ff", "#0b3bff", 
                        "#0f21ff", "#1500ff", "#4d00ff", 
                        "#8400ff", "#b100ff", "#ff00fe", 
                        "#ff0095", "#ff0068", "#ff0000"]  
              color_shift = ((distance/SCREEN_SIZE) * 12).floor.to_i

              color_shift.times do 
                color = colors.pop
                colors.unshift color
              end

              colors.each do |color|
                a.values << color
              end


              a.duration = 5
              a.duration_units = "s"
              a.repeat_count = "indefinite"
              a
            end

            circle.animate do |a|
              a.attribute = Celestine::Circle::Attrs::STROKE_OPACITY
              a.values << 0.3
              a.values << 0.3
              a.values << 0.6
              a.values << 0.3
              a.values << 0.3

              # Get distance
              middle_x = (middle.odd? ? middle * (MIN_CIRCLE_SIZE*2) : MIN_CIRCLE_SIZE + (middle * (MIN_CIRCLE_SIZE*2)))
              middle_y = (middle * (MIN_CIRCLE_SIZE*2) - (middle * MIN_CIRCLE_SIZE*0.2))
              distance = Math.sqrt((middle_x - circle.x.as(Number))**2 + (middle_y - circle.y.as(Number))**2).floor
              
              a.key_times << 0.0
              start_time = (distance/SCREEN_SIZE) * 0.5
              a.key_times << start_time
              a.key_times << start_time + 0.3
              a.key_times << start_time + 0.4
              a.key_times << 1.0

              # ctx.text do |t|
              #   t.text = distance.to_s
              #   t.x = circle.x.as(Number)-5
              #   t.y = circle.y
              #   t.font_size = 5
              #   t.font_size_units = "px"
              #   t
              # end


              a.duration = 5
              a.duration_units = "s"
              a.repeat_count = "indefinite"
              a
            end

            circle
          end
        end
      end
    end
  end
end
