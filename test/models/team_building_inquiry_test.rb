require "test_helper"

class TeamBuildingInquiryTest < ActiveSupport::TestCase
  test "explains every missing required field in French" do
    inquiry = TeamBuildingInquiry.new

    assert_not inquiry.valid?

    %i[
      company
      contact_name
      email
      telephone
      participants
      desired_dates
      package
      message
    ].each do |field|
      assert_equal ["Ce champ est obligatoire."], inquiry.errors[field]
    end
  end

  test "provides actionable messages for invalid values" do
    inquiry = TeamBuildingInquiry.new(
      company: "Atelier Condroz",
      contact_name: "Marie Dupont",
      email: "adresse incorrecte",
      telephone: "+32 470 12 34 56",
      participants: 101,
      desired_dates: "Septembre",
      package: "inconnue",
      message: "Court",
    )

    assert_not inquiry.valid?
    assert_equal ["Saisissez une adresse e-mail valide."], inquiry.errors[:email]
    assert_equal(
      ["Le nombre de participants ne peut pas dépasser 100."],
      inquiry.errors[:participants],
    )
    assert_equal(
      ["Choisissez l’une des formules proposées."],
      inquiry.errors[:package],
    )
    assert_equal(
      ["Donnez-nous un peu plus de détails (10 caractères minimum)."],
      inquiry.errors[:message],
    )
  end
end
