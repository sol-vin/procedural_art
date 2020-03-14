require "kemal"
require "perlin_noise"

require "./macros"

get "/" do |env|
  render_layout "test"
end

Kemal.run