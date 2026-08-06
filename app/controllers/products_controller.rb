class ProductsController < ApplicationController
  def index
    @filter = params[:filter]

    @products = case @filter
                when 'new'
                  Product.where(active: true)
                         .where(created_at: 30.days.ago..)
                         .includes(:categories, :prices)
                         .order(created_at: :desc)
                when 'sale'
                  sale_ids = Product.joins(:prices)
                                    .group('products.id')
                                    .having('COUNT(prices.id) > 1')
                                    .pluck(:id)
                  Product.where(id: sale_ids, active: true)
                         .includes(:categories, :prices)
                         .order(created_at: :desc)
                else
                  Product.where(active: true)
                         .includes(:categories, :prices)
                         .order(created_at: :desc)
                end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end