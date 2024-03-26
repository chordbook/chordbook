class Duration
  attr_reader :usec

  def self.parse(input)
    if input.is_a?(String) && input.include?(":")
      min, sec = input.split(":", 2)
      seconds = (min.to_i * 60) + sec.to_f
      new(seconds * 1000)
    else
      new(input.to_f * 1000)
    end
  end

  def initialize(usec)
    @usec = usec.round
  end

  def seconds
    (usec / 1000) % 60
  end

  def minutes
    (usec / 1000) / 60
  end

  def to_s
    "%d:%02d" % [minutes, seconds]
  end
end
