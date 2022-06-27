require "test_helper"

class SitemapsControllerTest < ActionDispatch::IntegrationTest
  test "/sitemaps.xml" do
    get sitemaps_url(format: "xml")
    assert_response :success
    assert_select "sitemapindex>sitemap>loc", 5
  end

  SitemapsController::SITEMAPS.keys.each do |type|
    test "/sitemaps/#{type}.xml" do
      record = create type.to_s.singularize
      get sitemap_url(type, format: "xml")
      assert_response :success

      assert_select "urlset>url>loc", client_url("#{type}/#{record.to_param}")
    end
  end
end
