class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @category = Category.find_by(id: params[:category_id])

    @products = Product.where(active: true)

    if @query.present?
      @products = @products.where(
        "name ILIKE :q OR description ILIKE :q OR sku ILIKE :q",
        q: "%#{@query}%"
      )
    end

    if @category
      @products = @products.joins(:product_categories)
                           .where(product_categories: { category_id: @category.id })
    end

    @products = @products.includes(:prices, :categories)
    @categories = Category.all.order(:name)
  end
end