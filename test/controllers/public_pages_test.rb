require "test_helper"

class PublicPagesTest < ActionDispatch::IntegrationTest
  setup do
    @gites = [
      create_gite(name: "Les Hirondelles"),
      create_gite(name: "L'Horizon"),
      create_gite(name: "L'Arbre de Vie"),
      create_gite(name: "Le Grand Gîte"),
      create_gite(name: "Toute la Ferme", capacity: 25, rooms: 10, sanitary: 9),
    ]
  end

  test "les principales pages publiques restent accessibles sans connexion" do
    {
      root_path => "La Ferme d",
      about_path => "La Ferme d",
      activities_path => "activit",
      team_buildings_path => "team building",
      contact_path => "Contact",
    }.each do |path, expected_text|
      get path

      assert_response :success
      assert_includes response.body.downcase, expected_text.downcase,
        "La page #{path} doit afficher son contenu public"
    end
  end

  test "le sitemap contient toutes les pages publiques et tous les gîtes, mais pas l’administration" do
    get sitemap_path

    assert_response :success
    assert_equal "application/xml", response.media_type
    [root_path, about_path, contact_path, activities_path, team_buildings_path].each do |path|
      assert_includes response.body, "#{ApplicationHelper::SEO_SITE_URL}#{path}"
    end
    @gites.each do |gite|
      assert_includes response.body, "#{ApplicationHelper::SEO_SITE_URL}#{gite_path(gite)}"
    end
    assert_not_includes response.body, admin_path
    assert_not_includes response.body, new_user_session_path
  end

  test "une page de gîte publie des données structurées avec sa capacité" do
    gite = @gites.second

    get gite_path(gite)

    structured_data = JSON.parse(
      css_select("script[type='application/ld+json']").first.text,
    )
    accommodation = structured_data.fetch("@graph").find do |item|
      item["@type"] == "Accommodation"
    end

    assert_equal gite.name, accommodation.fetch("name")
    assert_equal gite.capacity, accommodation.dig("occupancy", "maxValue")
    assert_equal gite.rooms, accommodation.fetch("numberOfBedrooms")
  end

  test "la page de connexion demande aux moteurs de recherche de ne pas l’indexer" do
    get new_user_session_path

    assert_response :success
    assert_select "meta[name='robots'][content='noindex, nofollow']", count: 1
    assert_select "link[rel='canonical']", count: 0
  end
end
