FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100..400, as_string: false) }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/images/product_image.png')) }
    status { :available }
    featured { true }
    
    after :build do |product|
      product.productable ||= create(:game)
    end
  end
end
