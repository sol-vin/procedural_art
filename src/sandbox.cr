require "perlin_noise"

5.times do
  p = PerlinNoise.new(rand(Int32::MAX))
  a = [] of Int32
  100.times do |x|
    100.times do |y|
      a << p.prng_int(x, y, 0, 10)
    end
  end
  a_t = a.tally
  a_t.keys.sort.each do |k|
    print k
    print " -> "
    print a_t[k]
    print ","
  end
  puts
end