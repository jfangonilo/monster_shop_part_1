require 'rails_helper'

RSpec.describe 'merchant new page', type: :feature do
  before :each do
    @user = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end
  describe 'As a user' do
    it 'I can create a new merchant' do
      visit '/merchants/new'

      name = "Sal's Calz(ones)"
      address = '123 Kindalikeapizza Dr.'
      city = "Denver"
      state = "CO"
      zip = 80204

      fill_in "Name", with: name
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip

      click_button "Create Merchant"

      new_merchant = Merchant.last

      expect(current_path).to eq('/merchants')
      expect(page).to have_content(name)
      expect(new_merchant.name).to eq(name)
      expect(new_merchant.address).to eq(address)
      expect(new_merchant.city).to eq(city)
      expect(new_merchant.state).to eq(state)
      expect(new_merchant.zip).to eq(zip)
    end
    it 'I cant create a merchant if all fields are not filled in' do
      visit '/merchants/new'

      name = "Sal's Calz(ones)"
      address = ''
      city = "Denver"
      state = ""
      zip = 80204

      fill_in "Name", with: name
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip

      click_button "Create Merchant"

      expect(page).to have_content("Address can't be blank and State can't be blank")
      expect(page).to have_button("Create Merchant")
    end

  end
end
