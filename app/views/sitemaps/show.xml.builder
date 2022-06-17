xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @records.find_each do |record|
    xml.url do
      xml.loc client_url([params[:id], record.id].join("/"))
      xml.lastmod record.updated_at
    end
  end
end
