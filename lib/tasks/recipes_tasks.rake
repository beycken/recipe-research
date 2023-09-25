require "json"

namespace :recipes do

  # Task that migrates the bank account for the Employees
  task create_recipes_from_json: :environment do
    file = File.open "app/assets/files/recipes-fr.json"
    data = JSON.load file

    data.each do |recipe|
      begin
        recipe_created = RecipesServices::CreateRecipeFromHash.new(recipe_hash: recipe).call
        puts "#{recipe_created.name} created"
      rescue
        puts "An error has occurred"
      end
    end
  end
end