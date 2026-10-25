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
      team_buildings_path => "séjours professionnels",
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

  test "le footer ne présente le domaine complet qu'une seule fois" do
    get root_path

    assert_select "footer .site-footer__nav" do
      assert_select "a", text: "Domaine en exclusivité", count: 1
      assert_select "a", text: "Toute la Ferme", count: 0
    end
  end

  test "l'accueil présente uniquement les trois gîtes principaux avec leurs données" do
    @gites.first.update!(capacity: 15, rooms: 6)
    @gites.second.update!(capacity: 6, rooms: 2)
    @gites.third.update!(capacity: 4, rooms: 2)
    @gites.fourth.update!(name: "Le Grand Horizon")

    get root_path

    assert_response :success
    assert_select "#gites .home-gite-card", count: 3

    [
      [@gites.first, "Grands groupes, convivialité et feu de bois"],
      [@gites.second, "Terrasse panoramique et vue sur le Condroz"],
      [@gites.third, "Plain-pied et accessibilité PMR"],
    ].each do |gite, feature|
      assert_select "#gites .home-gite-card" do |cards|
        card = cards.find { |node| node.text.include?(gite.name) }
        assert card, "Une carte doit présenter #{gite.name}"
        assert_includes card.text, "#{gite.capacity} personnes"
        assert_includes card.text, "#{gite.rooms} chambres"
        assert_includes card.text, feature
        assert_select card, "a[href='#{gite_path(gite)}']", count: 1
      end
    end

    assert_select "#gites", text: /Le Grand Horizon/, count: 0
    assert_select "#gites", text: /Toute la Ferme/, count: 0
  end

  test "l'accueil présente le domaine en exclusivité avec ses données et son lien" do
    get root_path

    assert_response :success
    assert_select ".home-domain", count: 1 do
      assert_select "h2", text: "Le domaine en exclusivité", count: 1
      assert_select ".home-domain__facts", text: /25 personnes/, count: 1
      assert_select ".home-domain__facts", text: /10 chambres/, count: 1
      assert_select ".home-domain__benefits", text: /Piscines et sauna privatisés/, count: 1
      assert_select ".home-domain__benefits", text: /Grange et mezzanine en accès exclusif/, count: 1
      assert_select ".home-domain__benefits", text: /Cuisine adaptée aux groupes/, count: 1
      assert_select ".home-domain__benefits", text: /Jardin et extérieurs réservés/, count: 1
      assert_select "a[href='#{domain_path}']", text: /Découvrir le domaine en exclusivité/, count: 1
      assert_select "img[alt='Famille et amis réunis dans le jardin de la Ferme d’Auwez']", count: 1
    end
  end

  test "la page de connexion demande aux moteurs de recherche de ne pas l’indexer" do
    get new_user_session_path

    assert_response :success
    assert_select "meta[name='robots'][content='noindex, nofollow']", count: 1
    assert_select "link[rel='canonical']", count: 0
  end
end
