class Merchant::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def fulfill

  end
end