class ContentController < ApiController
  skip_before_action :authenticate!

  def ping
    # Execute empty query to ensure database access
    ActiveRecord::Base.connection.execute("")
    Searchkick.client.ping

    head :ok
  end

  CHANGELOG = Commonmarker.to_html(Rails.root.join("Changelog.md").read, options: {parse: {smart: true}, render: {unsafe: true}})
  def changelog
    render json: CHANGELOG.to_json
  end
end
