# frozen_string_literal: true

if Rails.env.production?
  return
end

u = User.new(full_name: 'Solomon Boloshe')
u.email = 'solomon@link.com'
u.country = 'Ethiopia'
u.password = '12341234'
u.password_confirmation = '12341234'
u.confirm
u.save

u = User.new(full_name: 'Lee Crey')
u.email = 'lee@link.com'
u.country = 'USA'
u.password = '12341234'
u.password_confirmation = '12341234'
u.confirm
u.save

1.upto(100).each do |i|
  user = User.new({
                    full_name: Faker::Name.name,
                    email: "user#{i}@sefer.com",
                    provier_profile_url: Faker::Avatar.image,
                    biography: Faker::Quote.mitch_hedberg,
                    country: Faker::Address.country,
                  })
  user.password = '12341234'
  user.password_confirmation = '12341234'
  user.confirm
  user.save
end
