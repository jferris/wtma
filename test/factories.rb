Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :store_name do |n|
  "Store #{n}"
end

Factory.define :user do |user|
  user.email { Factory.next :email }
  user.password "password"
  user.password_confirmation "password"
end

Factory.define :store do |store|
  store.name { Factory.next :store_name }
  store.location "41 Winter St. Floor 3, Boston, MA 02108"
  store.latitude 42.355835
  store.longitude -71.061849
end
