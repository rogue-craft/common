class Interpolation::Clock
  # @param base [Time]
  #
  def initialize(base = nil)
    unless base.nil?
      @base = base
    end

    @initial = Time.new
  end

  # @param base [Float]
  #
  def base=(base)
    raise RuntimeError.new('Cannot override the base time') if @base

    @base = base
  end

  def reset
    @base = nil
  end

  # @return [Float]
  #
  def now
    @base + ((Time.new - @initial).to_f * 1000)
  end
end
