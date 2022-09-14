FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Name #{n}" }
    operational_system { Faker::Computer.os }
    storage { "15gb" }
    processor { "Intel i5" }
    memory { "8gb" }
    video_board { "GeForce X" }
  end
end
