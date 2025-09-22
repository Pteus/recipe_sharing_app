class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true

  # Common units for validation/dropdown
  UNITS = %w[cups tablespoons teaspoons ounces pounds grams kilograms liters milliliters pieces cloves].freeze
  validates :unit, inclusion: { in: UNITS }

  def display_quantity
    "#{quantity} #{unit}"
  end
end
