class Course < ApplicationRecord
  has_many :sugangs, dependent: :destroy
  has_many :users, through: :sugangs
  has_and_belongs_to_many :professors
end
