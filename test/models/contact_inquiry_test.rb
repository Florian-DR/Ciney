require "test_helper"

class ContactInquiryTest < ActiveSupport::TestCase
  test "validates the contact fields" do
    inquiry = ContactInquiry.new(
      name: "Dupont",
      first_name: "Marie",
      email: "marie@example.com",
      telephone: "+32 470 12 34 56",
      message: "Bonjour, je souhaite obtenir davantage d’informations.",
    )

    assert_predicate inquiry, :valid?
    assert_equal "Marie Dupont", inquiry.full_name
  end

  test "rejects invalid contact data" do
    inquiry = ContactInquiry.new(email: "incorrect", message: "Court")

    assert_not inquiry.valid?
    assert_includes inquiry.errors[:email], "Saisissez une adresse e-mail valide."
    assert_includes inquiry.errors[:message], "Donnez-nous un peu plus de détails (10 caractères minimum)."
  end
end
