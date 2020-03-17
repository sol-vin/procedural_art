class Art::Generator::Skeleton
  property width = 800
  property height = 800

  def initialize(seed, @width = 800, @height = 800)
    @perlin = PerlinNoise.new(seed)
  end

  def next
    svg = String::Builder.new
    svg << %Q[<svg height="#{height}" width="#{width}">]

    svg << %Q[<rect id="background" x="0" y="0" height="#{height}" width="#{width}" style="fill:white"/>]

    svg << %Q[</svg>]
    svg.to_s
  end
end
