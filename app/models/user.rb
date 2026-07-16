class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  def self.ransackable_attributes(auth_object = nil)
    ["email", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end
end