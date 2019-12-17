


FactoryBot.define do
  factory :follow_info_user do
    email { Faker::Internet.email }
    password { "password"}
    password_confirmation { "password" }

  end
end