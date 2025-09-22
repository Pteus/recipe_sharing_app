class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  def index
    @recipes = Current.user.recipes
                      .includes(:ingredients)
                      .order(created_at: :desc)

    if params[:search].present?
      @recipes = @recipes.where("title ILIKE ? or description ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:difficulty].present?
      @recipes = @recipes.where(difficulty_level: params[:difficulty])
    end
  end

  def show
    @recipe_ingredients = @recipe.recipe_ingredients.includes(:ingredient)


    @serving_size = @recipe.servings
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_recipe
    @recipe = Current.user.recipes.find(params[:id])
  end
end
