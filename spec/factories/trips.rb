FactoryBot.define do
  factory :trip do
    status { 'ongoing' }
    user_id { 2 }
    vehicle_id { 1 }
    # Add other attributes as needed
  end

  factory :user do
    name { 'kabaka' }
    email { "kabaka@gmail.com" }
    # Add other attributes as needed
  end

  factory :vehicle do
    vehicle_type { 'Bus' }
    number { 12342 }
    # Add other attributes as needed
  end

  factory :location do
    longitude { 128.0 }
    latitude { 79.0 }
    # Add other attributes as needed
  end

end