# Adapted from https://www.openprocessing.org/sketch/510598
module ProceduralArt::SemiCirclePatchwork
  COLORS = [
    ["#e2f1af", "#e3d888", "#84714f", "#5a3a31", "#31231e"],
    ["#ddf3b5", "#83c923", "#74a31d", "#577a15", "#39510e"],
    ["#ecfee8", "#c2efeb", "#6ea4bf", "#41337a", "#331e36"],
    ["#f0f3bd", "#02c39a", "#00a896", "#028090", "#06668d"],
    ["#ffcdB2", "#ffb4a2", "#e5989b", "#b5838d", "#6d6875"],
    ["#6fffe9", "#5bc0be", "#3a506b", "#1c2541", "#0b132b"],
    ["#d8dbe2", "#a9bcd0", "#58a4b0", "#373f51", "#1b1b1e"],
    ["#f6aa1c", "#bc3908", "#941b0c", "#621708", "#220901"],
    ["#e0fbfc", "#c2dfe3", "#9db4c0", "#5c6b73", "#253237"],
    ["#9742a1", "#7c3085", "#611f69", "#4a154b", "#340f34"],
    ["#c4fff9", "#9ceaef", "#68d8d6", "#3dccc7", "#07beb8"],
    ["#ffffff", "#5bc0be", "#3a506b", "#1c2541", "#0b132b"],
    ["#ff9b54", "#ff7f51", "#ce4257", "#720026", "#4f000b"],
    ["#edeec9", "#dde7c7", "#bfd8bd", "#98c9a3", "#77bfa3"],
    ["#b8f3ff", "#8ac6d0", "#63768d", "#554971", "#36213e"],
    ["#f0ebd8", "#748cab", "#3e5c76", "#1d2d44", "#0d1321"],
    ["#f9dbbd", "#ffa5ab", "#da627d", "#a53860", "#450920"],
    ["#e09f7d", "#ef5d60", "#ec4067", "#a01a7d", "#311847"],
    ["#53b3cb", "#f9c22e", "#f15946", "#e01a4f", "#0c090d"],
    ["#fefcfb", "#1282a2", "#034078", "#001f54", "#0a1128"],
    ["#e0d68a", "#cb9173", "#8e443d", "#511730", "#320a28"],
    ["#f3c677", "#f9564f", "#b33f62", "#7b1e7a", "#0c0a3e"],
    ["#efd9ce", "#dec0f1", "#b79ced", "#957fef", "#7161ef"],
    ["#f0f465", "#9cec5b", "#50c5b7", "#6184db", "#533a71"],
    ["#ad2831", "#800e13", "#640d14", "#38040e", "#250902"],
  ]

  class_property seed = 1

  SCREEN_WIDTH = 500
  SCREEN_HEIGHT = 500

  CELL_SIZE = 20
  PADDING = 0.1_f64
  SEMI_PADDING = 0.05_f64

  def self.make
    perlin = PerlinNoise.new(seed)
    colors = perlin.prng_item(100, COLORS, 4.2)

    Celestine.draw do |ctx|
      ctx.view_box = {x: 0, y: 0, w: SCREEN_WIDTH/2, h: SCREEN_HEIGHT/2}

      semicircle_left = ctx.path(define: true) do |path|
        path.id = "semicircle-l"
        path.a_move(-SEMI_PADDING, -SEMI_PADDING)
        path.a_line(-SEMI_PADDING, CELL_SIZE+SEMI_PADDING)
        path.a_arc(x: 0, y: 0, rx: 1, ry: 1)
        path.close
        
        path
      end

      semicircle_right = ctx.path(define: true) do |path|
        path.id = "semicircle-r"
        path.a_move(CELL_SIZE+SEMI_PADDING, -SEMI_PADDING)
        path.a_line(CELL_SIZE+SEMI_PADDING, CELL_SIZE+SEMI_PADDING)
        path.a_arc(x: CELL_SIZE+SEMI_PADDING, y: -SEMI_PADDING , rx: 1, ry: 1, flip: true)
        path.close

        path
      end

      # Draw a grid
      (SCREEN_WIDTH/CELL_SIZE).to_i.times do |x|
        (SCREEN_HEIGHT/CELL_SIZE).to_i.times do |y|
          grid_color = perlin.prng_item(x, y, colors, 2.4)
          ctx.rectangle do |r|
            r.x = x * CELL_SIZE - PADDING
            r.y = y * CELL_SIZE - PADDING
            r.width = CELL_SIZE + PADDING
            r.height = CELL_SIZE + PADDING
            r.fill =  grid_color
            r
          end
        end
      end
      (SCREEN_WIDTH/CELL_SIZE).to_i.times do |x|
        (SCREEN_HEIGHT/CELL_SIZE).to_i.times do |y|
          grid_color = perlin.prng_item(x, y, colors, 2.4)
          semi_circle_colors = colors.reject(grid_color)
          rotate_90 = perlin.prng_int(x, y, 0, 2, 59.2).zero?
          ctx.use(semicircle_left) do |u|
            u.x = x * CELL_SIZE - PADDING
            u.y = y * CELL_SIZE - PADDING
            u.fill = perlin.prng_item(x, y, 99, semi_circle_colors, 0.92)
            if rotate_90
              u.transform {|t| t.rotate(90, x*CELL_SIZE + CELL_SIZE/2, y*CELL_SIZE + CELL_SIZE/2); t}
            end
            u
          end

          ctx.use(semicircle_right) do |u|
            u.x = x * CELL_SIZE
            u.y = y * CELL_SIZE
            u.fill = perlin.prng_item(x, y, 100, semi_circle_colors, 77.2)
            if rotate_90
              u.transform {|t| t.rotate(90, x*CELL_SIZE + CELL_SIZE/2, y*CELL_SIZE + CELL_SIZE/2); t}
            end
            u
          end
        end
      end
    end
  end
end
