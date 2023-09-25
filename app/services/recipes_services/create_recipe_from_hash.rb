module RecipesServices
  class CreateRecipeFromHash
    attr_reader :recipe_hash

    def initialize(recipe_hash)
      @recipe_hash = recipe_hash.values.first
    end

    def call
      # binding.irb
      return unless recipe_hash
      return if Recipe.find_by(name: recipe_hash["name"])

      recipe = create_recipe
      linked_ingredients(recipe)
      recipe
    end

    private

    def create_recipe
      
      Recipe.create(
        name: recipe_hash["name"],
        rate: recipe_hash["rate"].to_i,
        people_quantity: recipe_hash["people_quantity"].to_i,
        nb_comments: recipe_hash["nb_comments"].to_i,
        difficulty: recipe_hash["difficulty"],
        author_tip: recipe_hash["author_tip"],
        budget: recipe_hash["budget"],
        prep_time: recipe_hash["prep_time"],
        cook_time: recipe_hash["cook_time"],
        total_time: recipe_hash["total_time"]
      )
    end

    def linked_ingredients(recipe)
      recipe_hash["ingredients"].each do |ingredient_string|
        ingredient = Ingredient.find_by(name: ingredient_string) || Ingredient.create(name: ingredient_string)
        Compositing.create(ingredient: ingredient, recipe: recipe)
      end
    end
  end
end