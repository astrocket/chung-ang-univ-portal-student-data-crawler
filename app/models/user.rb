class User < ApplicationRecord
  rolify
  validates :student, uniqueness: { message: "이미 가입된 학번입니다. 본인의 학번이 맞다면 개발자에게 신고해주세요." }, allow_blank: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  def timeout_in
    return 1.year if self.has_role? :admin
    2.hours
  end

  has_many :sugangs, dependent: :destroy
  has_many :courses, through: :sugangs
  has_and_belongs_to_many :hakboos

  has_many :messages, dependent: :destroy

  after_create :set_default_role, if: Proc.new { User.count > 1 }

  def set_default_role
    add_role :user
  end
end
