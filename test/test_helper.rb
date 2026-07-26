ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"

module TestRecords
  def create_gite(name:, **attributes)
    Gite.create!(
      {
        name: name,
        description: "Un gîte de test confortable au cœur du Condroz.",
        capacity: 8,
        rooms: 3,
        sanitary: 2,
        commun: "Piscine intérieure et jardin",
      }.merge(attributes),
    )
  end

  def create_user(email:)
    User.create!(
      email: email,
      password: "mot-de-passe-test",
      password_confirmation: "mot-de-passe-test",
    )
  end
end

class ActiveSupport::TestCase
  include TestRecords
end
