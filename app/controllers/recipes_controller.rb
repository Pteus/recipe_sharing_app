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
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_recipe
    @recipe = Current.user.recipes.find(params[:id])
  end

  def recipe_params
    params.expect(recipe: [ :title, :description, :instructions, :prep_time, :cook_time, :servings, :difficulty_level ])
  end
end
