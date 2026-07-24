module ApplicationHelper
  RESPONSIVE_IMAGE_WIDTHS = {
    small: 480,
    medium: 960,
    large: 1600,
  }.freeze

  # Renders a Shrine attachment with WebP variants when they exist, and falls
  # back to the original file while older uploads are being backfilled.
  def responsive_attachment_tag(record, attachment, variant: :medium,
                                variants: RESPONSIVE_IMAGE_WIDTHS.keys,
                                sizes: "100vw", **options)
    original = record.public_send(attachment)
    return unless original

    selected = record.public_send(attachment, variant) || original
    available_variants = variants.filter_map do |name|
      file = record.public_send(attachment, name)
      "#{file.url} #{RESPONSIVE_IMAGE_WIDTHS.fetch(name)}w" if file
    end

    full_size = record.public_send(attachment, :large) || original
    metadata = selected.metadata

    options[:srcset] = available_variants.join(", ") if available_variants.any?
    options[:sizes] = sizes if available_variants.any?
    options[:width] ||= metadata["width"]
    options[:height] ||= metadata["height"]
    options[:data] = (options[:data] || {}).merge(full_src: full_size.url)

    image_tag selected.url, **options.compact
  end
end
