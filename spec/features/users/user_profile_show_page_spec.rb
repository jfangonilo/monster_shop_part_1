require 'rails_helper'

RSpec.describe "user profile show page" do
  it "shows the user's profile page with info" do
    regular_user = User.create!(name: "Becky",
                               address: "123 Main",
                               city: "Broomfield",
                               state: "CO",
                               zip: 80020,
                               email: "go@foogle.com",
                               password: "notsecure123")

    visit '/merchants'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: "go@foogle.com"
    fill_in :password, with: "notsecure123"
    click_button "Log In"

    expect(current_path).to eq("/profile")

    expect(page).to_not have_link("My Orders")

    expect(page).to have_content("Welcome go@foogle.com")
    expect(page).to have_content(regular_user.name)
    expect(page).to have_content(regular_user.address)
    expect(page).to have_content(regular_user.city)
    expect(page).to have_content(regular_user.state)
    expect(page).to have_content(regular_user.zip)
    expect(page).to have_content(regular_user.email)
    expect(page).to have_link("Edit Your Profile")
  end

  it "can click link that redirect to see users orders" do 
    regular_user = User.create!(name: "Becky",
                               address: "123 Main",
                               city: "Broomfield",
                               state: "CO",
                               zip: 80020,
                               email: "go@foogle.com",
                               password: "notsecure123")

    visit '/merchants'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: "go@foogle.com"
    fill_in :password, with: "notsecure123"
    click_button "Log In"

    expect(current_path).to eq("/profile")

    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    brian = Merchant.create(name: "Brian's Dog Shop", address: '123 Dog Rd.', city: 'Denver', state: 'CO', zip: 80204)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    pulltoy = brian.items.create(name: "Pulltoy", description: "It'll never fall apart!", price: 14, image: "https://www.valupets.com/media/catalog/product/cache/1/image/650x/040ec09b1e35df139433887a97daa66f/l/a/large_rubber_dog_pull_toy.jpg", inventory: 7)


    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

    name = "Bert"
    address = "123 Sesame St."
    city = "NYC"
    state = "New York"
    zip = 10001

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip

    click_button "Create Order"

    visit "/profile"

    click_on "My Orders"

    expect(current_path).to eq("/profile/orders")

  end
end


