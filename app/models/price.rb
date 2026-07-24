class Price < ApplicationRecord
  belongs_to :product

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :effective_date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "effective_date", "created_at", "product_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["product"]
  end
end