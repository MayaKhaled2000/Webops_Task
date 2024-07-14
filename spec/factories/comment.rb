FactoryBot.define do
    factory :comment do
      # other attributes
      user { association :user }  # Assuming you have a factory for the User model
      post {association :post}
    end
  end