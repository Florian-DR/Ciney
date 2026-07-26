require "test_helper"

class HomePagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @home_page = HomePage.create!
  end

  test "redirige un visiteur non connecté vers la connexion" do
    get edit_home_page_path(@home_page)

    assert_redirected_to new_user_session_path
  end

  test "interdit l’édition à un compte connecté qui n’est pas le premier utilisateur" do
    create_user(email: "premier@example.com")
    other_user = create_user(email: "autre@example.com")
    sign_in other_user

    get edit_home_page_path(@home_page)

    assert_response :forbidden
  end

  test "affiche le formulaire d’édition de la page d’accueil au premier utilisateur" do
    first_user = create_user(email: "gestionnaire@example.com")
    sign_in first_user

    get edit_home_page_path(@home_page)

    assert_response :success
    assert_select "form[action='#{home_page_path(@home_page)}']", count: 1
  end
end
