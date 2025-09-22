require "test_helper"

class RecipeIngredientsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get recipe_ingredients_create_url
    assert_response :success
  end

  test "should get destroy" do
    get recipe_ingredients_destroy_url
    assert_response :success
  end
end
