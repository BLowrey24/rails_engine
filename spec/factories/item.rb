FactoryBot.define do
  factory :item do
    name { Faker::Hipster.word }
    description { Faker::Hipster.sentence }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end