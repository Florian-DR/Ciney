xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  [
    root_path,
    about_path,
    contact_path,
    activities_path,
  ].each do |path|
    xml.url do
      xml.loc "#{ApplicationHelper::SEO_SITE_URL}#{path}"
    end
  end

  @sitemap_gites.each do |gite|
    xml.url do
      xml.loc "#{ApplicationHelper::SEO_SITE_URL}#{gite_path(gite)}"
      xml.lastmod gite.updated_at.iso8601
    end
  end
end
