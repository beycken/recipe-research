class HomeController < ApplicationController
   ##### First Try #####
  # def main
  #   if params["ingredients"].present?
  #     @ingredients = params["ingredients"].to_s.split(';').map{|val| "%#{val.strip}%" }
  #     @recipes = Recipe.where(id: search_recipes(@ingredients).sort_by { |recipe| -recipe.ingredients.size }.map(&:id)).paginate(page: params[:page], per_page: 50)
  #   else
  #     @recipes = Recipe.paginate(page: params[:page], per_page: 50)
  #   end
  # end

  ##### Second Try #####
  def main
    if params["ingredients"].present?
      @ingredients = params["ingredients"].to_s.split(';').map{|val| "%#{val.strip}%" }
      @recipes = search_recipes(@ingredients).group(:id).order(Arel.sql("COUNT(*) DESC")).paginate(page: params[:page], per_page: 50)
    else
      @recipes = Recipe.paginate(page: params[:page], per_page: 50)
    end
  end

  private

  def compose_request(ingredients)
    ingredients.map{|ingredient| "ingredients.name ILIKE ?"}.join(' AND ')
  end

  ##### First Try #####
  # def search_recipes(all_ingredients)
  #   final_scope = Recipe.includes(:ingredients).joins(:ingredients).where("ingredients.name ILIKE ANY ( array[?] )", all_ingredients)
  #   return final_scope if all_ingredients.one?
  #   return (final_scope.where(compose_request(all_ingredients), *all_ingredients).or(final_scope)).distinct if all_ingredients.size == 2

  #   i = 2
  #   scope_combination_tmp = final_scope
  #   (all_ingredients.size - 2 ).times do
  #     scope_combination = search_for_combination(ingredients: all_ingredients, number_combination: i, scope: scope_combination_tmp)
  #     scope_combination_tmp = scope_combination
  #     final_scope = scope_combination.or(final_scope)
  #     i += 1
  #   end
  #   (final_scope.where(compose_request(all_ingredients), *all_ingredients).or(final_scope)).distinct
  # end
  # 
  # def search_for_combination(ingredients: , number_combination:, scope: )
  #   tmp_scope = Recipe.none
  #   ingredients.combination(number_combination).each do |combination|
  #     tmp_scope = tmp_scope.or(scope.where(compose_request(combination), *combination))
  #   end
  #   tmp_scope
  # end

  ##### Second Try #####
  def search_recipes(all_ingredients)
    (1..all_ingredients.count).flat_map{|size| all_ingredients.combination(size).to_a }.inject(Recipe.none) do |acc, combination|
      acc.or(Recipe.joins(:ingredients).where(compose_request(combination), *combination))
    end
  end
end