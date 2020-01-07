require 'rails_helper'

RSpec.describe "merchant index page" do
  it "shows an admin the merchants index page" do
    customer = create(:regular_user)
    user = create(:admin_user)
    ray = create(:ray_merchant)
    jomah = create(:jomah_merchant)
    wren = create(:wren_merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/admin/merchants"
    
    within "#merchant-#{wren.id}" do
      click_button "Disable"
    end

    within "#merchant-#{ray.id}" do
      expect(page).to have_link(ray.name)
      expect(page).to have_content(ray.city)
      expect(page).to have_content(ray.state)
      expect(page).to have_button("Disable")
    end

    within "#merchant-#{jomah.id}" do
      expect(page).to have_link(jomah.name)
      expect(page).to have_content(jomah.city)
      expect(page).to have_content(jomah.state)
      expect(page).to have_button("Disable")
    end

    within "#merchant-#{wren.id}" do
      expect(page).to have_link(wren.name)
      expect(page).to have_content(wren.city)
      expect(page).to have_content(wren.state)
      expect(page).to have_button("Enable")
    end
  end
end
# As an admin user
# When I visit the merchant's index page at "/admin/merchants"
# I see all merchants in the system
# Next to each merchant's name I see their city and state
# The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
# I see a "disable" button next to any merchants who are not yet disabled
# I see an "enable" button next to any merchants whose accounts are disabled
