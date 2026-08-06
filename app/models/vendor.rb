class Vendor < ApplicationRecord
  belongs_to :user
  validates :business_name, presence: true
  validates :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["business_name", "description", "approved", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end