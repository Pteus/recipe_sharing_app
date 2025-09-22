class RecipeIngredientsController < ApplicationController
  before_action :set_recipe

  def create
  end

  def destroy
    @recipe_ingredient = @recipe.recipe_ingredients.find(params[:id])
    @recipe_ingredient.destroy
    redirect_to @recipe, notice: "Ingredient removed."
  end

  private

  def set_recipe
    @recipe = Current.user.recipes.find(params[:recipe_id])
  end
end
