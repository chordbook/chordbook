# Perform any method later
#
# Usage:
#   PerformableMethod.perform_later(thing, :method, *args)
#
class PerformableMethod < ApplicationJob
  queue_as :low

  def perform(target, method, *args, **kwargs)
    target.send(method, *args, **kwargs)
  end
end
