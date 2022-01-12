# Only allow a thing to happen once in the given duration
class Throttle
  def initialize(duration = 1.second)
    @duration = duration
    @mutex = Mutex.new
    @clock = Time.new(0)
  end

  def call(&block)
    @mutex.synchronize do
      # How long do we need to wait for the next call?
      wait = @duration - (Time.now - @clock)

      # Sleep if the desired duration has not elapsed
      sleep wait if wait > 0.0

      # Reset clock for next call
      @clock = Time.now
    end

    # Have a nice day, sir
    block.call
  end
end
