FactoryBot.define do
  factory :license do
    sequence(:key) { |n| "License #{n}" }
    platform { %i(steam battle_net origin).sample }
    status { :available }
    game
  end
end
