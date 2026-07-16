class Product < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :prices, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [true, false] }

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "sku", "stock_quantity", "active", "created_at", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["categories", "prices", "product_categories"]
  end

  def current_price
    prices.order(effective_date: :desc).first
  end
end