require "test_helper"

class GiteTest < ActiveSupport::TestCase
  test "construit les URLs attendues pour chaque nom de gîte public" do
    expected_slugs = {
      "Les Hirondelles" => "leshirondelles",
      "L'Horizon" => "lhorizon",
      "L'Arbre de Vie" => "larbredevie",
      "Le Grand Gîte" => "legrandgîte",
      "Toute la Ferme" => "toute-la-ferme",
    }

    expected_slugs.each do |name, expected_slug|
      assert_equal expected_slug, Gite.new(name: name).to_param,
        "Le nom « #{name} » doit produire l’URL « #{expected_slug} »"
    end
  end

  test "refuse un gîte incomplet ou avec une capacité non numérique" do
    gite = Gite.new(name: "Gîte incomplet", capacity: "beaucoup")

    assert_not gite.valid?
    assert gite.errors.of_kind?(:description, :blank)
    assert gite.errors.of_kind?(:capacity, :not_a_number)
    assert gite.errors.of_kind?(:rooms, :blank)
    assert gite.errors.of_kind?(:sanitary, :blank)
  end

  test "refuse deux gîtes portant exactement le même nom" do
    create_gite(name: "Les Hirondelles")
    duplicate = Gite.new(
      name: "Les Hirondelles",
      description: "Autre description",
      capacity: 4,
      rooms: 2,
      sanitary: 1,
    )

    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:name, :taken)
  end

  test "affiche le nom et la capacité dans les listes de sélection" do
    gite = Gite.new(name: "L'Horizon", capacity: 6)

    assert_equal "L'Horizon (6 pers.)", gite.name_with_capacity
  end
end
