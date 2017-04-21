class Message < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
