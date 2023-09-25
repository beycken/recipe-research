class Ingredient < ApplicationRecord
  has_many :compositings, dependent: :destroy
  has_many :recipes, through: :compositings
end
