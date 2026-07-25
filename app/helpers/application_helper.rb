require "cgi"

module ApplicationHelper
  SEO_SITE_URL = "https://www.fermedauwez.be".freeze
  SEO_SITE_NAME = "La Ferme d’Auwez".freeze
  SEO_DEFAULT_TITLE = "Gîtes avec piscine à Ciney | La Ferme d’Auwez".freeze
  SEO_DEFAULT_DESCRIPTION = "Séjournez à la Ferme d’Auwez, au cœur du Condroz : gîtes de 4 à 25 personnes avec piscine intérieure, sauna, jardin et vue sur la campagne.".freeze
  SEO_DEFAULT_IMAGE = "coucher-de-soleil-1920.webp".freeze

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

  # A trace becomes downloadable as soon as the corresponding GPX file is
  # placed in public/gpx. Until then, the page shows a neutral placeholder.
  def gpx_available?(filename)
    Rails.root.join("public", "gpx", filename).file?
  end

  # Opens a hosted GPX file directly in gpx.studio's interactive viewer.
  def gpx_studio_url(filename)
    base_url =
      if Rails.env.production?
        "#{request.base_url}/gpx"
      else
        "https://raw.githubusercontent.com/Florian-DR/Ciney/activities/public/gpx"
      end
    file_url = "#{base_url}/#{ERB::Util.url_encode(filename)}"
    options = { files: [file_url], theme: "light" }

    "https://gpx.studio/embed?options=#{ERB::Util.url_encode(options.to_json)}"
  end

  def seo_title
    return CGI.unescapeHTML(content_for(:title).to_s).strip if content_for?(:title)
    return "Administration | #{SEO_SITE_NAME}" if controller_name == "pages" && action_name == "admin"
    return "Modifier un gîte | #{SEO_SITE_NAME}" if controller_name == "gites" && action_name == "edit"
    return "Espace privé | #{SEO_SITE_NAME}" if devise_controller?

    SEO_DEFAULT_TITLE
  end

  def seo_description
    return CGI.unescapeHTML(content_for(:description).to_s).strip if content_for?(:description)
    return "Accès réservé à l’administration de la Ferme d’Auwez." unless seo_indexable_page?

    SEO_DEFAULT_DESCRIPTION
  end

  def seo_indexable_page?
    (controller_name == "pages" && %w[home about contact activities].include?(action_name)) ||
      (controller_name == "gites" && action_name == "show")
  end

  def seo_robots
    return content_for(:robots).strip if content_for?(:robots)

    if seo_indexable_page?
      "index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1"
    else
      "noindex, nofollow"
    end
  end

  def seo_canonical_url
    path = content_for?(:canonical_path) ? content_for(:canonical_path).strip : request.path
    path = "/#{path}" unless path.start_with?("/")
    path = path.delete_suffix("/") unless path == "/"
    "#{SEO_SITE_URL}#{path}"
  end

  def seo_image_url
    image_name = content_for?(:social_image) ? content_for(:social_image).strip : SEO_DEFAULT_IMAGE
    "#{SEO_SITE_URL}#{asset_path(image_name)}"
  end

  def seo_structured_data
    canonical_url = seo_canonical_url
    lodging_id = "#{SEO_SITE_URL}/#lodging"
    webpage_id = "#{canonical_url}#webpage"

    lodging = {
      "@type": "LodgingBusiness",
      "@id": lodging_id,
      name: SEO_SITE_NAME,
      url: SEO_SITE_URL,
      email: "lafermedauwez@gmail.com",
      image: seo_image_url,
      logo: "#{SEO_SITE_URL}#{asset_path('logo-hirondelle-400.webp')}",
      address: {
        "@type": "PostalAddress",
        streetAddress: "Route d’Auwez 1",
        postalCode: "5590",
        addressLocality: "Ciney",
        addressRegion: "Namur",
        addressCountry: "BE",
      },
      geo: {
        "@type": "GeoCoordinates",
        latitude: 50.2797711,
        longitude: 5.1338991,
      },
      amenityFeature: [
        { "@type": "LocationFeatureSpecification", name: "Indoor pool", value: true },
        { "@type": "LocationFeatureSpecification", name: "Sauna", value: true },
        { "@type": "LocationFeatureSpecification", name: "Parking", value: true },
        { "@type": "LocationFeatureSpecification", name: "Garden", value: true },
      ],
      sameAs: [
        "https://www.facebook.com/fermedauwez",
        "https://instagram.com/fermedauwez",
      ],
    }

    webpage = {
      "@type": seo_webpage_type,
      "@id": webpage_id,
      url: canonical_url,
      name: seo_title,
      description: seo_description,
      inLanguage: "fr-BE",
      isPartOf: { "@id": "#{SEO_SITE_URL}/#website" },
      about: { "@id": lodging_id },
      primaryImageOfPage: {
        "@type": "ImageObject",
        url: seo_image_url,
      },
    }

    graph = [
      lodging,
      {
        "@type": "WebSite",
        "@id": "#{SEO_SITE_URL}/#website",
        url: SEO_SITE_URL,
        name: SEO_SITE_NAME,
        inLanguage: "fr-BE",
        publisher: { "@id": lodging_id },
      },
      webpage,
    ]

    unless canonical_url == "#{SEO_SITE_URL}/"
      graph << {
        "@type": "BreadcrumbList",
        "@id": "#{canonical_url}#breadcrumb",
        itemListElement: [
          {
            "@type": "ListItem",
            position: 1,
            name: "Accueil",
            item: "#{SEO_SITE_URL}/",
          },
          {
            "@type": "ListItem",
            position: 2,
            name: seo_title.split("|").first.strip,
            item: canonical_url,
          },
        ],
      }
      webpage[:breadcrumb] = { "@id": "#{canonical_url}#breadcrumb" }
    end

    if defined?(@gite) && @gite.present? && controller_name == "gites" && action_name == "show"
      accommodation_id = "#{canonical_url}#accommodation"
      graph << {
        "@type": "Accommodation",
        "@id": accommodation_id,
        name: @gite.name,
        description: seo_description,
        url: canonical_url,
        image: seo_image_url,
        occupancy: {
          "@type": "QuantitativeValue",
          maxValue: @gite.capacity,
          unitText: "personnes",
        },
        numberOfBedrooms: @gite.rooms,
        isPartOf: { "@id": lodging_id },
      }
      webpage[:mainEntity] = { "@id": accommodation_id }
    end

    { "@context": "https://schema.org", "@graph": graph }.to_json
  end

  private

  def seo_webpage_type
    return "AboutPage" if controller_name == "pages" && action_name == "about"
    return "ContactPage" if controller_name == "pages" && action_name == "contact"

    "WebPage"
  end
end
