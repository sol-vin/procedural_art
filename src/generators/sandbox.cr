class Art::Generator::Sandbox
  property width = 800
  property height = 800

  def initialize(seed, @width = 800, @height = 800)
    @perlin = PerlinNoise.new(seed)
  end

  def next
    svg = String::Builder.new
    svg << %Q[<svg height="#{height}" width="#{width}">]

    svg << %Q[<rect id="background" x="0" y="0" height="#{height}" width="#{width}" style="fill:white"/>]

    svg << %Q[
      <defs>
        <clipPath id="cut-off-bottom">
          <rect x="0" y="0" width="200" height="100" />
        </clipPath>
      </defs>
    
      <circle cx="100" cy="100" r="100" clip-path="url(#cut-off-bottom)" />
    ]

    svg << %Q[</svg>]
    svg.to_s
  end
end
