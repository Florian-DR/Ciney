require "test_helper"

class GitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @gites = [
      create_gite(name: "Les Hirondelles"),
      create_gite(name: "L'Horizon"),
      create_gite(name: "L'Arbre de Vie"),
      create_gite(name: "Le Grand Gîte"),
      create_gite(name: "Toute la Ferme", capacity: 25, rooms: 10, sanitary: 9),
    ]
  end

  test "rend publiquement la page adaptée à chacun des cinq gîtes" do
    expected_texts = {
      "Les Hirondelles" => "Un gîte spacieux et chaleureux",
      "L'Horizon" => "Un gîte lumineux avec une vue imprenable",
      "L'Arbre de Vie" => "Le refuge idéal pour un séjour",
      "Le Grand Gîte" => "Un gîte de groupe au cœur du Condroz",
      "Toute la Ferme" => "La Ferme d’Auwez dans son intégralité",
    }

    @gites.each do |gite|
      get gite_path(gite)

      assert_response :success
      assert_includes response.body, expected_texts.fetch(gite.name),
        "La page de « #{gite.name} » doit utiliser son contenu dédié"
    end
  end

  test "répond 404 pour une URL de gîte qui n’existe pas" do
    assert_raises ActiveRecord::RecordNotFound do
      get gite_path(name: "gite-inconnu")
    end
  end

  test "redirige un visiteur non connecté avant toute modification" do
    get edit_gite_path(@gites.first)

    assert_redirected_to new_user_session_path
  end

  test "interdit la modification à un compte connecté qui n’est pas le premier utilisateur" do
    create_user(email: "premier@example.com")
    other_user = create_user(email: "autre@example.com")
    sign_in other_user

    patch gite_path(@gites.first), params: {
      gite: valid_update_params(name: "Nom non autorisé"),
    }

    assert_response :forbidden
    assert_equal "Les Hirondelles", @gites.first.reload.name
  end

  test "permet au premier utilisateur de modifier un gîte et partage les équipements communs" do
    first_user = create_user(email: "gestionnaire@example.com")
    sign_in first_user

    patch gite_path(@gites.first), params: {
      gite: valid_update_params(commun: "Piscine, sauna et grand jardin"),
    }

    assert_redirected_to gite_path(@gites.first)
    assert_equal "Piscine, sauna et grand jardin", @gites.first.reload.commun
    assert @gites.drop(1).all? { |gite| gite.reload.commun == "Piscine, sauna et grand jardin" },
      "Les équipements communs doivent rester identiques sur tous les gîtes"
  end

  test "ne modifie aucun équipement commun quand les nouvelles données sont invalides" do
    first_user = create_user(email: "gestionnaire@example.com")
    sign_in first_user
    original_values = @gites.to_h { |gite| [gite.id, gite.commun] }

    patch gite_path(@gites.first), params: {
      gite: valid_update_params(capacity: "", commun: "Valeur à ne pas enregistrer"),
    }

    assert_response :unprocessable_entity
    @gites.each do |gite|
      assert_equal original_values.fetch(gite.id), gite.reload.commun,
        "Un formulaire invalide ne doit modifier aucun gîte"
    end
  end

  private

  def valid_update_params(overrides = {})
    {
      name: @gites.first.name,
      description: @gites.first.description,
      capacity: @gites.first.capacity,
      rooms: @gites.first.rooms,
      sanitary: @gites.first.sanitary,
      commun: @gites.first.commun,
    }.merge(overrides)
  end
end
