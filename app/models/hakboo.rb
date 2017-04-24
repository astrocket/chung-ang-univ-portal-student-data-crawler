class Hakboo < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :professors
  has_and_belongs_to_many :courses
end
