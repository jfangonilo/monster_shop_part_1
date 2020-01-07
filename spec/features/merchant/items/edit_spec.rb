# As a merchant
# When I visit my items page
# And I click the edit button or link next to any item
# Then I am taken to a form similar to the 'new item' form
# The form is pre-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
#
# name and description cannot be blank
# price cannot be less than $0.00
# inventory must be 0 or greater
# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail

require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  describe "when I visit my items page and I see a link to edit an item" do
    before :each do
      @merchant = create(:jomah_merchant)
      @merchant_employee = create(:merchant_employee, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "can click on that link to add a new item" do
        item = create(:random_item, merchant: @merchant)
        visit merchant_dash_items_path
        click_on "Edit Item"
        expect(current_path).to eq(edit_merchant_dash_item_path(item))

        expect(find_field('Name').value).to eq item.name
        expect(find_field('Price').value).to eq item.price.to_s
        expect(find_field('Description').value).to eq item.description
        expect(find_field('Image').value).to eq item.image
        expect(find_field('Inventory').value).to eq item.inventory.to_s

        name = "Chamois Butter"
        price = 18
        description = "No more chaffin'!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = 25

        fill_in "Name", with: "Chamois Butter"
        fill_in "Price", with: 18
        fill_in "Description", with: description
        fill_in "Image", with: image_url
        fill_in "Inventory", with: inventory

        click_button "Update Item"

        item.reload
        expect(current_path).to eq(merchant_dash_items_path)
        expect(item.name).to eq(name)
        expect(page).to have_content(name)
        expect(page).to have_css("img[src*='#{item.image}']")
    end

    it "will have all item details and only image can be blank" do
      item = create(:random_item, merchant: @merchant)
      visit merchant_dash_items_path
      click_on "Edit Item"
      expect(current_path).to eq(edit_merchant_dash_item_path(item))

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      inventory = 25

      fill_in "Name", with: name
      fill_in "Price", with: price
      fill_in "Description", with: description
      fill_in "Inventory", with: inventory

      click_button "Update Item"


      item.reload
      expect(current_path).to eq(merchant_dash_items_path)
      expect(item.name).to eq(name)
      expect(page).to have_content(name)
      expect(page).to have_css("img[src*='#{item.image}']")
    end

    it "will have a price greater than 0 and quantity 0 or greater" do
      item = create(:random_item, merchant: @merchant)
      visit merchant_dash_items_path
      click_on "Edit Item"
      expect(current_path).to eq(edit_merchant_dash_item_path(item))

      name = "Chamois Buttr"
      price = 0
      description = "No more chaffin'!"
      inventory = 0

      fill_in "Name", with: name
      fill_in "Price", with: price
      fill_in "Description", with: description
      fill_in "Inventory", with: inventory

      click_button "Update Item"

      expect(page).to have_content("Inventory must be greater than 0")
      expect(page).to have_content("Price must be greater than 0")
    end

    it "a merchant employee will not be able to add a new item from another shop" do
      ray = create(:ray_merchant)
      chain = create(:random_item, name: "chain", merchant: ray)
      tire = create(:random_item, merchant: ray)

      visit "merchants/#{ray.id}/items"
      expect(page).not_to have_link("Edit Item")
    end
  end
end
