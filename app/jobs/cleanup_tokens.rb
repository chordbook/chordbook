class CleanupTokens < ApplicationJob
  queue_as :low

  def perform
    AccessToken.cleanup
  end
end
