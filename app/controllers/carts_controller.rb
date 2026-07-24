class CartController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @cart_items = []
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      @cart_items << {
        product: product,
        quantity: quantity,
        subtotal: product.current_price&.amount.to_f * quantity
      }
    end
    @total = @cart_items.sum { |item| item[:subtotal] }
  end

  def add
    @product = Product.find(params[:product_id])
    session[:cart] ||= {}
    session[:cart][@product.id.to_s] ||= 0
    session[:cart][@product.id.to_s] += 1
    flash[:notice] = "#{@product.name} added to cart."
    redirect_back fallback_location: products_path
  end

  def remove
    session[:cart]&.delete(params[:product_id].to_s)
    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end

  def update
    quantity = params[:quantity].to_i
    if quantity > 0
      session[:cart][params[:product_id].to_s] = quantity
      flash[:notice] = "Cart updated."
    else
      session[:cart].delete(params[:product_id].to_s)
      flash[:notice] = "Item removed from cart."
    end
    redirect_to cart_path
  end
end