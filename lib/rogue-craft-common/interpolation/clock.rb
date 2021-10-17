class Interpolation::Clock
  # @param base [Time]
  #
  def initialize(base = nil)
    if base
      @base = base.to_f * 1000
    end

    @initial = Time.new
  end

  # @param base [Time]
  #
  def base=(base)
    raise RuntimeError.new('Cannot override the base time') if @base

    @base = base.to_f * 1000
  end

  # @return [Float]
  #
  def now
    @base + ((Time.new - @initial).to_f * 1000)
    # @base + ((@base - Time.new).to_f * 1000)
  end
end
