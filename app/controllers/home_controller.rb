class HomeController < ApplicationController
  def main
    if params["ingredients"].to_s.split(';').to_a.any?
      @ingredients = params["ingredients"].to_s.split(';').map{|val| "%#{val.strip}%" }
      @one_ingredient_matches_recipes = Recipe.includes(compositings: :ingredients).where("compositings.ingredient.name ILIKE ANY ( array[?] )", @ingredients)
      # @recipes = (get_recipes_from_ingredient + @one_ingredient_matches_recipes).uniq
      # @recipes = @one_ingredient_matches_recipes.includes(:ingredients).where("ingredients.name ILIKE ALL ( array[?] )", @ingredients)
    else
      @recipes = Recipe.all
    end
  end

  private

  def get_recipes_from_ingredient
    if @ingredients.count <= 2
      return @one_ingredient_matches_recipes.includes(:ingredients).where("ingredients.name ILIKE ALL ( array[?] )", @ingredients)
    end

    i = 2
    scope, finale_scope = Recipe.none.includes(:ingredients)
    (ingredients.count - 2).to_i.times do
      ingredients.combination(i).to_a.each do |combination_array|
        scope += @one_ingredient_matches_recipes.where("ingredients.name ILIKE ALL ( array[?] )", combination_array)
        i += 1
      end
      final_scope = scope.uniq + final_scope
    end
  end
end