class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user  = order.user
    mail(to: @user.email, subject: "Your Harvest & Home Order ##{order.id} is confirmed!")
  end
end