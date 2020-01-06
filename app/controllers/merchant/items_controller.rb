class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
    @items = @merchant.items
  end

  def new
    @merchant = current_user.merchant
    @item = Item.new
  end

  def create
    @merchant = current_user.merchant
    @item = @merchant.items.create(item_params)
    if @item.save
      redirect_to merchant_dash_items_path
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def toggle_active
    item = Item.find(params[:item_id])
    item.toggle!(:active?)
    redirect_to "/merchant/items"
    if !item.active?
      flash[:success] = "#{item.name} is no longer for sale."
    else
      flash[:success] = "#{item.name} is now avalible for sale."
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:success] = "Item Deleted"
    redirect_to merchant_dash_items_path
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end
