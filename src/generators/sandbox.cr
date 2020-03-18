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
      <filter id="displacementFilter">
        <feTurbulence type="turbulence" baseFrequency="0.05" numOctaves="4" result="turbulence"/>
        <feDisplacementMap in2="turbulence" in="SourceGraphic" scale="50" xChannelSelector="R" yChannelSelector="G"/>
        <feGaussianBlur in="SourceGraphic" stdDeviation="5" />
      </filter>

      <rect x="100" y="100" height="400" width="400" style="filter: url(#displacementFilter)"/>
    ]

    svg << %Q[</svg>]
    svg.to_s
  end
end
