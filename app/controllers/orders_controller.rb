class OrdersController <ApplicationController

  def new
    # @user = User.find(session[:user_id])
    # if @user.nil?
    #   flash[:notice] = "You must log in to check out."
    #   redirect_to '/login'
    # end
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
