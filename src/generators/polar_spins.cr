# Inspired by https://www.openprocessing.org/sketch/941217
module ProceduralArt::PolarSpins
  SCREEN_SIZE = 500

  class_property seed = 1

  ARC_THICKNESS = 10
  ARC_STEP = 2
  MIN_ARC_SIZE = 0.4
  MAX_ARC_SIZE = 0.8

  private def self.make_arc(start_angle, end_angle, distance, thickness = ARC_THICKNESS, large = false, flip = false)
    p1 = Celestine::FPoint.new(0 + 250, distance + 250)
    p2 = Celestine::FPoint.new(0 + 250, distance + thickness + 250)

    p1_t1 = Celestine::Math.rotate_point(p1.x, p1.y, SCREEN_SIZE/2.0, SCREEN_SIZE/2.0, start_angle)
    p2_t1 = Celestine::Math.rotate_point(p2.x, p2.y, SCREEN_SIZE/2.0, SCREEN_SIZE/2.0, end_angle)


    path = Celestine::Path.new
    path.a_move(p1_t1.x, p1_t1.y)

    current_p1_angle = start_angle
    while current_p1_angle <= end_angle
      current_p1_angle = end_angle if current_p1_angle > end_angle
      p1_r1 = Celestine::Math.rotate_point(p1.x, p1.y, SCREEN_SIZE/2.0, SCREEN_SIZE/2.0, current_p1_angle)
      path.a_line(p1_r1.x, p1_r1.y)
      current_p1_angle += ARC_STEP
    end
    path.a_line(p2_t1.x, p2_t1.y)

    current_p2_angle = end_angle
    while current_p2_angle >= start_angle
      current_p2_angle = start_angle if current_p2_angle < start_angle
      p2_r1 = Celestine::Math.rotate_point(p2.x, p2.y, SCREEN_SIZE/2.0, SCREEN_SIZE/2.0, current_p2_angle)
      path.a_line(p2_r1.x, p2_r1.y)
      current_p2_angle -= ARC_STEP
    end

    path.close

    path
  end

  def self.make
    perlin = PerlinNoise.new(seed)

    Celestine.draw do |ctx|
      ctx.view_box = {x: 0, y: 0, w: SCREEN_SIZE, h: SCREEN_SIZE}

      ctx.rectangle do |r|
        r.id = "bg-rect"
        r.x = r.y = 0
        r.width = r.height = SCREEN_SIZE
        r.fill = "black"
        r
      end

      anim_t_cw = Celestine::Animate::Transform::Rotate.new

      anim_t_cw.from_origin_x = anim_t_cw.from_origin_y = anim_t_cw.to_origin_x = anim_t_cw.to_origin_y = 250
      anim_t_cw.from_angle = 0
      anim_t_cw.to_angle = 360
      anim_t_cw.use_from = true
      anim_t_cw.use_to = true

      anim_t_cw.duration_units = "s"
      anim_t_cw.repeat_count = "indefinite"

      
      anim_t_ccw = Celestine::Animate::Transform::Rotate.new

      anim_t_ccw.from_origin_x = anim_t_ccw.from_origin_y = anim_t_ccw.to_origin_x = anim_t_ccw.to_origin_y = 250
      anim_t_ccw.from_angle = 360
      anim_t_ccw.to_angle = 0
      anim_t_ccw.use_from = true
      anim_t_ccw.use_to = true

      anim_t_ccw.duration_units = "s"
      anim_t_ccw.repeat_count = "indefinite"

      current_distance = 20
      ring_number = 0
      while current_distance < SCREEN_SIZE
        if perlin.prng_int(777+current_distance.to_i, 0, 4) != 0
          arc_start_angle = perlin.prng_int(current_distance.to_i + 33, 0, 360)
          arc_end_angle = arc_start_angle + perlin.prng_int(-current_distance.to_i + 33, (360 * MIN_ARC_SIZE).to_i, (360 * MAX_ARC_SIZE).to_i)

          path = make_arc(arc_start_angle, arc_end_angle, current_distance, thickness: ARC_THICKNESS/2.0)
          path.opacity = 0.5
          if ring_number.odd?
            path.fill = "white"
          else
            path.fill = perlin.prng_item(6534+ring_number, ["#264653", "#2A9D8F", "#E9C46A", "#F4A261", "#E76F51"])
          end
          
          if perlin.prng_int(786+current_distance.to_i, 0, 2) != 0
            anim_t_cw.duration = perlin.prng_int(arc_end_angle + 999, 1 + (200*(current_distance/SCREEN_SIZE)).to_i, 20 + (250*(current_distance/SCREEN_SIZE)).to_i)
            anim_t_cw.draw(path.inner_elements)
          else
            anim_t_ccw.duration = perlin.prng_int(arc_end_angle + 999, 5, 20)
            anim_t_ccw.draw(path.inner_elements)
          end
          ctx << path
        end

        current_distance += ARC_THICKNESS/2
        ring_number += 1
      end

      current_distance = 20
      ring_number = 0
      while current_distance < SCREEN_SIZE
        if perlin.prng_int(9999+current_distance.to_i, 0, 4) != 0
          arc_start_angle = perlin.prng_int(current_distance.to_i, 0, 360)
          arc_end_angle = arc_start_angle + perlin.prng_int(-current_distance.to_i, (360 * MIN_ARC_SIZE).to_i, (360 * MAX_ARC_SIZE).to_i)

          path = make_arc(arc_start_angle, arc_end_angle, current_distance)
          if ring_number.odd?
            path.fill = "white"
          else
            path.fill = perlin.prng_item(4321+ring_number, ["#264653", "#2A9D8F", "#E9C46A", "#F4A261", "#E76F51"])
          end

          if perlin.prng_int(1234+current_distance.to_i, 0, 2) != 0
            anim_t_cw.duration = perlin.prng_int(arc_end_angle, 1 + (200*(current_distance/SCREEN_SIZE)).to_i, 20 + (250*(current_distance/SCREEN_SIZE)).to_i)
            anim_t_cw.draw(path.inner_elements)
          else
            anim_t_ccw.duration = perlin.prng_int(arc_end_angle, 5, 20)
            anim_t_ccw.draw(path.inner_elements)
          end
          ctx << path
        end

        current_distance += ARC_THICKNESS
        ring_number += 1
      end
    end
  end
end
