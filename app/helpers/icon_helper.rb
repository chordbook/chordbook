module IconHelper
  # Render the svg icon
  def icon_tag(id, options = {})
    path = find_icon(id)
    if path
      svg = Nokogiri::XML::Document.parse(File.read(path)).children.first
      icons_to_render[id] ||= svg
    else
      raise "Could not find icon #{id.inspect} in:\n#{ICON_SOURCES.join("\n")}"
    end

    options = options.with_defaults(
      xmlns: "http://www.w3.org/2000/svg",
      viewBox: svg["viewBox"] || "0 0 20 20",
      role: "image",
      title: id
    )

    options[:class] = token_list("icon", options[:class])

    content_tag :svg, options do
      content_tag :use, nil, "xlink:href" => "#icon-#{id}"
    end
  end

  # Return a sprite of all the icons used during the current request
  def with_icon_sprite(&block)
    # Render block first to figure out which icons to render
    content = capture(&block)

    icon_sprite + content
  end

  def icon_sprite
    sprite = Nokogiri::XML::Node.new("svg", Nokogiri::XML::Document.new)
    sprite.default_namespace = "http://www.w3.org/2000/svg"
    sprite["style"] = "display: none"
    sprite["class"] = "icons"

    icons_to_render.each do |id, svg|
      svg.name = "symbol"
      svg["id"] = "icon-#{id}"
      sprite << svg
    end

    raw sprite.to_html
  end

  private

  def icons_to_render
    @icons_to_render ||= {}
  end

  # Paths to search for icons
  ICON_SOURCES = [
    "app/icons",
    "node_modules/bootstrap-icons/icons",
    "node_modules/heroicons/outline",
  ]

  def find_icon(id)
    paths = Rails.root.join("{" + ICON_SOURCES.join(",") + "}", "#{id}.svg")
    Dir.glob(paths).first
  end
end
