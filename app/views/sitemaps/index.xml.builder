xml.instruct!

xml.sitemapindex xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @sitemaps.each do |type|
    xml.sitemap do
      xml.loc sitemap_url(type, format: :xml)
    end
  end
end
