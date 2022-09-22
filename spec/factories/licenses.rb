FactoryBot.define do
  factory :license do
    key { "MyString" }
    platform { 1 }
    status { 1 }
    game { nil }
  end
end
