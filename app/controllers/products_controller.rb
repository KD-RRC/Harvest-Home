class ProductsController < ApplicationController
  def index
    @products = Product.where(active: true).includes(:categories, :prices)
  end

  def show
    @product = Product.find(params[:id])
  end
end