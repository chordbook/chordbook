# Extension to actionpack-page_caching gem to render cache with custom directory
module RenderPageCache
  extend ActiveSupport::Concern
  include ActionController::Caching::Pages

  def render_cache
    file = page_cache.send(:cache_path, request.path, nil)
    render file: file if File.exists?(file)
  end

  class_methods do
    def caches_page(*actions)
      super
      before_action :render_cache, only: actions
    end
  end
end
