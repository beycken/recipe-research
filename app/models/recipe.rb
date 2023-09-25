class Recipe < ApplicationRecord
  has_many :compositings, dependent: :destroy
  has_many :ingredients, through: :compositings
end
