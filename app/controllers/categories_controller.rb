class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(:products)
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.where(active: true).includes(:prices)
  end
end