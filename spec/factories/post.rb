FactoryBot.define do
  factory :post do
    title { "Test Post" }
    body { "This is a test post." }
    association :author, factory: :user
  end
end