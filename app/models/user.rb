class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sugangs, dependent: :destroy
  has_many :courses, through: :sugangs

  has_many :messages, dependent: :destroy

  after_create :set_default_role, if: Proc.new { User.count > 1 }

  def set_default_role
    add_role :user
  end
end
