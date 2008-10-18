Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :store_name do |n|
  "Store #{n}"
end

Factory.sequence :item_name do |n|
  "#{n*3} strawberries"
end

Factory.define :user do |user|
  user.email { Factory.next :email }
  user.password "password"
  user.password_confirmation "password"
  user.location "41 Winter St. Floor 3, Boston, MA 02108"
end

Factory.define :store do |store|
  store.name { Factory.next :store_name }
  store.location "41 Winter St. Floor 3, Boston, MA 02108"
end

Factory.define :item do |item|
  item.name { Factory.next :item_name }
end

Factory.define :purchase do |purchase|
  purchase.association :user
  purchase.association :store
  purchase.item_name   'strawberries'
  purchase.price       2.45
  purchase.quantity    'two bushels'
end

Factory.alias /(.*)_name/, '\1_id'
Factory.alias /(.*)_id/, '\1_name'
Factory.alias /(.*)_name/, '\1'
Factory.alias /(.*)/, '\1_name'
Factory.alias /latitude/, 'location'
Factory.alias /longitude/, 'location'
Factory.alias /location/, 'latitude'
Factory.alias /location/, 'longitude'
