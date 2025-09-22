class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all.order(:name)
  end

  def show
    @ingredient = Ingredient.find(params[:id])
  end

  def search
    query = params[:q]
    if query.present?
      @ingredients = Ingredient.where("name ILIKE ?", "%#{query}%")
                               .order(:name)
                               .limit(10)
    else
      @ingredients = []
    end

    render json: @ingredients.map { |ingredient|
      {
        id: ingredient.id,
        name: ingredient.name,
        category: ingredient.category
      }
    }
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      render json: {
        id: @ingredient.id,
        name: @ingredient.name,
        category: @ingredient.category,
        success: true
      }
    else
      render json: {
        success: false,
        errors: @ingredient.errors.full_messages
      }
    end
  end

  private

  def ingredient_params
    params.expect(ingredient: [ :name, :category ])
  end
end
