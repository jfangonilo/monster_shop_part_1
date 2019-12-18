require 'rails_helper'

RSpec.describe UserOrder, type: :model do
  describe "relationships" do
    it {should belong_to :user}
    it {should belong_to :order}
  end
end
