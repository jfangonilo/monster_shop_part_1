class Item <ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, in: [true, false]
  validates_numericality_of :price, greater_than: 0

  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders, dependent: :destroy
  has_many :orders, through: :item_orders

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.active_items
    where(active?: true)
  end

  def self.by_popularity(limit = nil, order = "DESC")
    joins(:item_orders).select("items.name, sum(item_orders.quantity) as quantity").group(:id).order("quantity #{order}").limit(limit)
  end
end
