# Sample ingredients
vegetables = [
  { name: "Carrot", category: "Vegetables" },
  { name: "Garlic", category: "Vegetables" },
  { name: "Onion", category: "Vegetables" }
]

meats = [
  { name: "Cow Beef", category: "Meat" },
  { name: "Chicken Breast", category: "Meat" }
]

seasonings = [
  { name: "Salt", category: "Seasonings" },
  { name: "Pepper", category: "Seasonings" }
]

# Create the ingredients
(vegetables + meats + seasonings).each do |ingredient_data|
  Ingredient.find_or_create_by(name: ingredient_data[:name]) do |ingredient|
    # this only runs if the ingredient is new, i.e., being created
    ingredient.category = ingredient_data[:category]
  end
end

# Create a user
user = User.find_or_create_by(email_address: "mail@mail.com") do |user|
  user.username = "username"
  user.password = "password"
  user.password_confirmation = "password"
end

# Create a recipe
pasta_recipe = Recipe.find_or_create_by(title: "Pasta") do |recipe|
  recipe.user = user
  recipe.description = "A simple pasta recipe"
  recipe.instructions = "Boil water, add pasta, cook for 10 minutes"
  recipe.prep_time = 2
  recipe.cook_time = 5
  recipe.difficulty_level = "Easy"
  recipe.servings = 3
end

# Add ingredients to the recipe
recipe_ingredients = [
  { ingredient: "Roma Tomatoes", quantity: 4, unit: "pieces", notes: "diced" },
  { ingredient: "Yellow Onion", quantity: 1, unit: "pieces", notes: "chopped" },
  { ingredient: "Garlic", quantity: 3, unit: "cloves", notes: "minced" },
  { ingredient: "Olive Oil", quantity: 2, unit: "tablespoons", notes: "" },
  { ingredient: "Salt", quantity: 1, unit: "teaspoons", notes: "to taste" },
  { ingredient: "Black Pepper", quantity: 0.5, unit: "teaspoons", notes: "freshly ground" }
]

recipe_ingredients.each do |ri_data|
  ingredient = Ingredient.find_by(name: ri_data[:ingredient])
  RecipeIngredient.find_or_create_by(
    recipe: pasta_recipe,
    ingredient: ingredient
  ) do |ri|
    ri.quantity = ri_data[:quantity]
    ri.unit = ri_data[:unit]
    ri.notes = ri_data[:notes]
  end
end

puts "Created #{Ingredient.count} ingredients"
puts "Created #{Recipe.count} recipes"
puts "Created #{RecipeIngredient.count} recipe ingredients"
