require "kemal"
require "perlin_noise"

require "./macros"

require "./generators/**"

# IDEAS FOR APP 
# AUTOMATICALLY GENERATES A VARIETY OF AUTOMATICALLY GENERATED ART
# Broken up by the different generators
# Each generator is given 1 minute to make new art
# When the time is up all the art is collected, posted to the site, and then zipped with others from that day
# Zip backups available monthly.
#  - Organise with likes

get "/" do |env|
  render_layout "chromatic_aberration"
end

Kemal.run