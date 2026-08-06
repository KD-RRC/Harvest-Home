# Represents a product in the Harvest & Home marketplace
# Products belong to vendors (future) and have price history via the prices table
class Product < ApplicationRecord
  
  # Relationships #
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :prices, dependent: :destroy
  has_one_attached :image


  # Model Validations #
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

  def on_sale?
    prices.count > 1 && current_price.amount < prices.order(effective_date: :asc).first.amount
  end
  
  def new?
    created_at >= 3.days.ago
  end
end