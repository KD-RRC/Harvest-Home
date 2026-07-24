class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, except: [:done]

  def index
    @cart_items = build_cart_items
    @total      = @cart_items.sum { |i| i[:subtotal] }
    @provinces  = Province.order(:name)
    @user       = current_user

    # Pre-select user's saved province if they have one
    @selected_province = Province.find_by(code: current_user.province)
  end

  def confirm
    @cart_items = build_cart_items
    @subtotal   = @cart_items.sum { |i| i[:subtotal] }
    @province   = Province.find(params[:province_id])
    @address    = build_address(params)

    # Calculate taxes
    @tax_rate   = @province.total_tax_rate
    @tax_amount = (@subtotal * @tax_rate).round(2)
    @total      = @subtotal + @tax_amount

    # Store for complete step
    session[:checkout] = {
      province_id: @province.id,
      address:     @address,
      tax_rate:    @tax_rate,
      tax_amount:  @tax_amount,
      subtotal:    @subtotal,
      total:       @total
    }
  end

  def complete
    checkout    = session[:checkout]
    province    = Province.find(checkout['province_id'])
    cart_items  = build_cart_items

    order = Order.new(
      user:              current_user,
      province:          province,
      status:            'pending',
      shipping_address:  checkout['address'],
      tax_amount:        checkout['tax_amount'],
      tax_rate_snapshot: checkout['tax_rate'],
      total_amount:      checkout['total']
    )

    if order.save
      cart_items.each do |item|
        order.order_items.create!(
          product:             item[:product],
          quantity:            item[:quantity],
          unit_price_snapshot: item[:product].current_price.amount
        )
      end

      def done
        @order = Order.find_by(id: session[:order_id])
        redirect_to root_path, alert: "No order found." unless @order
      end

      session[:cart]     = {}
      session[:checkout] = nil
      session[:order_id] = order.id
      redirect_to checkout_done_path
    else
      flash[:alert] = "There was a problem placing your order. Please try again."
      redirect_to checkout_path
    end
  end

  private

  def build_cart_items
    cart = session[:cart] || {}
    cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      { product: product, quantity: quantity,
        subtotal: product.current_price&.amount.to_f * quantity }
    end.compact
  end

  def build_address(params)
    [
      params[:address_line1],
      params[:address_line2],
      params[:city],
      params[:province_code],
      params[:postal_code],
      "Canada"
    ].reject(&:blank?).join(", ")
  end

  def ensure_cart_not_empty
    if (session[:cart] || {}).empty?
      flash[:alert] = "Your cart is empty."
      redirect_to products_path
    end
  end
end