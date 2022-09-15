FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.free_email }
    password { "12345678" }
    password_confirmation { "12345678" }
    profile { %i(admin client).sample }
  end
end
