

FactoryBot.define do
  factory :follow_info_user do
    email { Faker::Internet.email }
    password { "password"}
    password_confirmation { "password" }

  end

  sequence :i_follow_nbr do |n|
    #{n}
  end

  factory :user do
  end

  factory :pif, parent: :user do
    i_follow { true }
    i_follow_nbr
  end

end